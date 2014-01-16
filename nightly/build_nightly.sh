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

NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly
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
OS=`get-directory-name os` || exit 1;
unsetup cetpkgsupport || exit 1;
quals=`echo ${MRB_QUALS} | sed -e 's/:/_/g'` || exit 1;

if [ -e ${NIGHTLY_DIR}/nightly_build_${OS}_${quals}_$mytime ]
then
  echo "nightly build has already been done for ${OS}_${quals} $mytime"
  exit 0
fi

if [ ! -e ${NIGHTLY_DIR}/nightly_tag_${mytime} ]
then
   echo "ERROR: cannot find ${MRB_SOURCE}/../nightly_tag_${mytime}"
   echo "ERROR: code has not been tagged"
   exit 1
fi

echo "begin build for ${OS}_${quals}"
set -x
rm -rf ${MRB_INSTALL}/lar*  || exit 1;
cd $MRB_BUILDDIR  || exit 1;
mrb z  || exit 1;
set +x

source mrb s  || exit 1;

set -x
mrb i -j4  || exit 1;
set +x


# now remove and restore the official copy of the nightly updates
# This is a very dangerous step
# It needs lots of double checking to make sure you aren't about to blow away all of ${LARSOFT_PRODUCTS} or worse
# Perhaps the nightly updates should be in their own product directory?
# If the nightly updates are in a separate product directory which is JUST for them, it will make syncing with cvmfs cleaner
larlist="larana lardata larevt larpandora larsim larcore lareventdisplay larexamples larreco larsoft"
for larpkg in ${larlist}
do
  # this is tricky - each release has shared and specific directories
  # so the directories specifically called out below are not correct, need finer control
  # great care must be taken with this step
  # getting this right is probably the hardest part of the entire exercise
  echo "rsync ${MRB_INSTALL}/${larpkg}/nightly with ${LARSOFT_PRODUCTS}/${larpkg}/nightly"
  echo "rsync ${MRB_INSTALL}/${larpkg}/nightly.version with ${LARSOFT_PRODUCTS}/${larpkg}/nightly.version"
done

cd ${NIGHTLY_DIR} || exit 1;
touch nightly_build_${OS}_${quals}_$mytime  || exit 1;

exit 0
