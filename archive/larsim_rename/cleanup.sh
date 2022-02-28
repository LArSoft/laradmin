#!/bin/bash

thisdir=`pwd`
shortdir=$(basename ${thisdir})

echo "working in ${thisdir} ${shortdir}"

if [[ ${shortdir} != larsim ]]; then
  echo "ERROR: this script is only for use within larsim"
  exit 1
fi

git status

git filter-branch --index-filter 'git rm --cached --ignore-unmatch *.root *.log' HEAD
git repack -A
git gc --aggressive

git status

exit 0

