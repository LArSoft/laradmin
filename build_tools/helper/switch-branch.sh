#!/bin/bash

for d in larana larcore lardata lareventdisplay larevt larexamples larpandora larreco larsim larsoft lbnecode uboonecode
do
cd $MRB_SOURCE/$d
git st
git checkout v02_01_00_branch
git st
done

exit 0
