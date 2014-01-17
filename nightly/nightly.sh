#!/bin/bash

# tag and then build

LARSOFT_SCRIPTS=/grid/fermiapp/larsoft/home/larsoft/code/laradmin/nightly
NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build

if [ ! -d ${LARSOFT_SCRIPTS} ]
then
   echo "ERROR: ${LARSOFT_SCRIPTS} does not exist"
   exit 1
fi
if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist"
   exit 1
fi

today=`date +%Y-%m-%d` || exit 1;

${LARSOFT_SCRIPTS}/tag_nightly.sh > ${NIGHTLY_DIR}/logs/tag_nightly_$today.log 2>&1 || \
    { echo "ERROR: tag_nightly failed"; exit 1; }

source /grid/fermiapp/products/larsoft/setups || exit 1;
setup cetpkgsupport || exit 1;
OS=`get-directory-name os` || exit 1;
qual=e4
unsetup cetpkgsupport || exit 1;

echo "building for ${OS}"

for type in debug prof
do
  working_dir=${NIGHTLY_DIR}/${OS}_${qual}_${type}
  if [ ! -d ${working_dir} ]
  then
     echo "ERROR: ${working_dir} does not exist"
     exit 1
  fi
  echo "begining nightly build for ${OS}_${qual}_${type}"
  ${LARSOFT_SCRIPTS}/build_nightly.sh ${working_dir} >& ${NIGHTLY_DIR}/logs/build_nightly_${OS}_${qual}_${type}_$today.log || \
     { echo "ERROR: build_nightly failed for ${working_dir}"; exit 1; }
  echo "nightly build is complete for ${OS}_${qual}_${type}"
  
done

# NOTE: MRB_INSTALL is redefined when you source localProducts_XXX/setup, so define it here for safety
export MRB_INSTALL=${NIGHTLY_DIR}/install
export LARSOFT_PRODUCTS=/grid/fermiapp/products/larsoft
# now remove and restore the official copy of the nightly updates
# it might be easiest to do this with rsync --delete
larlist="larana lardata larevt larpandora larsim larcore lareventdisplay larexamples larreco larsoft"
for larpkg in ${larlist}
do
  echo "rsync ${MRB_INSTALL}/${larpkg}/nightly with ${LARSOFT_PRODUCTS}/${larpkg}/nightly"
  echo "rsync ${MRB_INSTALL}/${larpkg}/nightly.version with ${LARSOFT_PRODUCTS}/${larpkg}/nightly.version"
done

exit 0



# now remove and restore the official copy of the nightly updates
# This is a very dangerous step
# It needs lots of double checking to make sure you aren't about to blow away all of ${LARSOFT_PRODUCTS} or worse
# Perhaps the nightly updates should be in their own product directory?
# If the nightly updates are in a separate product directory which is JUST for them, it will make syncing with cvmfs cleaner
  # this is tricky - each release has shared and specific directories
  # so the directories specifically called out below are not correct, need finer control
  # great care must be taken with this step
  # getting this right is probably the hardest part of the entire exercise
