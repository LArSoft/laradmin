#!/usr/bin/env bash

# make a v05_00_00_rc working directory
function usage() {
    echo "Usage: basename(0) <working_directory>"
}

working_dir=${1}
branch=v05_00_00_rc

if [ -z "${working_dir}" ]
then
    echo 'ERROR: the working directory was not specified'
    echo
    usage
    exit 1
fi
if [ -d ${working_dir}/${branch} ]
then
    echo 'ERROR:  ${working_dir}/${branch} already exists!'
    usage
    exit 1
fi
mkdir -p ${working_dir}/${branch} || { echo "ERROR: failed to create ${working_dir}/${branch}"; exit 1; }
mkdir -p ${working_dir}/${branch}/p  ${working_dir}/${branch}/d || { echo "ERROR: failed to create ${working_dir}/${branch}/p"; exit 1; }
cd ${working_dir}/${branch}
echo "run mrb newDev"
mrb newDev -f -v ${branch} -q e9:prof -T p || exit 1
mrb newDev -f -v ${branch} -q e9:debug -T d || exit 1
echo "source localProductsXXX/setup"
source p/localProducts*/setup
cd $MRB_SOURCE
echo "checkout larsoft_suite"
mrb g -b ${branch} larsoft_suite
echo "checkout lar1ndcode"
mrb g -b ${branch} lar1ndcode
echo "checkout lariatsoft"
mrb g -b ${branch} lariatsoft
echo "checkout dunetpc"
mrb g -b ${branch} dunetpc
echo "checkout uboonecode"
mrb g -b ${branch} uboonecode
echo "checkout argoneutcode"
mrb g -b ${branch} argoneutcode


exit 0
