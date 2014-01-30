#!/bin/bash

# update the nightly tag
# NOTE: we have saved copies of each ups/product_deps 
#       These copies contain the original larsoft version numbers

update_tag()
{
  # make sure we are on the develop branch
  git checkout develop || exit 1;
  # we just did a clean checkout - tag NOW
  git tag -a -f -m"nightly $mytime" nightly || exit 1;
  # modify this copy of product_deps
  version=`grep parent ups/product_deps | grep -v \# | cut -f3` || exit 1;
  if [ -z ${version} ]
  then
    echo "ERROR: failed to find existing version for ${larpkg}"
    exit 1
  fi
  # we need the new product-config.cmake.in
  cp -p /grid/fermiapp/products/larsoft/cetbuildtools/v3_07_05/templates/product-config.cmake.in.template ups/product-config.cmake.in || exit 1;
  # need to use a fixit script here
  fixfile=${larpkg}.fix.sh
  rm -f ${fixfile}
  echo "#!/bin/bash" > ${fixfile}
  echo "set -x" >> ${fixfile}
  echo "mv ups/product_deps ups/product_deps.bak || exit 1;" >> ${fixfile}
  echo "cat ups/product_deps.bak | sed -e 's%$version%nightly%g' | sed -e 's%v3_07_04%v3_07_05%' > ups/product_deps || exit 1;" >> ${fixfile}
  echo "set +x" >> ${fixfile}
  echo "exit 0" >> ${fixfile}
  chmod +x ${fixfile} || exit 1;
  ./${fixfile} || exit 1;
}

# establish the environment
# we need git and mrb for the tagging step
source /grid/fermiapp/products/larsoft/setups || exit 1;
setup git || exit 1;
setup gitflow || exit 1;
setup mrb || exit 1;
export MRB_SOURCE=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build/srcs
NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build
export MRB_PROJECT=larsoft

if [ ! -d ${MRB_SOURCE} ]
then
   echo "ERROR: ${MRB_SOURCE} does not exist"
   exit 1
fi
if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist"
   exit 1
fi

mytime=`date +%Y-%m-%d` || exit 1;

if [ -e ${NIGHTLY_DIR}/nightly_tag_$mytime ]
then
  echo "nightly tagging has already been done for $mytime"
  exit 0
fi

larlist="larana lardata larevt larpandora larsim larcore lareventdisplay larexamples larreco larsoft"

for larpkg in ${larlist}
do
  set -x
  cd $MRB_SOURCE || exit 1;
  if [ -d ${larpkg} ]
  then
    rm -rf ${larpkg}
  fi
  mrb g ${larpkg} || exit 1;
  cd $MRB_SOURCE/${larpkg} || exit 1;
  update_tag
  set +x
done

cd $MRB_SOURCE || exit 1;
mrb uc || exit 1;

# cleanup here - ONCE ONLY
rm -rf ${NIGHTLY_DIR}/install/lar*  || exit 1;
rm -rf ${NIGHTLY_DIR}/install/uboonecode  || exit 1;
rm -rf ${NIGHTLY_DIR}/install/lbnecode  || exit 1;

cd ${NIGHTLY_DIR} || exit 1;
touch nightly_tag_$mytime || exit 1;

exit 0

