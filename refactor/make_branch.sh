#!/usr/bin/env bash

# make v05_00_branch
function usage() {
    echo "Usage: basename(0) <larsoft_suite_tag>"
}


larsoft_suite_tag=${1}
v05branch=v05_00_branch

if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE is not defined'
    exit 1
fi
if [ ! -r $MRB_SOURCE/CMakeLists.txt ]; then
    echo "$MRB_SOURCE/CMakeLists.txt not found"
    exit 1
fi

if [ -z "${larsoft_suite_tag}" ]
then
    echo 'ERROR: the larsoft suite tag (e.g., LARSOFT_SUITE_v04_36_01) was not specified'
    echo
    usage
    exit 1
fi


cd ${MRB_SOURCE}

larpkglist="larcore lardata larevt larsim lareventdisplay larexamples larreco larpandora larana larsoft"
for REP in $larpkglist
do
   echo
   echo "begin ${REP}"
   cd $MRB_SOURCE/${REP} || exit 1
   git co ${larsoft_suite_tag}
   git co -b ${v05branch}
done

exppkglist="argoneutcode dunetpc duneutil lariatsoft lar1ndcode uboonecode ubutil"
for REP in $exppkglist
do
   echo
   echo "begin ${REP}"
   cd $MRB_SOURCE/${REP} || exit 1
   git co develop
   git co -b ${v05branch}
done

exit 0
