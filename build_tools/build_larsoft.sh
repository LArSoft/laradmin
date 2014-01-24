#!/bin/bash

# Use this script to build all of LarSoft
# This is a very stupid script, it builds everything regardless of whether it has already been built or not

usage()
{
   echo "USAGE: `basename ${0}` <product_dir> <version> <e4> <debug|opt|prof> [-jN]"
   echo "        you must be able to write in <product_dir>"
   echo "        art, root, etc. need to be in your $PRODUCTS path"
   echo "        -jN (select a number) is the number of parallel build threads"
}

product_dir=${1}
pkgver=${2}
basequal=${3}
extraqual=${4}
npar=${5}

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

package=larsoft_suite
#pkgver=v1_00_00
pkgdotver=`echo ${pkgver} | sed -e 's/_/./g' | sed -e 's/^v//'`

tardir=${my_dir}/tar
pkgdir=${product_dir}/${package}/${pkgver}
blddir=${pkgdir}/build
sourcedir=${pkgdir}/build/code

if [ ! -d ${tardir} ]
then
    echo "ERROR: cannot find ${tardir}"
    usage
    exit 1
fi

mkdir -p ${blddir}
if [ ! -d ${blddir} ]
then
   echo "ERROR: cannot find ${blddir}"
   exit 1
fi

if [ "${extraqual}" = "opt" ]
then
    command="-o"
elif [ "${extraqual}" = "debug" ]
then
    command="-d"
elif [ "${extraqual}" = "prof" ]
then
    command="-p"
else
   echo "ERROR: please specify debug, opt, or prof"
   usage
   exit 1
fi
if [ ! "${basequal}" = "e4" ]
then
   echo "ERROR: the qualifier must be e4"
   usage
   exit 1
fi
if [ "${npar}" = "-jN" ]
then
  npar=""
fi

# make sure we can use the setup alias
if [ -z ${UPS_DIR} ]
then
   echo "ERROR: please setup ups"
   exit 1
fi
source `${UPS_DIR}/bin/ups setup ${SETUP_UPS}`

# ups flavor
OS1=`uname`
flvr=`ups flavor`
if [ ${OS1} = "Darwin" ]
then
    flvr=`ups flavor -2`
fi

if [ -d ${product_dir} ]
then
  echo "${product_dir} exists"
  # make sure we can write in the directory
  testname=${product_dir}/mytestdir$$$$
  mkdir ${testname}
  if [ -d ${testname} ]
  then
    rm -rf ${testname}
  else
    echo "ERROR: ${product_dir} is not writeable by you"
    usage
    exit 1
  fi
else
  echo "creating ${product_dir}"
  mkdir -p ${product_dir}
  if [ ! -d ${product_dir} ]
  then
     echo "ERROR: failed to create ${product_dir}"
     exit 1
  fi
fi

# copy the .upsfiles directory if necessary
if [ ! -d ${product_dir}/.upsfiles ]
then
   cp -pr ${UPS_DIR}/../../../.upsfiles ${product_dir} || exit 1;
fi
if [ ! "${PRODUCTS}" = "${product_dir}" ]
then
   export PRODUCTS=${product_dir}:${PRODUCTS}
fi

# OK - ready to build
# build order: 
# 1. larcore 
# 2. lardata
# 3. larevt
# 4. larsim
# 5. larreco
# 6. larana, lareventdisplay, larexamples, larpandora
# 7. larsoft

# list in build order
larsoft_list="larcore  lardata larevt larsim larreco larana larexamples lareventdisplay larpandora larsoft"
for code in ${larsoft_list}
do
  echo ""
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "setup for ${code} ${extraqual} build"
  builddir=${blddir}/${code}/${flvr}-${basequal}-${extraqual}
  if [ -d ${builddir} ]
  then
    rm -rf ${builddir}
  fi
  mkdir -p ${builddir} || exit 1;
  mkdir -p ${sourcedir}/${code} || exit 1;
  echo "extract ${code} from ${tardir}/${code}.${pkgdotver}.tbz2"
  cd ${sourcedir}/${code}
  tar xf ${tardir}/${code}.${pkgdotver}.tbz2
  echo "begin building ${code} ${basequal} ${extraqual}"
  cd ${builddir}
  echo ""
  echo "source ${sourcedir}/${code}/ups/setup_for_development ${command}"
  source ${sourcedir}/${code}/ups/setup_for_development ${command} || exit 1;
  echo ""
  echo "buildtool -I ${product_dir} -i ${npar}"
  # adding -p to build a package tarball
  buildtool -I ${product_dir} -i -p ${npar} >& ${my_dir}/log.build.${code}.${basequal}.${extraqual} || exit 1;
  # move the tarball to the build directory
  mv ${builddir}/${code}-${pkgdotver}*.tar.bz2 ${my_dir}/ || exit 1;
done

echo "use tar_larsoft_suite.sh ${basequal} ${extraqual} to make the larsoft_suite tarball"

exit 0
