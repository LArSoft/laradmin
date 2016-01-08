#!/bin/bash

work_dir=${1}
version=${2}
build_type=${3}
dotver=`echo ${version} | sed -e 's/_/./g' | sed -e 's/^v//'`

echo "working directory: ${work_dir}"
echo "version is ${version} ${dotver}"

flvr=slf`lsb_release -r | sed -e 's/[[:space:]]//g' | cut -f2 -d":" | cut -f1 -d"."`
echo "flavor is ${flvr}"

working_dir=/data/build/larsoft-${dotver}/${build_type}
if [ ! -d ${working_dir} ]
then
 mkdir -p ${working_dir}
fi
cd ${working_dir} || exit 1
curl --fail --silent --location --insecure -O http://scisoft.fnal.gov/scisoft/bundles/tools/pullProducts
chmod +x pullProducts
./pullProducts ${working_dir} source larsoft-${version} || exit 1
# pulling binaries is allowed to fail
./pullProducts ${working_dir} ${flvr} nu-v1_07_00 s5-e6 ${build_type} 
echo
echo "begin build"
echo
./buildFW -b e6 -s s5 -t ${working_dir} ${build_type} larsoft-${version} || exit 1

exit 0
