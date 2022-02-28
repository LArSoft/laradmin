#!/bin/bash

for d in larana larcore lardata lareventdisplay larevt larexamples larpandora larreco larsim larsoft lbnecode uboonecode
do
cd $MRB_SOURCE/$d
git st
git diff
git commit -m"more realistic minimum required versions" CMakeLists.txt || exit 1
git push || exit 1
##git tag -a -f -m"use cetbuildtools v3_10_01" v1_01_00 || exit 1
##git push --force --tags
done

exit 0
