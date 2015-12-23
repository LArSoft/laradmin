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

hash_file=${PWD}/lib_name.pl
echo > ${hash_file}
echo "dirs = (" >>  ${hash_file}


# larreco/HitFinder, larsim/LArG4, and larana/OpticalDetector have multiple libraries per directory
# This breaks the convention of one library per directory.  
# The multiple libraries have been in place since larsoft was converted from svn.
# Therefore, we choose to combine all code into a single library.
# 

for REP in $pkglist
do
   echo
   echo "begin ${REP}"
   cd $MRB_SOURCE/${REP} || exit 1
   # remove LIBRARY_NAME
   for F in `find ${REP} -name CMakeLists.txt | xargs grep -w LIBRARY_NAME | cut -d: -f1 | sort -u`
   do 
      ## first list the translation
      dirn=`dirname $F | sed -e 's%\/%_%g'`
      libn=`grep LIBRARY_NAME $F | sed -e 's%\(.*\)LIBRARY_NAME\(.*\)%\2%' | sed -e 's/ //g'`
      echo "        \"${libn}\" => \"${dirn}\"," >>  ${hash_file}
      ## now edit CMakeLists.txt
      sed -i.bak -e's%\(.*\)LIBRARY_NAME\(.*\)%\1%' $F
   done

done

echo "     )" >>  ${hash_file}

echo "created ${hash_file}"

exit 0

