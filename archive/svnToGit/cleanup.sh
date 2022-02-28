#!/bin/bash

# after convert finishes, do a bit of cleanup on each new git repository

# make sure .root files are excluded
# use verbose on all
# files excludes from all options go into larobsolete

usage()
{
   echo "USAGE: `basename ${0}` <working_dir>"
}

working_dir=${1}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi

if [ ! -d ${working_dir} ]
then
  echo "ERROR: ${working_dir} does not exist"
  exit 1
fi

larsoft_dir_list="larcore larexamples lardata larevt larsim larreco larana larpandora lareventdisplay larsoft uboonecode lbnecode larobsolete"

for dir in ${larsoft_dir_list}
do
  fulldir=${working_dir}/${dir}
  if [ ! -d ${fulldir} ]
  then
    echo "ERROR: ${fulldir} does not exist"
    exit 1
  fi
  echo "_____________________________________________________________________"
  cd ${fulldir}
  /home/garren/larsoft/laradmin/svnToGit/cleanup_repository.sh >& ../log.${dir}.clean &
done

