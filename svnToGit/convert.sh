#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck

# make sure .root files are excluded
# use verbose on all
# files excludes from all options go into larobsolete

usage()
{
   echo "USAGE: `basename ${0}` <working_dir>"
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

working_dir=${1}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi

if [ -d ${working_dir} ]
then
  echo "ERROR: ${working_dir} already exists - we need to create an empty directory"
  exit 1
fi
mkdir -p ${working_dir} || { echo "ERROR: failed to create ${working_dir}"; exit 1; }

author_list=/home/garren/larsoft/laradmin/svnToGit/larsoft.git.author.list
larsoft_svn=http://cdcvs.fnal.gov/subversion/larsoftsvn
larsoft_dir_list="larcore larexamples lardata larevt larsim larreco larana larpandora lareventdisplay larsoft uboonecode lbnecode larobsolete"

get_this_dir

for dir in ${larsoft_dir_list}
do
  fulldir=${working_dir}/${dir}
  mkdir -p ${fulldir} || ( echo "failed to create ${fulldir}"; exit 1; )
  echo "_____________________________________________________________________"
  echo "make ${dir}"
  ${thisdir}/convert_${dir}.sh ${fulldir} ${author_list} ${larsoft_svn} &
done

