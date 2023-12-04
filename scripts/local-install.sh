#!/bin/bash

# DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.
#
# This material is based upon work supported by the Under Secretary of Defense for
# Research and Engineering under Air Force Contract No. FA8702-15-D-0001. Any opinions,
# findings, conclusions or recommendations expressed in this material are those of the
# author(s) and do not necessarily reflect the views of the Under Secretary of Defense
# for Research and Engineering.
#
# (C) 2023 Massachusetts Institute of Technology.
#
# The software/firmware is provided to you on an As-Is basis
#
# Delivered to the U.S. Government with Unlimited Rights, as defined in DFARS
# Part 252.227-7013 or 7014 (Feb 2014). Notwithstanding any copyright notice, U.S.
# Government rights in this work are defined by DFARS 252.227-7013 or DFARS
# 252.227-7014 as detailed above. Use of this work other than as specifically
# authorized by the U.S. Government may violate any copyrights that exist in this
# work.

# SPDX-License-Identifier: BSD-3-Clause

set -o errexit

# get top-level directory of repo
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPODIR=$(realpath $THISDIR/../)
DEPS="$REPODIR/deps"


echo "Cloning dependencies..."
mkdir -p $DEPS
cd $DEPS
svn export https://oceanai.mit.edu/svn/moos-ivp-aro/trunk/ moos-ivp
svn export https://oceanai.mit.edu/svn/moos-ivp-aquaticus-oai/trunk/ moos-ivp-aquaticus
git clone https://github.com/westpoint-robotics/mdo-hurt-s.git
git clone https://github.com/mit-ll-trusted-autonomy/pyquaticus.git


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
echo "Creating environment using $CONDATYPE"


echo "########################################## Install Pyquaticus #################################################"
cd pyquaticus
./setup-conda-env.sh full
eval "$(conda shell.bash hook)"
ENV_NAME="$DEPS/pyquaticus/env-full"
conda activate $ENV_NAME

# set environment variables for MOOS
conda env config vars set PATH=${PATH}:$DEPS/moos-ivp/bin:$DEPS/moos-ivp-aquaticus/bin:$REPODIR/moos-ivp-rlagent/bin:$DEPS/pyquaticus/:$DEPS/scripts:$DEPS/mdo-hurt-s/moos-ivp-surveyor/bin \
conda env config vars set IVP_BEHAVIOR_DIRS=$DEPS/moos-ivp/lib:$DEPS/moos-ivp-aquaticus/lib:$REPODIR/moos-ivp-rlagent/lib \
conda env config vars set SCRIPTS=$REPODIR/scripts
conda env config vars set MOOSIVP_SOURCE_TREE_BASE=$DEPS/moos-ivp/

# Deactivate and reactivate for changes to take effect
conda deactivate
source $REPODIR/start-env.sh

echo "########################################## Building MOOS-IvP ##################################################"
cd ../moos-ivp
./build.sh

echo "##################################### Building MOOS-IvP Aquaticus #############################################"
cd ../moos-ivp-aquaticus
./build.sh

echo "###################################### Building MOOS-IvP RL Agent #############################################"
cd ../../moos-ivp-rlagent
./build.sh
cd ..

echo -e "

############################## Setup complete ###############################
Run 'source start-env.sh' in each new terminal before running anything.

"
