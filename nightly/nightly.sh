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

for machine in uboonegpvm01 uboonegpvm04
do
  if [ "${machine}" == "uboonegpvm01" ]
  then
    rOS=slf5
  elif [ "${machine}" == "uboonegpvm04" ]
  then
    rOS=slf6
  else
    echo "building on unrecognized machine ${machine}"
    rOS=OS
  fi
  for type in debug prof
  do
    working_dir=${NIGHTLY_DIR}/${rOS}_${qual}_${type}
    if [ ! -d ${working_dir} ]
    then
       echo "ERROR: ${working_dir} does not exist"
       exit 1
    fi
    echo "begining nightly build for ${rOS}_${qual}_${type}"
    ssh larsoft@${machine} "${LARSOFT_SCRIPTS}/build_nightly.sh ${working_dir} >&  ${NIGHTLY_DIR}/logs/build_nightly_${rOS}_${qual}_${type}_$today.log" || \
       { echo "ERROR: build_nightly failed for ${working_dir}"; exit 1; }
    echo "nightly build is complete for ${rOS}_${qual}_${type}"

  done
done


${LARSOFT_SCRIPTS}/copy_build.sh  >& ${NIGHTLY_DIR}/logs/copy_nightly_$today.log || \
     { echo "ERROR: copy_nightly failed"; exit 1; }

exit 0
