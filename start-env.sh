#!/bin/bash

REPODIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DEPS="$REPODIR/deps"

if command -v mamba &> /dev/null; then
    CONDATYPE="mamba"
    MAMBABIN=`which mamba`
    MAMBA_ROOT_PREFIX=${MAMBABIN%condabin/mamba}
    source $MAMBA_ROOT_PREFIX/etc/profile.d/mamba.sh
elif command -v conda &> /dev/null; then
    CONDATYPE="conda"
else
    echo "Missing conda. Please install the latest Anaconda or Miniconda"
    exit
fi
echo "Using $CONDATYPE"


eval "$(conda shell.bash hook)"
ENV_NAME="$DEPS/pyquaticus/env-full"
$CONDATYPE activate $ENV_NAME

