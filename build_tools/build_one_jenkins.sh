#!/bin/bash

# build a single package

usage()
{
   echo "USAGE: `basename ${0}` <working_dir> <package> <version>"
}

working_dir=${1}
package=${2}
newver=${3}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
if [ -z ${package} ]
then
   echo "ERROR: please specify the package"
   usage
   exit 1
fi
if [ -z ${newver} ]
then
   echo "ERROR: please specify the version"
   usage
   exit 1
fi

# make sure we can use the setup alias
source /grid/fermiapp/products/larsoft/setup

pkg_dir=${working_dir}/${package}
rm -rf ${pkg_dir}
mkdir -p ${pkg_dir} || { echo "ERROR: cannot create  ${pkg_dir}"; exit 1; }

setup mrb
setup git
setup gitflow
export MRB_PROJECT=larsoft

cd ${pkg_dir} || exit 1
mrb newDev -v ${newver} -q e5:prof || { echo "ERROR: mrb newDev failed"; exit 1; }
source localProducts*/setup

cd ${MRB_SOURCE}  || { echo "ERROR: cannot cd to ${MRB_SOURCE}"; exit 1; }
mrb g -r ${package} || { echo "ERROR: mrb g -r ${package} failed"; exit 1; }
if [ "${package}" = "uboonecode" ]; then
  mrb g -r ubutil || { echo "ERROR: mrb g -r ubutil failed"; exit 1; }
fi
cd ${MRB_BUILDDIR}  || { echo "ERROR: cannot cd to ${MRB_BUILDDIR}"; exit 1; }
mrbsetenv || { echo "ERROR: mrbsetenv failed for ${package}"; exit 1; }
mrb t -j30 || { echo "ERROR: mrb t failed for ${package}"; exit 1; }

echo
echo "`basename ${0}`: test build of ${package} successful"
echo

exit 0
