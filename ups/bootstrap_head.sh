#!/bin/bash

# make a laradmin ups product


usage()
{
   echo "USAGE: `basename ${0}` <product_dir>"
   echo "       `basename ${0}` installs laradmin as a relocatable ups product"
}

get_my_dir() 
{
    ( cd / ; /bin/pwd -P ) >/dev/null 2>&1
    if (( $? == 0 )); then
      pwd_P_arg="-P"
    fi
    reldir=`dirname ${0}`
    mydir=`cd ${reldir}/.. && /bin/pwd ${pwd_P_arg}`
}


product_dir=${1}

if [ -z ${product_dir} ]
then
   echo "ERROR: please specify the product directory"
   usage
   exit 1
fi

package=laradmin

get_my_dir

pkgdir=${product_dir}/${package}
if [ ! -d ${pkgdir} ]
then
  mkdir -p ${pkgdir} || exit 2;
fi

# cleanup the old directory if necessary
if [ -d ${pkgdir}/build ]
then
   set -x
   rm -rf ${pkgdir}/build || exit 1;
   set +x
fi

if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`

# now run cmake
setup cmake
set -x
mkdir -p ${pkgdir}/build
cd ${pkgdir}/build
cmake -DCMAKE_INSTALL_PREFIX=${product_dir} ${mydir}
make install
make package
set +x

ups list -aK+ ${package} ${pkgver}   -z ${product_dir}

exit 0

