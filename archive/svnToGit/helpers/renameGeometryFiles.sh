#!/bin/bash

ublist=`find Geometry/gdml -type f | grep -i uboone`

ublist2=`find Geometry/gdml -type f | grep -i microboone`

for file in ${ublist}
do
 echo "git mv ${file}  ${file}.sample"
done

for file in ${ublist2}
do
 echo "git mv ${file}  ${file}.sample"
done

lbnelist=`find Geometry/gdml -type f | grep -i lbne`

for file in ${lbnelist}
do
 echo "git mv ${file}  ${file}.sample"
done

exit 0
