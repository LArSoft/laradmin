#!/bin/bash

# build all of larsoft plus lbnecode and uboonecode
# for now, this script presumes it will run on cluck

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
if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`

mkdir -p ${work_dir} || { echo "ERROR: cannot create  ${work_dir}"; exit 1; }


setup mrb
setup git
setup gitflow

export MRB_PROJECT=larsoft

cd ${work_dir} || exit 1
mrb newDev -v ${newver} -q e5:prof || { echo "ERROR: mrb newDev failed"; exit 1; }
source localProducts*/setup
cd ${MRB_SOURCE}  || { echo "ERROR: cannot cd to ${MRB_SOURCE}"; exit 1; }
mrb g larsoft_suite || { echo "ERROR: mrb g larsoft_suite failed"; exit 1; }
mrb g lbnecode || { echo "ERROR: mrb g lbnecode failed"; exit 1; }
mrb g uboonecode || { echo "ERROR: mrb g uboonecode failed"; exit 1; }

cd ${MRB_BUILDDIR}  || { echo "ERROR: cannot cd to ${MRB_BUILDDIR}"; exit 1; }
mrbsetenv || { echo "ERROR: mrbsetenv failed"; exit 1; }
mrb t -j30 || { echo "ERROR: mrb t failed"; exit 1; }

echo
echo "`basename ${0}`: test build successful"
echo

exit 0

