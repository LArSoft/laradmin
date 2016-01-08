#!/bin/bash

# make a laradmin ups product


usage()
{
   echo "USAGE: `basename ${0}` <product_dir> <tag>"
   echo "       `basename ${0}` installs laradmin as a relocatable ups product"
}

get_my_dir() 
{
    ( cd / ; /bin/pwd -P ) >/dev/null 2>&1
    if (( $? == 0 )); then
      pwd_P_arg="-P"
    fi
    reldir=`dirname ${0}`
    mydir=`cd ${reldir} && /bin/pwd ${pwd_P_arg}`
}


product_dir=${1}
pkgver=${2}

if [ -z ${product_dir} ]
then
   echo "ERROR: please specify the product directory"
   usage
   exit 1
fi
if [ -z ${pkgver} ]
then
   echo "ERROR: please specify a tag"
   usage
   exit 1
fi

package=laradmin
pkgdotver=`echo ${pkgver} | sed -e 's/_/./g' | sed -e 's/^v//'`

get_my_dir

pkgdir=${product_dir}/${package}
if [ ! -d ${pkgdir} ]
then
  mkdir -p ${pkgdir} || exit 2;
fi

# cleanup the old directory if necessary
if [ -d ${pkgdir}/${pkgver} ]
then
   set -x
   rm -rf ${pkgdir}/${pkgver} ${pkgdir}/${pkgver}.version ${pkgdir}/current.chain
   set +x
fi

set -x
# pull the tagged release from git
mkdir -p ${pkgdir}/${pkgver}/src
cd ${pkgdir}/${pkgver}/src
git archive --prefix=laradmin-${pkgver}/ \
            --remote ssh://p-${package}@cdcvs.fnal.gov/cvs/projects/${package} \
            -o ${package}-${pkgver}.tar ${pkgver}
tar xf ${package}-${pkgver}.tar
set +x

if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`

# now run cmake
mkdir -p ${pkgdir}/${pkgver}/build
cd ${pkgdir}/${pkgver}/build
setup cmake v3_0_1
cmake -DCMAKE_INSTALL_PREFIX=${product_dir} ${pkgdir}/${pkgver}/src/laradmin-${pkgver}
make install
make package
mv laradmin-${pkgdotver}-noarch.tar.bz2 ${product_dir}/

ups list -aK+ ${package} ${pkgver}   -z ${product_dir}

exit 0

