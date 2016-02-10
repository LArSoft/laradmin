#!/bin/bash

if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE is not defined'
    exit 1
fi
if [ ! -r ${MRB_SOURCE}/CMakeLists.txt ]; then
    echo "${MRB_SOURCE}/CMakeLists.txt not found"
    exit 1
fi
if [ -z "${MRB_BUILDDIR}" ]
then
    echo 'ERROR: MRB_BUILDDIR is not defined'
    exit 1
fi

larlist="larcore lardata larevt larsim lareventdisplay larexamples larreco larpandora larana"

hash_file=${PWD}/lib_hash.pl
echo > ${hash_file}
echo "dirs = (" >>  ${hash_file}

for REP in $larlist
do
   cd ${MRB_BUILDDIR}/${REP} || exit 1
   echo
   echo "begin ${REP}"
   reflist=""
   list=`find . -name "${REP}*.dir"`
   for subdir in $list
   do
      echo "                        \"\" => \"${subdir}\"," >>  ${hash_file}
   done
done
echo "     )" >>  ${hash_file}

echo "created ${hash_file}"

exit 0

