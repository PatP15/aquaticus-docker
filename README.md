# aquaticus-docker
This repo hosts the docker that will be on the robots for the Aquaticus competition.
The goal of this repository is to create a standardized docker container that will exist on the robots. This will allow you to test your submission before the competition and allow us to quickly run your submission on the robots. The only files you will need to modify are the files in the pyquaticus_submission directory. The other files are for the docker and the bridge over to the MOOS environment which should not be edited.

If you just would like to run your agents in MOOS, you do not need to build the docker. You can follow the steps below to run your submission in MOOS.

## Docker Installation
The docker is mainly necessary for running the agents on the boats. There will be a docker image that is built on each robot. Then by running the `run_submission.sh` script, a docker container will be created from the docker image and the agents will be run in the MOOS environment. Your submission will be in the pyquaticus_submission directory which will be mounted in the docker, so the only files that need to be copied to the robot are whatever is in the pyquaticus_submission directory. If you would like to test the docker locally, you can build it yourself by following the steps in the Local Installation section.

Below are the commands necessary to set up the docker:

```
# Build the docker in the base directory (ideally the robot)
sudo docker build -t pyquaticus:base .
```
To check if it is built run this command and you should see the pyquaticus:test image

```
sudo docker images
```

Once it is built, there is a directory in the docker called pyquaticus_submission which is where we will be mounting our local pyquaticus_submission. If you would like to enter the docker for debugging purposes and toi explore the docker yourself run the following command:

```
# Enters the docker and mounts a volume to the logs directory on the host computer
sudo docker run -it -v ./pyquaticus_submission:/home/moos/pyquaticus_submission --net host --entrypoint /bin/bash --name debug pyquaticus:base 
```

Ensure you update the path `./pyquaticus_submission` to match the actual directory path on your local computer. By doing this, you'll mount the directory to Docker, which will:

- Reflect live edits from your local files within Docker.
- Store all logs within the `pyquaticus_submission/logs` directory for organization.

**Flags Explanation**:
- `--net host`: Essential for Docker's communication with the MOOS environment.
- `--entrypoint /bin/bash`: Enables Docker's interactive mode.
- `pyquaticus:base`: Refers to the Docker image name you created in the prior step which you can change to your choosing.
- '--name debug': This flag is optional. If you would like to name the docker container you are creating, you can add this flag.


To run the the entry without entering the docker and only run the `run_submission.sh script`, you can run `run_docker.sh` with the appropriate flags:

```
# Runs the run_submission.sh script in the docker
./run_docker.sh --host-dir=/path/to/custom/host/directory --name=my_container --setup
```

This will run the `./run_submission -i` script. If you want to run it not in interactive, mode you will need to enter the docker and run the script yourself. Refer to the commands on how to enter an exited docker container.


**Flags Explanation**:
- `--host-dir`: The path to the directory on your local computer that contains the `pyquaticus_submission` directory.
- `--name`: The name of the Docker container you are creating from the base image.
- `--setup`: This flag is optional. If you would like to run the `setup.sh` script in the docker, you can add this flag.

Running this script will create a docker container from the base docker image on the robot (or on your local computer). Each container should be named after whose submission it is. For example, if you are running the docker for the submission from the team `team1` and have your submission in `~/Documents/pyquaticus_submission`, you would run the following command:


```
./run_docker.sh --host-dir=~/Documents/pyquaticus_submission --name=team1 --setup
```

And to list the docker containers to see your newly created one, you can run the following command:

```
sudo docker ps -a
```

### Some Helpful Commands
If you need to remove that newly created docker container, you can run the following command:

```
# Removes the docker container
sudo docker rm team1

# Remove all docker containers
sudo docker rm -f $(sudo docker ps -a -q)
```

If you need to enter the docker container to debug, you can run the following command:

```
# Start the exited container
sudo docker start team1

# Attach to the running container and run in the interactive mode
sudo docker exec -it team1 /bin/bash

```

This will allow you to keep entries separated if they have some conflicting dependencies that are installed with the `--setup` flag. At the same time, if you would like to save the state of the docker container, you can run the following command:

```
sudo docker commit team1 pyquaticus:base
```

This puts the docker container in a zip file that can be saved and opened at another time. To load the docker container from the zip file, you can run the following command:

```
sudo docker load -i pyquaticus_test.tar
```

## Local Installation
To test locally, you can set up a local version.

On Ubuntu, run the following to install dependencies for MOOS.
```
sudo apt install -y libncurses-dev subversion g++ xterm cmake libfltk1.3-dev freeglut3-dev libpng-dev libjpeg-dev libxft-dev libxinerama-dev libtiff5-dev
```

For the Python3 virtual environment, please ensure [anaconda](https://docs.anaconda.com/free/anaconda/install/index.html), [miniconda](https://docs.conda.io/projects/miniconda/en/latest/miniconda-install.html), or [mamba](https://mamba.readthedocs.io/en/latest/installation.html) is installed. Then run the following:
```
./scripts/local-install.sh
```

If there are issues, you can clean the partial installation with `./scripts/local-clean.sh`, fix the issues and run again.

In any new terminal, you must run `source ./start-env.sh` before the software in this repository will work.