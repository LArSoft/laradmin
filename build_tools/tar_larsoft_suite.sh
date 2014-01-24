#!/bin/bash

# Use this script to make a complete larsoft_suite tarball

usage()
{
   echo "USAGE: `basename ${0}` <product_dir> <version> <e4> <debug|opt|prof>"
}

product_dir=${1}
pkgver=${2}
basequal=${3}
extraqual=${4}

my_dir=${PWD}

if [ -z ${product_dir} ]
then
   echo "ERROR: please specify the product directory"
   usage
   exit 1
fi

if [ -z ${pkgver} ]
then
   echo "ERROR: please specify the package version"
   usage
   exit 1
fi

if [ ! "${basequal}" = "e4" ]
then
   echo "ERROR: the qualifier must be e4"
   usage
   exit 1
fi
if [ "${extraqual}" = "opt" ] || [ "${extraqual}" = "debug" ] || [ "${extraqual}" = "prof" ]
then
    echo "building tarball for -q ${basequal}:${extraqual}"
else
   echo "ERROR: please specify debug, opt, or prof"
   usage
   exit 1
fi

package=larsoft_suite
#pkgver=v1_00_00
pkgdotver=`echo ${pkgver} | sed -e 's/_/./g' | sed -e 's/^v//'`

# make sure we can use the setup alias
if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`

setup cetpkgsupport

# subdir names
dirname=`get-directory-name subdir ${basequal}.${extraqual}` || exit 1;
osname=`get-directory-name os` || exit 1;
plat=`get-directory-name platform` || exit 1;
if [ "${osname}" = "slf5" ]
then
  if [ "${plat}" = "x86_64" ]
  then
      prodname="Linux64bit+2.6-2.5_${basequal}_${extraqual}"
  else
      prodname="Linux+2.6-2.5_${basequal}_${extraqual}"
  fi
elif [ "${osname}" = "slf6" ]
then
  if [ "${plat}" = "x86_64" ]
  then
      prodname="Linux64bit+2.6-2.12_${basequal}_${extraqual}"
  else
      prodname="Linux+2.6-2.12_${basequal}_${extraqual}"
  fi
else
  echo "ERROR: don't know how to translate OS ${osname} for larsoft_suite tarball"
fi

# list in build order
larsoft_list="larcore  lardata larevt larsim larreco larana larexamples lareventdisplay larpandora larsoft"
for code in ${larsoft_list}
do
  # build up the directory list for the suite tarball
  tarlist="${tarlist} ${code}/${pkgver}/ups ${code}/${pkgver}.version/${prodname}"
  if [ -d ${product_dir}/${code}/${pkgver}/${dirname} ]; then tarlist="${tarlist} ${code}/${pkgver}/${dirname}"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/include ]; then tarlist="${tarlist} ${code}/${pkgver}/include"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/source ]; then tarlist="${tarlist} ${code}/${pkgver}/source"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/job ]; then tarlist="${tarlist} ${code}/${pkgver}/job"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/gdml ]; then tarlist="${tarlist} ${code}/${pkgver}/gdml"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/fcl ]; then tarlist="${tarlist} ${code}/${pkgver}/fcl"; fi
  if [ -d ${product_dir}/${code}/${pkgver}/cmake ]; then tarlist="${tarlist} ${code}/${pkgver}/cmake"; fi
done

set -x

cd ${product_dir}
tarname=`echo ${dirname} | sed -e 's/\./-/g'`
tar cjf ${package}-${pkgdotver}-${tarname}.tar.bz2 ${tarlist} 

set +x


exit 0
