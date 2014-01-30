#!/bin/bash

# update the nightly tag
# NOTE: we have saved copies of each ups/product_deps 
#       These copies contain the original larsoft version numbers

usage()
{
   echo "Usage: `basename ${0}` <project>" >&2
}

source $(dirname $0)/config_nightly.sh "$1"

export MRB_SOURCE=$NIGHTLY_DIR/srcs

update_tag()
{
  pkg=$1
  # we just did a clean checkout - tag NOW
  git tag -a -f -m"nightly $mytime" nightly || exit 1
  # git push
  # modify this copy of product_deps
  version="`grep ^parent ups/product_deps | grep -v \# | awk '{print $3}'`" || exit 1
  if [ -z "${version}" ]
  then
    echo "ERROR: failed to find existing version for ${pkg}" >&2
    exit 1
  fi
  # TEMPORARY: we need the new product-config.cmake.in
  cp -p /grid/fermiapp/products/larsoft/cetbuildtools/v3_07_06/templates/product-config.cmake.in.template ups/product-config.cmake.in || exit 1
  mv ups/product_deps ups/product_deps.bak || exit 1
  # TEMPORARY: edit version of cetbuildtools
  sed -e "s%$version%nightly%g" -e 's%cetbuildtools.*v3_07_04%cetbuildtools v3_07_06%' ups/product_deps.bak > ups/product_deps || exit 1
}


if [ ! -d ${MRB_SOURCE} ]
then
   echo "ERROR: ${MRB_SOURCE} does not exist" >&2
   exit 1
fi
if [ ! -d ${NIGHTLY_DIR} ]
then
   echo "ERROR: ${NIGHTLY_DIR} does not exist" >&2
   exit 1
fi

if [ -e ${NIGHTLY_DIR}/stamps/nightly_tag_$TODAY ]
then
  echo "nightly tagging has already been done on $PROJECT for $TODAY"
  exit 0
fi

for pkg in ${PKGLIST}
do
  echo "Checking out and tagging package $pkg"
  set -x
  cd $MRB_SOURCE || exit 1
  if [ -d $pkg ]
  then
    rm -rf $pkg
  fi
  mrb g $pkg develop || exit 1
  cd $pkg || exit 1
  update_tag $pkg
  rm -rf ${NIGHTLY_DIR}/install/$pkg
  set +x
done

cd ${NIGHTLY_DIR} || exit 1
touch stamps/nightly_tag_$TODAY || exit 1

exit 0

