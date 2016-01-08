#!/bin/bash

# tag and then build

usage()
{
   echo "Usage: `basename ${0}` [-d] [-t] <project>" >&2
}

source $(dirname $0)/config_nightly.sh "$@"

if [ ! -d ${LARSOFT_SCRIPTS} ]
then
   echo "ERROR: ${LARSOFT_SCRIPTS} does not exist" >&2
   exit 1
fi
if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist" >&2
   echo "Initialize it with ${LARSOFT_SCRIPTS}/init_nightly.sh" >&2
   exit 1
fi

if [ "${machine}" = "no_ssh" ]
then
echo "No tagging on no_ssh machine"
else
LOGFILE=$NIGHTLY_DIR/logs/tag_nightly_$TODAY.log
echo "Tagging $PROJECT, output in $LOGFILE"
${LARSOFT_SCRIPTS}/tag_nightly.sh "$@" >> $LOGFILE 2>&1 || \
    { echo "ERROR: tag_nightly failed" >&2; exit 1; }
fi
qual=e6

M=0
while [ $M -lt ${#MACHINES[@]} ]
do
  machine=${MACHINES[$M]}
  rOS=${OSES[$M]}
  for type in debug prof
  do
    working_dir=${NIGHTLY_DIR}/${rOS}_${qual}_${type}
    if [ ! -d ${working_dir} ]
    then
       echo "ERROR: ${working_dir} does not exist"
       exit 1
    fi
    LOGFILE="${NIGHTLY_DIR}/logs/build_nightly_${rOS}_${qual}_${type}_$TODAY.log"
    echo "Beginning nightly build for ${rOS}_${qual}_${type} on $machine, output in $LOGFILE"
    if [ "${machine}" = "no_ssh" ]
    then
    ${LARSOFT_SCRIPTS}/build_nightly.sh $PROJECT ${working_dir} >> $LOGFILE 2>&1 || \
       { echo "ERROR: build_nightly failed for ${working_dir}" >&2; exit 1; }
    else
    ssh ${machine} "${LARSOFT_SCRIPTS}/build_nightly.sh $PROJECT ${working_dir} >> $LOGFILE 2>&1" || \
       { echo "ERROR: build_nightly failed for ${working_dir}" >&2; exit 1; }
    fi
    echo "nightly build is complete for ${rOS}_${qual}_${type}"

  done
  let M+=1
done


if [ "${machine}" = "no_ssh" ]
then
echo "No copy on no_ssh machine"
else
LOGFILE=${NIGHTLY_DIR}/logs/copy_nightly_$TODAY.log
echo "Beginning copy, output in $LOGFILE"
${LARSOFT_SCRIPTS}/copy_build.sh "$@" >> $LOGFILE 2>&1 || \
     { echo "ERROR: copy_nightly failed" >&2; exit 1; }
fi
exit 0
