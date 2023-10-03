# aquaticus-docker
This repo hosts the docker that will be on the robots for the Aquaticus competition.
The goal of this repository is to have a standardized docker container that will exist on the robots. This will allow you to test your submission before the competition and allow us to quickly run your submission on the robots. The only files you will need to modify are the files in the pyquaticus_submission directory. The other files are for the docker and the bridge over to the MOOS environment which should not be edited.

If you just would like to run your agents in MOOS, you do not need to build the docker. You can activate the conda environment called env-full from the pyquaticus repository and run your solution then.

The docker is mainly necessary for running the agents on the boats. Here are the commands if you would like to build and run the docker on your local computer to test your submission before the competition.

Below are the commands necessary to set up the docker on your local computer:

```
# Build the docker in the current directory
sudo docker build -t pyquaticus:test .
```

Once it is built, there is a directory in the docker called pyquaticus_submission. Here, we will be mounting your pyquaticus_submission directory with all the necessary files. You can do this by running the following command:

```
# Enters the docker and mounts a volume to the logs directory on the host computer
sudo docker run -it -v ./pyquaticus_submission:/home/moos/pyquaticus_submission --net host --entrypoint /bin/bash pyquaticus:test
```

Ensure you update the path `./pyquaticus_submission` to match the actual directory path on your local computer. By doing this, you'll mount the directory to Docker, which will:

- Reflect live edits from your local files within Docker.
- Store all logs within the `pyquaticus_submission/logs` directory for organization.

**Flags Explanation**:
- `--net host`: Essential for Docker's communication with the MOOS environment.
- `--entrypoint /bin/bash`: Enables Docker's interactive mode.
- `pyquaticus:test`: Refers to the Docker image name you created in the prior step which you can change to your choosing.


If you would rather not enter the docker, and only run the `run_submission.sh script`, you can run the following command:

```
# Runs the run_submission.sh script in the docker
sudo docker run -it -v ./pyquaticus_submission:/home/moos/pyquaticus_submission --net host pyquaticus:test
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