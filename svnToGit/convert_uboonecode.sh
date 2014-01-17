#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck


usage()
{
   echo "USAGE: `basename ${0}` <working_dir> <author_list> <svn_repository>"
}

working_dir=${1}
author_list=${2}
larsoft_svn=${3}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
if [ -z ${author_list} ]
then
   echo "ERROR: please specify the author list"
   usage
   exit 1
fi
if [ -z ${larsoft_svn} ]
then
   echo "ERROR: please specify the svn repository"
   usage
   exit 1
fi

if [ ! -d ${working_dir} ]
then
  echo "ERROR: ${working_dir} does not exist"
  exit 1
fi

source /products/setups || { echo "ERROR: setup of ups failed"; exit 1; }
setup git || { echo "ERROR: setup of git failed"; exit 1; }

cd ${working_dir}

exit 0
