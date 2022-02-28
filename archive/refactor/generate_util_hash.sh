#!/bin/bash

# files in lardata/Utilities are listed individually to avoid conflicts

if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE is not defined'
    exit 1
fi
if [ ! -r ${MRB_SOURCE}/CMakeLists.txt ]; then
    echo "${MRB_SOURCE}/CMakeLists.txt not found"
    exit 1
fi

hash_file=${MRB_SOURCE}/util_header_hash.pl
echo > ${hash_file}
echo "dirs = (" >>  ${hash_file}

REP=lardata
   echo
   echo "begin ${REP}"
   cd ${MRB_SOURCE}/${REP}/${REP}/Utilities || exit 1
   list=`ls *.h`
   for hdr_file in $list
   do
      echo "                        \"Utilities/${hdr_file}\" => \"${REP}/Utilities/${hdr_file}\"," >>  ${hash_file}
   done
echo "     )" >>  ${hash_file}

echo "created ${hash_file}"

exit 0

