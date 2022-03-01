#!/bin/bash

#create empty repository 
set -x
git clone ssh://p-laradmin@cdcvs.fnal.gov/cvs/projects/laradmin 
cd laradmin
git remote add gh git@github.com:LArSoft/laradmin.git
git checkout develop
git push -u  gh develop && git remote set-head -a gh 
git checkout master
git branch -M master main 
git push -u gh main:main
git push --tags gh
set +x

exit 0

