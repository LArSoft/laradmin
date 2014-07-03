#!/bin/bash

work_dir=${1}
version=${2}

echo "working directory: ${work_dir}"
echo "version is ${version}"

if [ ! -d ${work_dir}/build ]
then
 mkdir -p ${work_dir}/build
fi
cd ${work_dir}/build || exit 1
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/buildLAr-${version}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/pullProductsLAr-${version}
ls
chmod +x pullProductsLAr-${version}
chmod +x buildLAr-${version}
./pullProductsLAr-${version} ${work_dir} source larsoft || exit 1
./pullProductsLAr-${version} ${work_dir} d12 nu e5 debug || exit 1
./pullProductsLAr-${version} ${work_dir} d12 nu e5 prof || exit 1
echo
echo "begin build"
echo
./buildLAr-${version} -t ${work_dir} debug larsoft || exit 1
./buildLAr-${version} -t ${work_dir} prof larsoft || exit 1

exit 0
