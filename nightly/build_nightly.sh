#!/bin/bash

# build debug or prof

usage()
{
   echo "Usage: `basename ${0}` <project> <working_dir>" >&2
}

source $(dirname $0)/config_nightly.sh "$1"

working_dir="${2}"

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory" >&2
   usage
   exit 1
fi


if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist" >&2
   exit 1
fi
if [ ! -d ${working_dir} ]
then
   echo "ERROR: ${working_dir} does not exist" >&2
   exit 1
fi

source ${working_dir}/localProducts_${PROJECT}_nightly*/setup || exit 1

setup cetpkgsupport || exit 1
myOS=`get-directory-name os` || exit 1
unsetup cetpkgsupport || exit 1
myquals=`echo ${MRB_QUALS} | sed -e 's/:/_/g'` || exit 1

if [ -e ${NIGHTLY_DIR}/stamps/nightly_build_${myOS}_${myquals}_$TODAY ]
then
  echo "nightly build has already been done for ${myOS}_${myquals} $TODAY" >&2
  exit 0
fi

if [ ! -e ${NIGHTLY_DIR}/stamps/nightly_tag_${TODAY} ]
then
   echo "ERROR: cannot find ${NIGHTLY_DIR}/stamps/nightly_tag_${TODAY}" >&2
   echo "ERROR: code has not been tagged" >&2
   exit 1
fi

# set our own MRB_INSTALL
# we install everything in the SAME directory
# MRB_INSTALL is redefined when you source localProducts_XXX/setup, so define it here for safety
export MRB_INSTALL=${NIGHTLY_DIR}/install

echo "begin build for ${myOS}_${myquals}"
set -x
cd $MRB_BUILDDIR  || exit 1
mrb z  || exit 1
set +x

source mrb s  || exit 1

set -x
mrb i -j4  || exit 1
set +x

cd ${NIGHTLY_DIR} || exit 1
touch stamps/nightly_build_${myOS}_${myquals}_$TODAY  || exit 1

exit 0
