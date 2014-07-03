#!/bin/bash

work_dir=${1}
version=${2}
dotver=`echo ${version} | sed -e 's/_/./g' | sed -e 's/^v//'`

echo "working directory: ${work_dir}"
echo "version is ${version} ${dotver}"

flvr=slf`lsb_release -r | sed -e 's/[[:space:]]//g' | cut -f2 -d":" | cut -f1 -d"."`
echo "flavor is ${flvr}"

working_dir=/data/build/larsoft-${dotver}
if [ ! -d ${working_dir} ]
then
 mkdir -p ${working_dir}
fi
cd ${working_dir} || exit 1
##curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/buildLAr-${version}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/pullProductsLAr-${version}
ls
chmod +x pullProductsLAr-${version}
##chmod +x buildLAr-${version}
./pullProductsLAr-${version} ${working_dir} source larsoft || exit 1
# pulling binaries is allowed to fail
./pullProductsLAr-${version} ${working_dir} ${flvr} nu e5 debug 
./pullProductsLAr-${version} ${working_dir} ${flvr} nu e5 prof 
echo
echo "begin build"
echo
./buildLAr-${version} -t ${working_dir} debug larsoft || exit 1
./buildLAr-${version} -t ${working_dir} prof larsoft || exit 1

exit 0
