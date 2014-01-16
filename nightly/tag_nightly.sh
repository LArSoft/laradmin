#!/bin/bash

# update the nightly tag

update_tag()
{
  # make sure we are on the develop branch
  git checkout develop || exit 1;
  # restore unmodified product_deps
  cp -p ups/product_deps.orig ups/product_deps || exit 1;
  git pull || exit 1;
  # modify this copy of product_deps
  version=`grep parent ups/product_deps | grep -v \# | cut -f3` || exit 1;
  if [ -z ${version} ]
  then
    echo "ERROR: failed to find existing version for ${larpkg}"
    exit 1
  fi
  fixfile=${larpkg}.fix.sh
  rm -f ${fixfile}
  echo "#!/bin/bash" > ${fixfile}
  echo "set -x" >> ${fixfile}
  echo "mv ups/product_deps ups/product_deps.bak || exit 1;" >> ${fixfile}
  echo "cat ups/product_deps.bak | sed -e 's%$version%nightly%g' > ups/product_deps || exit 1;" >> ${fixfile}
  echo "set +x" >> ${fixfile}
  echo "exit 0" >> ${fixfile}
  chmod +x ${fixfile} || exit 1;
  ./${fixfile} || exit 1;
  # local commit and tag 
  git commit -m"change $version to nightly" ups/product_deps 
  git tag -a -f -m"nightly $mytime" nightly || exit 1;
}


# establish the environment
# we only need git for the tagging step
source /grid/fermiapp/products/larsoft/setups || exit 1;
setup git || exit 1;
MRB_SOURCE=/grid/fermiapp/larsoft/home/larsoft/code/nightly/srcs
NIGHTLY_DIR=/grid/fermiapp/larsoft/home/larsoft/code/nightly

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
  cd $MRB_SOURCE/${larpkg} || exit 1;
  update_tag
  set +x
done

cd ${NIGHTLY_DIR} || exit 1;
touch nightly_tag_$mytime || exit 1;

exit 0

