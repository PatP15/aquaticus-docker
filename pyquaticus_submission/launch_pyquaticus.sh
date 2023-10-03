#!/bin/bash

# To run just launch_pyquatcius use:
# ./launch_pyquaticus.sh --boat-name u --boat-role blue_one --logpath=./logs/ --time-warp 4 --policy-dir ./policies/u/ --num-players 2 --sim


TIME_WARP=4
CMD_ARGS=""
NO_HERON=""
LOGPATH=""
COLOR=""

#-------------------------------------------------------
#  Part 1: Check for and handle command-line arguments
#-------------------------------------------------------
for ARGI; do
    case "$ARGI" in
        -h|--help)
            HELP="yes"
            ;;
        -n|--num-players)
            # shift
            NUM_PLAYERS="$1"
            ;;
        --logpath=*)

            LOGPATH="${ARGI#--logpath=}"
            ;;
        -b|--boat-name)
            shift
            if [[ "s t u v w x y z" =~ "$1" ]]; then
                BOAT_NAME="$1"
            else
                echo "Error: Invalid boat name. Accepted names are: s, t, u, v, w, x, y, z."
                exit 1
            fi
            ;;
        -s|--sim)
            SIMULATION="true"
            ;;
        -r|--boat-role)
            if [[ "red_one blue_one red_two blue_two" =~ "$1" ]]; then
                BOAT_ROLE="$1"
                # Infer the color from the boat role
                if [[ "$BOAT_ROLE" =~ "red" ]]; then
                    COLOR="red"
                else
                    COLOR="blue"
                fi
            else
                echo "Error: Invalid boat role. Accepted roles are: red_one, blue_one, red_two, blue_two."
                exit 1
            fi
            ;;
        -t|--time-warp)
            TIME_WARP="$1"
            ;;
        *)
            CMD_ARGS="$CMD_ARGS $ARGI"
            ;;
    esac
    shift
done

echo ""
echo "Logpath: ${LOGPATH}"
echo "Num players: ${NUM_PLAYERS}"
echo "Boat name: ${BOAT_NAME}"
echo "Boat role: ${BOAT_ROLE}"
echo "Time warp: ${TIME_WARP}"
echo "Simulation: ${SIMULATION}"
echo "Color: ${COLOR}"
echo ""

if [ "${HELP}" = "yes" ]; then
  echo "Usage: $0 [SWITCHES]"
  echo "  -t, --time-warp XX      : Set the time warp (default is 4)."
  echo "  -p, --policy-dir PATH   : Specify the policy directory (default is ./policies/BOAT_NAME/)."
  echo "  -n, --num-players NUM   : Specify the number of players per team (default is 2)."
  echo "  -ns, --no_shoreside     : Do not launch the shoreside."
  echo "  -j, --just_build        : Just build files; no vehicle launch."
  echo "  -l, --logpath=PATH      : Specify the log path."
  echo "  -b, --boat-name NAME    : Specify the boat name (e.g., u, v, s, t)."
  echo "  -s, --sim               : Launch in simulation mode."
  echo "  -r, --boat-role ROLE    : Specify the boat role (e.g., red_one, blue_one, red_two, blue_two). Color is derived from the role."
  echo "  -h, --help              : Display this help and exit."
  exit 0;
fi


#-------------------------------------------------------
#  Part 2: Launching herons
#-------------------------------------------------------
if [[ -z $NO_HERON ]]; then
  cd ../missions_pyquaticus/surveyor
  if [ "$BOAT_ROLE" == "blue_one" ]; then
    ./launch_surveyor.sh $BOAT_NAME b1 b2 $TIME_WARP --logpath=$LOGPATH $([ "$SIMULATION" == "true" ] && echo "--sim") --start-x=230 --start-y=78 --start-a=60 --role=CONTROL > /dev/null &
  elif [ "$BOAT_ROLE" == "blue_two" ]; then
    ./launch_surveyor.sh $BOAT_NAME b2 b1 $TIME_WARP --logpath=$LOGPATH $([ "$SIMULATION" == "true" ] && echo "--sim") --start-x=230 --start-y=78 --start-a=60 --role=CONTROL > /dev/null &
  fi

  
  if [ "$BOAT_ROLE" == "red_one" ]; then
    ./launch_surveyor.sh $BOAT_NAME r1 r2 $TIME_WARP --logpath=$LOGPATH $([ "$SIMULATION" == "true" ] && echo "--sim") --start-x=230 --start-y=78 --start-a=60 --role=CONTROL > /dev/null &
  elif [ "$BOAT_ROLE" == "red_two" ]; then
    ./launch_surveyor.sh $BOAT_NAME r2 r1 $TIME_WARP --logpath=$LOGPATH $([ "$SIMULATION" == "true" ] && echo "--sim") --start-x=230 --start-y=78 --start-a=60 --role=CONTROL > /dev/null &
  fi
fi
sleep 3
#-------------------------------------------------------
#  Part 3: Launch the python script
#-------------------------------------------------------
cd ../../pyquaticus_submission
echo "Running pyquaticus_moos_bridge.py"

# echo "python3 solution.py $([ "$SIMULATION" == "true" ] && echo "--sim") --color $COLOR --policy-dir $POLICY_DIR --boat_id $BOAT_ROLE --num-players $NUM_PLAYERS --boat_name $BOAT_NAME --timewarp $TIME_WARP"
python3 solution.py $([ "$SIMULATION" == "true" ] && echo "--sim") --color $COLOR --boat_id $BOAT_ROLE --num-players $NUM_PLAYERS --boat_name $BOAT_NAME --timewarp $TIME_WARP

