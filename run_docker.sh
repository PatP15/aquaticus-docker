#!/bin/bash

# Image name
IMAGE_NAME="pyquaticus:base" # Replace with your Docker image name (this should be the base image that all the containers are made from)

# Default directories and command
DEFAULT_HOST_DIR="./pyquaticus_submission"
TARGET_DIR="/home/moos/pyquaticus_submission"
CMD="./run_submission.sh -i"

CONTAINER_NAME="west-point" # the container name which should correspond to the submission name
HOST_DIR=$DEFAULT_HOST_DIR

# Process arguments
for arg in "$@"; do
    case $arg in
        --setup)
            CMD="./setup.sh && $CMD"
            ;;
        --name=*)
            CONTAINER_NAME="${arg#*=}"
            ;;
        --host-dir=*)
            HOST_DIR="${arg#*=}"
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --setup                : Run the setup.sh script before run_submission.sh."
            echo "  --name=CONTAINER_NAME  : Specify a name for the Docker container."
            echo "  --host-dir=HOST_DIR    : Specify the host directory to mount into the container."
            echo "  -h, --help             : Show this help message and exit."
            echo ""
            echo "Example:"
            echo "$0 --host-dir=/path/to/custom/host/directory --name=my_container --setup"
            exit 0
            ;;
    esac
done


sudo docker rm $CONTAINER_NAME # Remove the container if it already exists

# Run the command inside the Docker container with volume mounting, custom name, and custom host directory

# echo "sudo docker run --name $CONTAINER_NAME -v $HOST_DIR:$TARGET_DIR $IMAGE_NAME /bin/bash -c \"$CMD\""
sudo docker run -it  --net host --name $CONTAINER_NAME -v $HOST_DIR:$TARGET_DIR $IMAGE_NAME /bin/bash -c "cd $TARGET_DIR && $CMD"
