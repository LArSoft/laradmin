#!/bin/bash

# run by hand on a vm on LG's laptop

work_dir=${1}
version=${2}

echo "working directory: ${work_dir}"
echo "version is ${version}"

working_dir=${work_dir}
if [ ! -d ${work_dir} ]
then
 mkdir -p ${work_dir}
fi
cd ${work_dir} || exit 1
curl --fail --silent --location --insecure -O http://scisoft.fnal.gov/scisoft/projects/larsoft/${version}/pullProductsLAr-${version}
chmod +x pullProductsLAr-${version} || exit 1
./pullProductsLAr-${version} ${working_dir} source larsoft || exit 1
# pulling binaries is allowed to fail
./pullProductsLAr-${version} ${working_dir} d13 nu s5-e6 debug 
./pullProductsLAr-${version} ${working_dir} d13 nu s5-e6 prof 
echo
echo "begin build"
echo
./buildLAr-${version} -t ${working_dir} debug larsoft || exit 1
./buildLAr-${version} -t ${working_dir} prof larsoft || exit 1

exit 0
