#!/bin/bash

if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE is not defined'
    exit 1
fi
if [ ! -r $MRB_SOURCE/CMakeLists.txt ]; then
    echo "$MRB_SOURCE/CMakeLists.txt not found"
    exit 1
fi

pkglist="larcore lardata larevt larsim lareventdisplay larexamples larreco larpandora larana"


for REP in $pkglist
do
   echo
   echo "begin ${REP} ${version}"
   cd $MRB_SOURCE/${REP} || exit 1
   reflist=""
   list=`ls -1`
   for file in $list
   do
      if [ -d $file ]
      then
	if [ "${file}" != "test" ] && [ "${file}" != "doc" ] && [ "${file}" != "ups" ] && [ "${file}" != "${REP}" ]
	then
	  reflist="$file $reflist"
	fi
      fi
   done
   mkdir ${REP}
   new_cmake=${MRB_SOURCE}/${REP}/${REP}/CMakeLists.txt
   echo > ${new_cmake}
   for refdir in $reflist
   do
      echo "git mv $refdir ${REP}/$refdir"
      git mv $refdir ${REP}/$refdir || exit 1
      git commit -m"move $refdir to ${REP}/$refdir"
      echo "add_subdirectory($refdir)" >> ${new_cmake}
   done
   echo >> ${new_cmake}
   git add ${REP}/CMakeLists.txt
   git commit -m"add ${REP}/${REP}/CMakeLists.txt" ${REP}/CMakeLists.txt
done

exit 0

