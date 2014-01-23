#!/bin/bash

# build debug or prof

usage()
{
   echo "USAGE: `basename ${0}` <working_dir>"
}

working_dir=${1}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
LARSOFT_PRODUCTS=/grid/fermiapp/products/larsoft
if [ ! -d ${LARSOFT_PRODUCTS} ]
then
   echo "ERROR: ${LARSOFT_PRODUCTS} does not exist"
   exit 1
fi

# establish the environment
source ${LARSOFT_PRODUCTS}/setup || exit 1;
setup git || exit 1;
setup gitflow || exit 1;
setup mrb || exit 1;
export MRB_PROJECT=larsoft

NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build
if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist"
   exit 1
fi
if [ ! -d ${working_dir} ]
then
   echo "ERROR: ${working_dir} does not exist"
   exit 1
fi

source ${working_dir}/localProducts_larsoft_nightly*/setup || exit 1;

mytime=`date +%Y-%m-%d` || exit 1;
setup cetpkgsupport || exit 1;
myOS=`get-directory-name os` || exit 1;
unsetup cetpkgsupport || exit 1;
myquals=`echo ${MRB_QUALS} | sed -e 's/:/_/g'` || exit 1;

if [ -e ${NIGHTLY_DIR}/nightly_build_${myOS}_${myquals}_${mytime} ]
then
  echo "nightly build has already been done for ${myOS}_${myquals} ${mytime}"
  exit 0
fi

if [ ! -e ${NIGHTLY_DIR}/nightly_tag_${mytime} ]
then
   echo "ERROR: cannot find ${MRB_SOURCE}/../nightly_tag_${mytime}"
   echo "ERROR: code has not been tagged"
   exit 1
fi

# set our own MRB_INSTALL
# we install everything in the SAME directory
# MRB_INSTALL is redefined when you source localProducts_XXX/setup, so define it here for safety
export MRB_INSTALL=${NIGHTLY_DIR}/install

echo "begin build for ${myOS}_${myquals}"
set -x
cd $MRB_BUILDDIR  || exit 1;
mrb z  || exit 1;
set +x

source mrb s  || exit 1;

set -x
mrb i -j4  || exit 1;
set +x

cd ${NIGHTLY_DIR} || exit 1;
touch nightly_build_${myOS}_${myquals}_${mytime}  || exit 1;

exit 0
