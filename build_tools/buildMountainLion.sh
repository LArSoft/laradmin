#!/bin/bash

work_dir=${1}
version=${2}

echo "working directory: ${work_dir}"
echo "version is ${version}"

working_dir=${work_dir}/build
if [ ! -d ${work_dir}/build ]
then
 mkdir -p ${work_dir}/build
fi
cd ${work_dir}/build || exit 1
##curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/buildLAr-${version}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/pullProductsLAr-${version}
ls
chmod +x pullProductsLAr-${version}
##chmod +x buildLAr-${version}
./pullProductsLAr-${version} ${working_dir} source larsoft || exit 1
# pulling binaries is allowed to fail
./pullProductsLAr-${version} ${working_dir} d12 nu e5 debug 
./pullProductsLAr-${version} ${working_dir} d12 nu e5 prof 
echo
echo "begin build"
echo
./buildLAr-${version} -t ${working_dir} debug larsoft || exit 1
./buildLAr-${version} -t ${working_dir} prof larsoft || exit 1

exit 0