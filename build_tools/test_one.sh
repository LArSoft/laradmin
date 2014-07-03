#!/bin/bash

# build all of larsoft plus lbnecode and uboonecode
# for now, this script presumes it will run on cluck

usage()
{
   echo "USAGE: `basename ${0}` <version>"
}


newver=${1}

if [ -z ${newver} ]
then
   echo "ERROR: please specify the version"
   usage
   exit 1
fi

work_dir=/home/garren/scratch/larsoft/${newver}/test_one
if [ -d ${work_dir} ]
then
   echo "ERROR: ${work_dir} already exists"
   exit 1
fi

mkdir -p ${work_dir} || { echo "ERROR: cannot create  ${work_dir}"; exit 1; }

package_list="larcore larpandora lardata larevt larsim larreco larana larexamples lareventdisplay larsoft lbnecode uboonecode"
for pkg in ${package_list}
do
   /home/garren/larsoft/laradmin/build_tools/build_one.sh ${work_dir}  ${pkg} ${newver}
done

echo
echo "`basename ${0}`: test build successful"
echo

exit 0

