#!/bin/bash

work_dir=${1}
version=${2}

echo "working directory: ${work_dir}"
ls ${work_dir}

echo "version is ${version}"

cd ${work_dir}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/buildLAr-${version}
curl --fail --silent --location --insecure -O http://oink.fnal.gov/distro/larsoft/pullProductsLAr-${version}
ls


