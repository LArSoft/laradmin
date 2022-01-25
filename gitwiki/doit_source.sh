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
  git clone git@github.com:LArSoft/larsoft.github.io.git
}

get_wiki_files() {
  cd ${working_dir}/redmine-lib/bash || { echo "ERROR: cd ${working_dir}/redmine-lib/bash failed"; exit 1; } 
  sed -i -e 's/ups/larsoft/' download_wiki*.sh  || { echo "ERROR:edit of download files failed"; exit 1; }
  echo 
  echo "You are about to have one try to type your services password correctly."
  echo "If this step fails, rm -rf ${workdir} and run this command again."
  echo
  #source download_wiki.sh
  source download_wiki_source.sh
  if [ -d /tmp/larsoft_wiki_source ]; then
    mv /tmp/larsoft_wiki_source ${working_dir}/orig/
  else
    echo "ERROR: cannot find /tmp/larsoft_wiki_source"
    exit 1;
  fi
}

convert_files() {
  cd ${working_dir}/markdown || { echo "ERROR: cd ${working_dir}/markdown failed"; exit 1; }
  cp -p ../orig/larsoft_wiki_source/* . || { echo "ERROR: failed to copy redmine files"; exit 1; }
  rm index.textile || { echo "ERROR: failed to remove redmine index.textile"; exit 1; }
  rm new.textile || { echo "ERROR: failed to remove redmine new.textile"; exit 1; }
  rm OBSOLETE* || { echo "ERROR: failed to remove OBSOLETE files"; exit 1; }
  sed -i -e 's%"The Scisoft Team":mailto:scisoft-team@fnal.gov%The Scisoft Team%g' *
  sed -i -e 's%"Gianluca Petrillo":mailto:petrillo@slac.stanford.edu%Gianluca Petrillo%g' *
  sed -i -e 's%"Gianluca Petrillo":mailto:petrillo@fnal.gov%Gianluca Petrillo%g' *
  sed -i -e 's%Gianluca Petrillo (petrillo@fnal.gov)%Gianluca Petrillo%g' *
  #${laradmin_dir}/convert.pl *
  for in_file in `ls -1 *.textile`; do
    file_base=$(basename --suffix=.textile $in_file)
    out_file=${file_base}.tmp
    echo "converting $in_file to $out_file"
    ~/bin/pandoc --wrap=none -f textile -t gfm -s ${in_file} -o ${out_file}  || exit 1
    ${laradmin_dir}/convert_source.pl ${file_base}
  done
}

move_files() {
  cd ${working_dir}/larsoft.github.io || { echo "ERROR: cd ${working_dir}/larsoft.github.io failed"; exit 1; }
  if [ ! -d testwiki/releases ]; then 
     mkdir -p testwiki/releases
  fi
  cp ../markdown/*.md testwiki/ || { echo "ERROR: failed to move markdown files"; exit 1; }
  cd testwiki || { echo "ERROR: cd testwiki failed"; exit 1; }
  mv Release* releases/ || { echo "ERROR: mv Releases* failed"; exit 1; }
  mv Retired_Production_Releases.md releases/ || { echo "ERROR: mv Retired_Production_Releases.md failed"; exit 1; }
  mv Older_Releases.md releases/ || { echo "ERROR: mv Older_Releases.md failed"; exit 1; }
  mv LArSoft_release_list.md releases/ || { echo "ERROR: mv LArSoft_release_list.md failed"; exit 1; }
  mv Initial_Releases.md releases/ || { echo "ERROR: mv Initial_Releases.md failed"; exit 1; }
  mv FutureChanges.md releases/ || { echo "ERROR: mv FutureChanges.md failed"; exit 1; }
  mv Core_Services_Review.md releases/ || { echo "ERROR: mv Core_Services_Review.md failed"; exit 1; }
  mv Explicit_code_changes_since_v06_18_00.md releases/ || { echo "ERROR: mv Explicit_code_changes_since_v06_18_00.md failed"; exit 1; }
  mv Breaking_Changes*.md releases/ || { echo "ERROR: mv Breaking_Changes*.md failed"; exit 1; }
  sed -i -e 's%(LArSoft_release_list)%(releases/LArSoft_release_list)%g' *.md
  sed -i -e 's%(FutureChanges)%(releases/FutureChanges)%g' *.md
  sed -i -e 's%(Core_Services_Review)%(releases/Core_Services_Review)%g' *.md
  sed -i -e 's%(Breaking_Changes)%(releases/Breaking_Changes)%g' *.md
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
