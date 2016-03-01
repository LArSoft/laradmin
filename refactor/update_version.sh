#!/bin/bash

function usage() {
    echo "Usage: basename(0) <release_number>"
}

release_number=${1}
if [ -z "${release_number}" ]
then
    echo 'ERROR: the release number was not specified'
    echo
    usage
    exit 1
fi


if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE is not defined'
    exit 1
fi
if [ ! -r ${MRB_SOURCE}/CMakeLists.txt ]; then
    echo "${MRB_SOURCE}/CMakeLists.txt not found"
    exit 1
fi

larlist="larcore lardata larevt larsim lareventdisplay larexamples larreco larpandora larana larsoft"

cd ${MRB_SOURCE} || exit 1

for REP in $larlist
do
   echo
   mrb uv ${REP} ${release_number}
done

exit 0

