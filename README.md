# aquaticus-docker
This repo hosts the docker that will be on the robots for the Aquaticus competition.

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
