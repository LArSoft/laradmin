#!/bin/bash

# deal with CMakeLists.txt

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

fixfile=${PWD}/fixit.sh
rm -f ${fixfile}

echo "#!/bin/bash" > ${fixfile}

for REP in $larlist
do
   echo
   echo "begin ${REP}"
   echo "mv ${MRB_SOURCE}/${REP}/CMakeLists.txt ${MRB_SOURCE}/${REP}/CMakeLists.txt.bak" >> ${fixfile}
   cmd="\"cat ${MRB_SOURCE}/${REP}/CMakeLists.txt.bak"
   new_cmake=${MRB_SOURCE}/${REP}/${REP}/CMakeLists.txt
   if [ -e ${new_cmake} ]; then
     echo "${new_cmake} already exists - edit by hand if necessary"
   else
     cd ${MRB_SOURCE}/${REP}/${REP} || exit 1
     echo > ${new_cmake}
     reflist=""
     list=`ls -1`
     for subdir in $list
     do
	if [ -d $subdir ]
	then
	    reflist="$reflist $subdir"
	    echo "add_subdirectory($subdir)" >> ${new_cmake}
	    cmd+=" | sed 's%add_subdirectory($subdir)%%'"
	fi
     done
     echo >> ${new_cmake}
     echo "${cmd} > ${MRB_SOURCE}/${REP}/CMakeLists.txt" >> ${fixfile}
   fi
done

# now fix the top CMakeLists.txt files
##chmod +x ${fixfile}
##${fixfile} || exit 1
echo "Please edit the top CMakeLists.txt files by hand"

exit 0
