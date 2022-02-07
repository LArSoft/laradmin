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

get_laradmin_dir() 
{
    ( cd / ; /bin/pwd -P ) >/dev/null 2>&1
    if (( $? == 0 )); then
      pwd_P_arg="-P"
    fi
    reldir=`dirname ${0}`
    laradmin_dir=`cd ${reldir} && /bin/pwd ${pwd_P_arg}`
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
  mkdir -p ${working_dir}/orig || { echo "ERROR: failed to create ${working_dir}/orig"; exit 1; }
  mkdir -p ${working_dir}/markdown || { echo "ERROR: failed to create ${working_dir}/markdown"; exit 1; }
}

run_git_clone() {
  cd ${working_dir} || { echo "ERROR: cd ${working_dir}" failed; exit 1; }
  git clone https://cdcvs.fnal.gov/projects/redmine-lib
  git clone git@github.com:art-framework-suite/ifdh-art.wiki.git
}

get_wiki_files() {
  cd ${working_dir}/redmine-lib/bash || { echo "ERROR: cd ${working_dir}/redmine-lib/bash failed"; exit 1; } 
  sed -i -e 's/ups/ifdh-art/' download_wiki*.sh  || { echo "ERROR:edit of download files failed"; exit 1; }
  echo 
  echo "You are about to have one try to type your services password correctly."
  echo "If this step fails, rm -rf ${workdir} and run this command again."
  echo
  #source download_wiki.sh
  source download_wiki_source.sh
  if [ -d /tmp/ifdh-art_wiki_source ]; then
    mv /tmp/ifdh-art_wiki_source ${working_dir}/orig/
  else
    echo "ERROR: cannot find /tmp/ifdh-art_wiki_source"
    exit 1;
  fi
}

convert_files() {
  cd ${working_dir}/markdown || { echo "ERROR: cd ${working_dir}/markdown failed"; exit 1; }
  cp -p ../orig/ifdh-art_wiki_source/* . || { echo "ERROR: failed to copy redmine files"; exit 1; }
  rm index.textile || { echo "ERROR: failed to remove redmine index.textile"; exit 1; }
  rm new.textile || { echo "ERROR: failed to remove redmine new.textile"; exit 1; }
  sed -i -e 's%"The Scisoft Team":mailto:scisoft-team@fnal.gov%The Scisoft Team%g' *
  for in_file in `ls -1 *.textile`; do
    file_base=$(basename --suffix=.textile $in_file)
    #out_file=${file_base}.tmp
    #echo "converting $in_file to $out_file"
    #~/bin/pandoc --wrap=none -f textile -t gfm -s ${in_file} -o ${out_file}  || exit 1
    ${laradmin_dir}/convert_source.pl ${file_base}
  done
  sed -i -e 's%^ *<code class="sh">%```sh%g' *.md
  sed -i -e 's%^ *<code class="css">%```css%g' *.md
  sed -i -e 's%^ *<code class="CPP">%```CPP%g' *.md
  sed -i -e 's%^ *</code>%```%g' *.md
  sed -i -e 's%{{\\>TOC}}%%g' *.md
}

move_files() {
  cd ${working_dir}/ifdh-art.wiki || { echo "ERROR: cd ${working_dir}/ifdh-art.wiki failed"; exit 1; }
  cp ../markdown/Debugging_SAM_job_sumbissions.md Debugging_SAM_job_submissions.md  || { echo "ERROR: failed to copy Debugging_SAM_job_submissions"; exit 1; }
  cp ../markdown/Wiki.md IFDH_Art_interface.md  || { echo "ERROR: failed to copy IFDH-Art-interface"; exit 1; }
  cp ../markdown/How_it_should_look.md .  || { echo "ERROR: failed to copy How_it_should_look"; exit 1; }
}

# Determine command options (just -h for help)
while getopts ":h" OPTION
do
    case $OPTION in
        h   ) usage ; exit 0 ;;
        *   ) echo "ERROR: Unknown option" ; usage ; exit 1 ;;
    esac
done

workdir=${1}

if [ -z "${workdir}" ]
then
    echo 'ERROR: no working directory specified'
    usage
    exit 1
fi

thisdir=${PWD}
working_dir="${thisdir}/${workdir}"
get_laradmin_dir

create_working_directory 
run_git_clone
get_wiki_files
convert_files
move_files

exit 0
