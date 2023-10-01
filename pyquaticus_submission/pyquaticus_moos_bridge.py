import argparse
import time


from pyquaticus.moos.pyquaticus_moos_bridge import PyQuaticusMoosBridge
from pyquaticus.moos.config import WestPointConfig
from ray.rllib.policy.policy import Policy
boat_ports = {
    'blue_one': 9015,
    'blue_two': 9016,
    'red_one': 9011,
    'red_two': 9012
}

boat_ips = {
    's': "192.168.1.12",
    't': "192.168.1.22",
    'u': "192.168.1.32",
    'v': "192.168.1.42",
    'w': "192.168.1.52",
    'x': "192.168.1.62",
    'y': "192.168.1.72",
    'z': "192.168.1.82"
}

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Run the simulation with trained agents.")
    parser.add_argument('--sim', required=True, choices=['true', 'false'], help="Specify if simulation or not.")
    parser.add_argument('--color', required=True, choices=['red', 'blue'], help="Specify if red or blue team is the trained agent.")
    parser.add_argument('--policy-dir', required=True, help="Directory containing policy file.")
    parser.add_argument('--boat_id', required=True, choices=["blue_one", "blue_two", "red_one", "red_two"], help="Specify the boat name.")
    parser.add_argument('--boat_name', required=False, choices=['s', 't', 'u', 'v', 'w', 'x', 'y', 'z'], help="Specify the boat name.")
    parser.add_argument('--num-players', required=True, type=int, help="Specify the number of players on each team.")
 
    args = parser.parse_args()

    if args.sim == 'True':
        print("Simulation mode")
        server = "localhost"
    else:
        server = boat_ips[args.boat_name]
    
    boat_ids = list(boat_ports.keys())
    teammates = [bid for bid in boat_ids if bid.startswith(args.color) and bid != args.boat_id][:args.num_players-1]  # Exclude the specified boat_id and limit to num_players
    opponents = [bid for bid in boat_ids if not bid.startswith(args.color)][:args.num_players]

    print(f"Teammates: {teammates}")
    print(f"Opponents: {opponents}")

    watcher = PyQuaticusMoosBridge(server, args.boat_id, boat_ports[args.boat_id],
                      teammates, opponents, moos_config=WestPointConfig(), 
                      quiet=False)


    # Use the `from_checkpoint` utility of the Policy class:
    # policy = Policy.from_checkpoint(args.policy_dir)

    # Catch Ctrl-C

    try:
        obs = watcher.reset()
        action_space = watcher.action_space
        while True:
            # action = policy.compute_single_action(obs[args.boat_id])[0]
            obs, _, _, _, _ = watcher.step(action_space.sample())
        print("Finished loop")

    finally:
        print("Interrupted by user")
        watcher.close()