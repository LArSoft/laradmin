#!/bin/bash

work_dir=${1}
version=${2}

echo "working directory: ${work_dir}"
echo "version is ${version}"

cd ${work_dir}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/buildLAr-${version}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/pullProductsLAr-${version}
ls
chmod +x pullProductsLAr-${version}
chmod +x buildLAr-${version}
./pullProductsLAr-${version} ${work_dir} source larsoft
./pullProductsLAr-${version} ${work_dir} d12 larsoft e5 debug
./pullProductsLAr-${version} ${work_dir} d12 larsoft e5 prof
ls

