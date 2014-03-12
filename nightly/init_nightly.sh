#!/bin/bash

# initialize a build directory

usage()
{
   echo "Usage: `basename ${0}` [-d] <project>" >&2
}

source $(dirname $0)/config_nightly.sh "$@"

if [ ! -d ${LARSOFT_SCRIPTS} ]
then
   echo "ERROR: ${LARSOFT_SCRIPTS} does not exist" >&2
   exit 1
fi
if [ -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} already exists" >&2
   exit 1
fi

mkdir $NIGHTLY_DIR || exit 1
cd $NIGHTLY_DIR || exit 1

for d in install logs stamps
do
    mkdir $d
done

qual=e4

M=0
while [ $M -lt ${#MACHINES[@]} ]
do
  machine=${MACHINES[$M]}
  rOS=${OSES[$M]}
  for type in debug prof
  do
    working_dir=${rOS}_${qual}_${type}
    mkdir $working_dir
    if [ "${machine}" = "no_ssh" ]
    then
      source $SETUPS && setup mrb && export MRB_PROJECT=$PROJECT && cd $PWD && mrb newDev -f -T $working_dir -v nightly -q ${qual}:${type} || \
       { echo "ERROR: init_nightly's mrb newDev failed for ${working_dir}" >&2; exit 1; }
    else
    ssh ${machine} "source $SETUPS && setup mrb && export MRB_PROJECT=$PROJECT && cd $PWD && mrb newDev -f -T $working_dir -v nightly -q ${qual}:${type}" || \
       { echo "ERROR: init_nightly's mrb newDev failed for ${working_dir}" >&2; exit 1; }
    fi
  done
  let M+=1
done

if [ -n "$NIGHTLYDEVELOPMODE" ]
then
  mkdir -p $PROJ_PRODUCTS
  cd $PROJ_PRODUCTS
  mkdir -p $PKGLIST
fi

exit 0
