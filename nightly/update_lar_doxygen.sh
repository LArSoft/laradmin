#!/bin/sh

export DOXVER=doxygen-1.7.5.1
export LARNIGHTLY=/grid/fermiapp/larsoft/home/larsoft/code/nightly_build/srcs
export LARHOME=/grid/fermiapp/larsoft/home/larsoft
export LARPRODUCTS=/grid/fermiapp/larsoft/products
export LAR_WWW=/nusoft/app/web/htdoc/larsoft/doxsvn

source ${LARPRODUCTS}/setup
setup larsoft v1_00_01 -q e4:debug

echo Running Doxygen
cd ${LARHOME}/doxygen

# remove the previous nights doxygen log
if [ -e lar_doxygen.log ] ; then
    rm lar_doxygen.log
fi

# remove the previous build of the html files
if [ -d dox/html ] ; then
    rm -rf dox/html
    mkdir dox/html
fi

${DOXVER}/bin/doxygen doxylar > lar_doxygen.log

cd ${LAR_WWW}
rm -rf ./html
echo Copying output
cp -r ${LARHOME}/doxygen/dox/html/ ./html

echo done at `date`


