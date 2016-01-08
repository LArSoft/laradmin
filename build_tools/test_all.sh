#!/bin/bash

# build all of larsoft plus uboonecode
# since lbnecode is not being kept up to date with larsoft, we cannot include it here

usage()
{
   echo "USAGE: `basename ${0}` <work_dir> <version>"
}


work_dir=${1}
newver=${2}

if [ -z ${work_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
if [ -z ${newver} ]
then
   echo "ERROR: please specify the version"
   usage
   exit 1
fi

if [ -d ${work_dir} ]
then
   echo "ERROR: ${work_dir} already exists"
   exit 1
fi

# make sure we can use the setup alias
source /grid/fermiapp/products/larsoft/setup
# we also need to find some uboone products,
# but we want to make sure we use our install of ups
export PRODUCTS=/grid/fermiapp/products/uboone:${PRODUCTS}


mkdir -p ${work_dir} || { echo "ERROR: cannot create  ${work_dir}"; exit 1; }


setup mrb
setup git
setup gitflow

export MRB_PROJECT=larsoft

cd ${work_dir} || exit 1
mrb newDev -v ${newver} -q e5:prof || { echo "ERROR: mrb newDev failed"; exit 1; }
source localProducts*/setup
cd ${MRB_SOURCE}  || { echo "ERROR: cannot cd to ${MRB_SOURCE}"; exit 1; }
mrb g -r larsoft_suite || { echo "ERROR: mrb g -r larsoft_suite failed"; exit 1; }
##mrb g -r lbnecode || { echo "ERROR: mrb g -r lbnecode failed"; exit 1; }
mrb g -r ubutil || { echo "ERROR: mrb g -r ubutil failed"; exit 1; }
mrb g -r uboonecode || { echo "ERROR: mrb g -r uboonecode failed"; exit 1; }

cd ${MRB_BUILDDIR}  || { echo "ERROR: cannot cd to ${MRB_BUILDDIR}"; exit 1; }
mrbsetenv || { echo "ERROR: mrbsetenv failed"; exit 1; }
mrb t -j30 || { echo "ERROR: mrb t failed"; exit 1; }

echo
echo "`basename ${0}`: test build successful"
echo

exit 0

