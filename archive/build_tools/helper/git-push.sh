#!/bin/bash

for d in larana larcore lardata lareventdisplay larevt larexamples larpandora larreco larsim larsoft lbnecode uboonecode
do
cd $MRB_SOURCE/$d
echo "push $d"
git status
git push origin develop
git status
done

exit 0
