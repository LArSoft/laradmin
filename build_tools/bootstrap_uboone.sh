#!/bin/bash

# This script creates a source code tarball for uboonecode.

usage()
{
   echo "USAGE: `basename ${0}` <product_dir> <version>"
}

get_this_dir() 
{
    ( cd / ; /bin/pwd -P ) >/dev/null 2>&1
    if (( $? == 0 )); then
      pwd_P_arg="-P"
    fi
    reldir=`dirname ${0}`
    thisdir=`cd ${reldir} && /bin/pwd ${pwd_P_arg}`
}

product_dir=${1}
pkgver=${2}
package=uboonecode

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
pkgdotver=`echo ${pkgver} | sed -e 's/_/./g' | sed -e 's/^v//'`

get_this_dir

pkgdir=${product_dir}/${package}/${pkgver}

# This is a bootstrap script, it needs to start with an empty directory
# remove any existing distribution
if [ -d ${pkgdir} ]
then
    echo "removing previous install of ${package} ${pkgver}"
    rm -rf ${pkgdir}  || exit 1;
    rm -rf ${pkgdir}.version
fi

# now build the new package source code distribution
mkdir -p ${pkgdir}/tar
if [ ! -d ${pkgdir}/tar ]
then
   echo "ERROR: cannot find ${pkgdir}/tar"
   exit 1
fi

set -x

cd ${pkgdir}
cp -p ${thisdir}/build_uboone.sh .|| exit 1;
#cp -p ${thisdir}/tar_uboonecode.sh .|| exit 1;

cd ${pkgdir}/tar
curl --fail --silent --location --insecure \
   "http://cdcvs.fnal.gov/cgi-bin/git_archive.cgi/cvs/projects/${package}.${pkgver}.tbz2" \
   > "${package}.${pkgdotver}.tbz2" || \
   { echo "ERROR: Unable to obtain source from Redmine for ${package} ${pkgver}" 1>&2; exit 1; }

set +x

cd ${product_dir}
tar cjf ${package}-${pkgdotver}-source.tar.bz2 ${package}/${pkgver}/*.sh ${package}/${pkgver}/tar || exit 1;

exit 0


