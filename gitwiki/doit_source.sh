#!/bin/bash

# Determine this command name
thisComFull=$(basename $0)
fullCom="${thisComFull%.*}"

declare -a internal_files=(LArSoft_Internals.md \
 Adding_or_removing_users.md Building_with_clang.md \
 Code_analysis_process_and_tools.md \
 Code_and_Performance_analysis_tools.md \
 "Data_product_revision_(phase_II).md" \
 How_we_initialized_larsoft_cvmfs.md \
 Informal_list_of_experiment_contacts.md \
 Install_for_cvmfs.md \
 Installing_products_on_cvmfs.md \
 LArSoft_cvmfs.md \
 LArSoft_License.md \
 LArSoft_release_management.md \
 LArSoft_release_naming_policy.md \
 LArSoft_responsiblities_for_patch_releases.md \
 Migration_to_root_6.md \
 Move_to_v05.md \
 Overview_of_Building_a_LArSoft_Release.md \
 PMA_module_code_analysis.md \
 Policy_for_development_from_a_tagged_release.md \
 Procedure_to_create_a_new_version_of_larsoft_data.md \
 ProtoDUNE_and_DUNE_Far_Detector_v06_57_00.md \
 Special_Instructions_for_Major_Releases.md \
 Truncating_commit_history.md \
 Using_the_cetmodules_migration_script.md \
 Usability_improvements.md \
 What_Lynn_does.md)

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
  sed -i -e 's%(petrillo@fnal.gov)%Gianluca Petrillo%g' *
  sed -i -e 's%larsoft-team (larsoft-team@fnal.gov)%SciSoft Team%g' *
  sed -i -e 's%larsoft-team@fnal.gov%the SciSoft Team%g' *
  sed -i -e 's%scisoft-team@fnal.gov%The Scisoft Team%g' *
  sed -i -e 's%scisoft-team@listserv.fnal.gov%The Scisoft Team%g' *
  sed -i -e 's%Brian Rebel, brebel@fnal.gov%Brian Rebel%g' *
  sed -i -e 's%Brian Rebel (brebel@fnal.gov)%Brian Rebel%g' *
  sed -i -e 's%brebel@fnal.gov%Brian Rebel%g' *
  sed -i -e 's%kirby@fnal.gov%Mike Kirby%g' *
  sed -i -e 's%larsoft@fnal.gov%the larsoft mailing list%g' *
  sed -i -e 's%Herb Greenlee (greenlee@fnal.gov)%Herb Greenlee%g' *
  sed -i -e 's%Herbert Greenlee <greenlee@fnal.gov>%Herb Greenlee%g' *
  sed -i -e 's%Tingjun Yang <tjyang@fnal.gov>%Tingjun Yang%g' *
  sed -i -e 's%Thomas R. Junk <trj@fnal.gov>%Thomas R. Junk%g' *
  sed -i -e 's%Jacob Calcultt <calcuttj@msu.edu>%Jacob Calcultt%g' *
  sed -i -e 's%Etienne CHARDONNET <chardonn@apc.in2p3.fr>%Etienne Chardonnet%g' *
  sed -i -e 's%Tracy Usher <usher@slac.stanford.edu>%Tracy Usher%g' *
  sed -i -e 's%Johnny Ho <johnnyho@uchicago.edu>%Johnny Ho%g' *
  sed -i -e 's%Jonathan Asaadi <jonathan.asaadi@uta.edu>%Jonathan Asaadi%g' *
  sed -i -e 's%Brailsford, Dominic <d.brailsford@lancaster.ac.uk>%Dominic Brailsford%g' *
  sed -i -e 's%Andrzej Szelc <andrzej.szelc@manchester.ac.uk>%Andrzej Szelc%g' *
  sed -i -e 's%Miquel Nebot-Guinot <miquel.nebot@ed.ac.uk>%Miquel Nebot-Guinot%g' *
  for in_file in `ls -1 *.textile`; do
    file_base=$(basename --suffix=.textile $in_file)
    #out_file=${file_base}.tmp
    #echo "converting $in_file to $out_file"
    #~/bin/pandoc --wrap=none -f textile -t gfm -s ${in_file} -o ${out_file}  || exit 1
    ${laradmin_dir}/convert_source.pl ${file_base}
  done
  sed -i -e 's%^ *<code class="sh"> *$%```sh%g' *.md
  sed -i -e 's%^ *<code class="css"> *$%```css%g' *.md
  sed -i -e 's%^ *<code class="CPP"> *$%```CPP%g' *.md
  sed -i -e 's%^ *<code class="cpp"> *$%```cpp%g' *.md
  sed -i -e 's%^ *<code class="text"> *$%```text%g' *.md
  sed -i -e 's%^ *<code class="python"> *$%```python%g' *.md
  sed -i -e 's%^ *<code class="c"> *$%```c%g' *.md
  sed -i -e 's%^ *<code class="diff"> *$%```diff%g' *.md
  sed -i -e 's%^ *</code> *$%```%g' *.md
  sed -i -e 's%^\s*\\\#%1.%' *.md
  sed -i -e 's%{{\\>TOC}}%%g' *.md
  sed -i -e 's%{{\\>toc}}%%g' *.md
  sed -i -e 's%{{TOC}}%%g' *.md
  sed -i -e 's%{{toc}}%%g' *.md
  sed -i -e 's%http:%https:%g' *.md
  sed -i -e 's%&amp;nbsp;% %g' *.md
  sed -i -e "s%&#39;%'%g" *.md
  # fix redmine code links
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larcore/repository/revisions/develop/entry/%//github.com/LArSoft/larcore/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larcoreobj/repository/revisions/develop/entry/%//github.com/LArSoft/larcoreobj/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larcorealg/repository/revisions/develop/entry/%//github.com/LArSoft/larcorealg/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/lardata/repository/revisions/develop/entry/%//github.com/LArSoft/lardata/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/lardataobj/repository/revisions/develop/entry/%//github.com/LArSoft/lardataobj/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/lardataalg/repository/revisions/develop/entry/%//github.com/LArSoft/lardataalg/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larsim/repository/revisions/develop/entry/%//github.com/LArSoft/larsim/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larreco/repository/revisions/develop/entry/%//github.com/LArSoft/larreco/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larexamples/repository/revisions/develop/entry/%//github.com/LArSoft/larexamples/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larreco/repository/revisions/develop/show/%//github.com/LArSoft/larreco/blob/develop/%g' *.md
  sed -i -e 's%//cdcvs.fnal.gov/redmine/projects/larexamples/repository/revisions/develop/show/%//github.com/LArSoft/larexamples/blob/develop/%g' *.md
  sed -i -e 's%(LArSoftWiki%(/LArSoftWiki/index%g' *.md
}

move_files() {
  cd ${working_dir}/larsoft.github.io || { echo "ERROR: cd ${working_dir}/larsoft.github.io failed"; exit 1; }
  full_wiki_dir=${working_dir}/larsoft.github.io/${wiki_dir}
  if [ ! -d ${full_wiki_dir} ]; then 
     mkdir -p ${full_wiki_dir}
  fi
  cp ../markdown/*.md ${full_wiki_dir}/ || { echo "ERROR: failed to move markdown files"; exit 1; }
  cd ${full_wiki_dir} || { echo "ERROR: cd ${full_wiki_dir} failed"; exit 1; }
  mv LArSoftWiki.md index.md
  # releases
  if [ ! -d ${full_wiki_dir}/releases ]; then 
     mkdir -p ${full_wiki_dir}/releases
  fi
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
  sed -i -e 's%(FutureChanges)%(/LArSoftWiki/releases/FutureChanges)%g' *.md
  sed -i -e 's%(Core_Services_Review)%(releases/Core_Services_Review)%g' *.md
  sed -i -e 's%(Breaking_Changes)%(releases/Breaking_Changes)%g' *.md
  # internal files
  if [ ! -d ${full_wiki_dir}/LArSoftInternals ]; then
     mkdir -p ${full_wiki_dir}/LArSoftInternals
  fi
  for ifile in "${internal_files[@]}"; do
    mv ${ifile} LArSoftInternals/ || { echo "ERROR: mv ${ifile} failed"; exit 1; }
  done
  mv How_to_tag_and_build_a_LArSoft* LArSoftInternals/ || { echo "ERROR: mv How_to_tag_and_build_a_LArSoft* failed"; exit 1; }
  mv Removing_old_* LArSoftInternals/ || { echo "ERROR: mv Removing_old_* failed"; exit 1; }
  mv LArSoftInternals/LArSoft_Internals.md LArSoftInternals/index.md || { echo "ERROR: renaming LArSoft_Internals.md failed"; exit 1; }
  sed -i -e 's%(LArSoft_Internals)%(LArSoftInternals/)%g' *.md
  sed -i -e 's%(LArSoft_release_naming_policy)%(/LArSoftWiki/LArSoftInternals/LArSoft_release_naming_policy)%g' releases/*.md
  sed -i -e 's%(Move_to_v05)%(/LArSoftWiki/LArSoftInternals/Move_to_v05)%g' releases/*.md
  sed -i -e 's%(Data_products_architecture_and_design)%(/LArSoftWiki/Data_products_architecture_and_design)%g' LArSoftInternals/*.md
  sed -i -e 's%(Getting_new_code_into_a_LArSoft_release)%(/LArSoftWiki/Getting_new_code_into_a_LArSoft_release)%g' LArSoftInternals/*.md
  sed -i -e 's%(Installation_procedures)%(/LArSoftWiki/Installation_procedures)%g' LArSoftInternals/*.md
  sed -i -e 's%(LArSoft_git_Guidelines)%(/LArSoftWiki/LArSoft_git_Guidelines)%g' LArSoftInternals/*.md
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
wiki_dir=LArSoftWiki

get_laradmin_dir

create_working_directory 
run_git_clone
get_wiki_files
convert_files
move_files

exit 0
