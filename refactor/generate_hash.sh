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

larlist="larcore lardata larevt larsim lareventdisplay larexamples larreco larpandora larana"

hash_file=${PWD}/header_hash.pl
echo > ${hash_file}
echo "dirs = (" >>  ${hash_file}

for REP in $larlist
do
   echo
   echo "begin ${REP}"
   cd ${MRB_SOURCE}/${REP}/${REP} || exit 1
   reflist=""
   list=`ls -1`
   for subdir in $list
   do
      if [ -d $subdir ]
      then
	  reflist="$reflist $subdir"
          echo "                        \"${subdir}\" => \"${REP}/${subdir}\"," >>  ${hash_file}
      fi
   done
   #echo "       ${REP} => [qw( ${reflist} )]"
   #echo "       ${REP} => [qw( ${reflist} )]" >>  ${hash_file}
done
echo "     )" >>  ${hash_file}

echo "created ${hash_file}"

exit 0

