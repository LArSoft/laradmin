#!/bin/bash

# Determine this command name
thisComFull=$(basename $0)
fullCom="${thisComFull%.*}"

# Usage function
function usage() {
    echo "Usage: $fullCom <working_dir>"
    echo "       mkdir <working_dir>"
    echo "       translate redmine wiki to github markdown in <working_dir>"
    echo
}

create_working_directory() {
  if [ -z "${working_dir}" ]
  then
      echo 'ERROR: the working directory was not specified'
      echo
      usage
      exit 1
  fi
  if [ -d ${working_dir} ]
  then
      echo 'ERROR:  ${working_dir} already exists!'
      usage
      exit 1
  fi
  mkdir -p ${working_dir} || { echo "ERROR: failed to create ${working_dir}"; exit 1; }
}

# Determine command options (just -h for help)
while getopts ":h" OPTION
do
    case $OPTION in
        h   ) usage ; exit 0 ;;
        *   ) echo "ERROR: Unknown option" ; usage ; exit 1 ;;
    esac
done

working_dir=${1}

if [ -z "${working_dir}" ]
then
    echo 'ERROR: no working directory specified'
    usage
    exit 1
fi

create_working_directory 

exit 0
