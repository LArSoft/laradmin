#!/usr/bin/env bash

# tag and create a new branch


# Determine this command name
thisComFull=$(basename $0)
##thisCom=${thisComFull%.*}
fullCom="${thisComFull%.*}"

# Usage function
function usage() {
    echo "Usage: $fullCom <tag>"
    echo
    echo "will create a branch named <tag>_branch"
    echo
    echo "FOR EXPERT USE ONLY"

}

# Determine command options (just -h for help)
while getopts ":h" OPTION
do
    case $OPTION in
        h   ) usage ; exit 0 ;;
        *   ) echo "ERROR: Unknown option" ; usage ; exit 1 ;;
    esac
done

# Capture the tag
tag=$1
if [ -z "${tag}" ]
then
    echo 'ERROR: no tag specified'
    usage
    exit 1
fi

if [ -z "${MRB_SOURCE}" ]
then
    echo 'ERROR: MRB_SOURCE must be defined'
    echo '       source the appropriate localProductsXXX/setup'
    exit 1
fi

if [ ! -r $MRB_SOURCE/CMakeLists.txt ]; then
    echo "$MRB_SOURCE/CMakeLists.txt not found"
    exit 1
fi

# find the directories
# ignore any directory that does not contain ups/product_deps
list=`ls $MRB_SOURCE -1`
for file in $list
do
   if [ -d $file ]
   then
     if [ -r $file/ups/product_deps ]
     then
       pkglist="$file $pkglist"
     fi
   fi
done

newbranch=${tag}_branch

# we presume that there is already a release/${tag} branch and that it is ready to merge with master
for REP in $pkglist
do
   cd ${MRB_SOURCE}/${REP}
   echo "begin ${REP}"
   ##rm -f ups/product_deps.bak
   git co master  || exit 1
   git merge -m"larsoft ${tag}" release/${tag}   || exit 1
   git tag -a -m"larsoft ${tag}" ${tag}  || exit 1
   git push origin master  || exit 1
   git push --tags  || exit 1
   git co -b ${newbranch}  || exit 1
   git push -u origin ${newbranch}  || exit 1
done

exit 0
