#!/bin/bash

# clean out old stamps, logs, and git repository tags

usage()
{
   echo "Usage: `basename ${0}` <project>" >&2
}

source $(dirname $0)/config_nightly.sh "$1"

if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not eixst" >&2
   exit 1
fi

find ${NIGHTLY_DIR}/stamps ${NIGHTLY_DIR}/logs -type f -mtime +30|xargs rm

# TODO: clean out tags from the git repository
