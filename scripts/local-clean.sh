#!/bin/bash

# get top-level directory of repo
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPODIR=$(realpath $THISDIR/../)
DEPS="$REPODIR/deps"

rm -rf $DEPS