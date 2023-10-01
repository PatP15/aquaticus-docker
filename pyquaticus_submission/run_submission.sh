#!/bin/bash

# Prompt the user for each variable
read -p "Enter boat name (e.g., u, v, s, t): " BOAT_NAME
read -p "Enter boat role (e.g., red_one, blue_one, red_two, blue_two): " BOAT_ROLE
echo $BOAT_ROLE
read -p "Enter log path: " LOGPATH
read -p "Enter time warp (default 4): " TIME_WARP
read -p "Enter policy directory (default will be ./policies/\$BOAT_NAME/): " POLICY_DIR
read -p "Enter number of players per team (default 2): " NUM_PLAYERS
read -p "Is it a simulation? (yes/no, default no): " SIM_INPUT

# Default values if the user left any field blank
TIME_WARP=${TIME_WARP:-4}
POLICY_DIR=${POLICY_DIR:-./policies/$BOAT_NAME/}
NUM_PLAYERS=${NUM_PLAYERS:-2}
SIMULATION=${SIM_INPUT:-"no"}

# Convert simulation input to true/false for the python command
if [ "$SIMULATION" == "yes" ]; then
    SIMULATION="true"
else
    SIMULATION="false"
fi

# Run your command using the provided values
./launch_pyquaticus.sh --boat-name $BOAT_NAME --boat-role $BOAT_ROLE --logpath=$LOGPATH --time-warp $TIME_WARP --policy-dir $POLICY_DIR --num-players $NUM_PLAYERS --sim $SIMULATION
