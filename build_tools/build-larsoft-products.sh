#!/bin/bash

# build the larsoft suite one at a time

usage()
{
   echo "USAGE: `basename ${0}` <working_dir> <source_code_dir>"
}

function do_build()
{
  local prd=$1
  local logfile=${single_dir}/build_${prd}
   (  ln -s ${source_code_dir}/${prd}
     mrb uc || { echo "ERROR: mrb uc failed"; exit 1; }
     cd ${MRB_BUILDDIR}  || { echo "ERROR: cannot cd to ${MRB_BUILDDIR}"; exit 1; }
     mrb z || { echo "ERROR: mrb z failed"; exit 1; }
     mrbsetenv || { echo "ERROR: mrbsetenv failed"; exit 1; }
     mrb i -j30 || { echo "ERROR: mrb i failed"; exit 1; }
     ctest -j30  || { echo "ERROR: ctest failed"; exit 1; }
   ) > ${logfile} 2>&1
  local status=$?
  if (( ${status} == 0)); then # Success!
    echo "INFO: build of ${prd} was successful"
  else
    cat 1>&2 <<EOF
Build of ${prd} failed with status ${status} -- please examine:
  ${logfile}
EOF
    exit ${status}
  fi
}


basedir=$(/bin/pwd)

cd ${1}
working_dir=$(/bin/pwd)
cd ${basedir}
cd ${2}
source_code_dir=$(/bin/pwd)

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
if [ -z ${source_code_dir} ]
then
   echo "ERROR: please specify the source code reference directory"
   usage
   exit 1
fi

# make sure -B is not defined just yet
unset UPS_OVERRIDE

# make sure we can use the setup alias
if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`
# setup mrb so we have the aliases
setup mrb

# make a clean build directory
single_dir=${working_dir}/single_build
if [ -d ${single_dir} ]
then
    echo 'ERROR:  ${single_dir} already exists!'
    usage
    exit 1
fi
mkdir -p ${single_dir} || { echo "ERROR: cannot create  ${single_dir}"; exit 1; }

export MRB_PROJECT=larsoft
cd ${single_dir} || exit 1
mrb newDev -v vx_y_z -q e7:noifdh:prof || { echo "ERROR: mrb newDev failed"; exit 1; }
source localProducts*/setup

# build and install one at a time, in order
pkglist="larcore lardata larevt larsim larreco larana larpandora lareventdisplay larexamples larsoft larbatch larutils"

for REP in $pkglist
do
  cd ${MRB_SOURCE}  || { echo "ERROR: cannot cd to ${MRB_SOURCE}"; exit 1; }
  rm -f lar*
  if [ -d ${source_code_dir}/${REP} ]
  then
     echo "INFO: building ${REP}"
     do_build ${REP}
  else
     echo "INFO: did not find ${source_code_dir}/${REP}"
  fi
done

echo
echo "`basename ${0}`: test build successful"
echo

exit 0

