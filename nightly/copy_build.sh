#!/bin/bash

usage()
{
   echo "Usage: `basename ${0}` [-d] <project>" >&2
}

source $(dirname $0)/config_nightly.sh "$@"

# just copy the nightly build

# copy from LOCAL_INSTALL to PROJ_PRODUCTS
LOCAL_INSTALL="${NIGHTLY_DIR}/install"

if [ ! -d ${LOCAL_INSTALL} ]
then
   echo "ERROR: ${LOCAL_INSTALL} does not exist" >&2
   exit 1
fi
if [ ! -d ${PROJ_PRODUCTS} ]
then
   echo "ERROR: ${PROJ_PRODUCTS} does not exist" >&2
   exit 1
fi

# now remove and restore the official copy of the nightly updates
# it might be easiest to do this with rsync --delete, but for now we use rm -rf followed by scp -pr
for pkg in ${PKGLIST}
do
  echo "check ${pkg}"
  pdir=${PROJ_PRODUCTS}/${pkg}
  if [ ! -d ${pdir} ]
  then
     echo "ERROR: ${pdir} does not exist" >&2
     exit 1
  fi
  ldir=${LOCAL_INSTALL}/${pkg}/nightly
  lverdir=${LOCAL_INSTALL}/${pkg}/nightly.version
  if [ ! -d ${ldir} ]
  then
     echo "ERROR: ${ldir} does not exist" >&2
     exit 1
  fi
  if [ ! -d ${lverdir} ]
  then
     echo "ERROR: ${lverdir} does not exist" >&2
     exit 1
  fi
  echo "removing ${pdir}/nightly"
  if [ -d ${pdir}/nightly ]
  then
    rm -rf ${pdir}/nightly || exit 1
  fi
  echo "removing ${pdir}/nightly.version"
  if [ -d ${pdir}/nightly.version ]
  then
    rm -rf ${pdir}/nightly.version || exit 1
  fi
  echo "copy ${ldir} to ${pdir}"
  cp -pr  ${ldir} ${pdir}
  echo "copy ${lverdir} to ${pdir}"
  cp -pr  ${lverdir} ${pdir}
 
done

touch $NIGHTLY_DIR/stamps/nightly_copy_$TODAY || exit 1

exit 0

