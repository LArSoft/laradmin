#!/bin/bash

# just copy the nightly build

# copy from LOCAL_INSTALL to LARSOFT_PRODUCTS
export LOCAL_INSTALL=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build/install
export LARSOFT_PRODUCTS=/grid/fermiapp/products/larsoft

if [ ! -d ${LOCAL_INSTALL} ]
then
   echo "ERROR: ${LOCAL_INSTALL} does not exist"
   exit 1
fi
if [ ! -d ${LARSOFT_PRODUCTS} ]
then
   echo "ERROR: ${LARSOFT_PRODUCTS} does not exist"
   exit 1
fi

# now remove and restore the official copy of the nightly updates
# it might be easiest to do this with rsync --delete, but for now we use rm -rf followed by scp -pr
larlist="larana lardata larevt larpandora larsim larcore lareventdisplay larexamples larreco larsoft"
for larpkg in ${larlist}
do
  echo "check ${larpkg}"
  pdir=${LARSOFT_PRODUCTS}/${larpkg}
  if [ ! -d ${pdir} ]
  then
     echo "ERROR: ${pdir} does not exist"
     exit 1
  fi
  ldir=${LOCAL_INSTALL}/${larpkg}/nightly
  lverdir=${LOCAL_INSTALL}/${larpkg}/nightly.version
  if [ ! -d ${ldir} ]
  then
     echo "ERROR: ${ldir} does not exist"
     exit 1
  fi
  if [ ! -d ${lverdir} ]
  then
     echo "ERROR: ${lverdir} does not exist"
     exit 1
  fi
  echo "removing ${pdir}/nightly"
  if [ -d ${pdir}/nightly ]
  then
    rm -rf ${pdir}/nightly || exit 1;
  fi
  echo "removing ${pdir}/nightly.version"
  if [ -d ${pdir}/nightly.version ]
  then
    rm -rf ${pdir}/nightly.version || exit 1;
  fi
  echo "copy ${ldir} to ${pdir}"
  cp -pr  ${ldir} ${pdir}
  echo "copy ${lverdir} to ${pdir}"
  cp -pr  ${lverdir} ${pdir}
 
done


exit 0

