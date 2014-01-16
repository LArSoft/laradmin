#!/bin/bash

# tag and then build

LARSOFT_SCRIPTS=/grid/fermiapp/larsoft/home/larsoft/scripts
NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly

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

exit 0


