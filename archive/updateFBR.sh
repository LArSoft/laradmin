#!/bin/bash
source /cvmfs/larsoft.opensciencegrid.org/products/setup
setup git
source ~/.bashrc
sshagent_init

graftit () {
    export GIT_AUTHOR_NAME='Scisoft Team'
    export GIT_AUTHOR_EMAIL='scisoft-team@listserv.fnal.gov'
    export GIT_AUTHOR_DATE="Thu, 01 Jan 1970 00:00:00 +0000"
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
    export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE
    export COMMIT_TITLE="Truncating history at commit $1" 
    GRAFTBASE=$(echo $COMMIT_TITLE |  git commit-tree $1^{tree})
    git --git-dir=$PWD replace --graft $1 $GRAFTBASE 
    git --git-dir=$PWD filter-branch -f --tag-name-filter cat -- --all  
} 

checkoutbranches_cleantags() {
#  for br in $(git  --git-dir=$PWD branch -a | tr '\*' ' ' | grep -v '/master' | grep -v '/develop'| grep -v '/v'|grep origin | sed 's!  remotes/origin/!!g');do
#      git --git-dir=$PWD branch -D $br
#  done
  for tag in $(git  --git-dir=$PWD tag -l | grep -v -e '^v' | grep -v -e '^LARSOFT');do
      git --git-dir=$PWD tag -d $tag
  done
  #git checkout -b develop origin/develop
  #git checkout -b master origin/master
  #for br in $(git branch -a | grep origin |sed 's!  remotes/origin/!!g'| grep -e '^v.*_br' | grep -v '_rc'| grep -v '_art');do
  #    git checkout -b $br origin/$br
  #done
  #git checkout develop
  #git remote rm origin
}

filterit () {
  case $1 in
    larana)
      # redmine parent
      PARENT=f14952234f7e42fee338ef003b5ace8c9b93f2a8
      graftit $PARENT
      ;;
    larcore)
      # redmine parent
      PARENT=112fb9a3f466fe835a304eb74c2440fc87f03d64
      graftit $PARENT
      ;;
    lardata)
      # redmine parent
      PARENT=8874cd14ca56e620be090e4b34468b6052d1e5e3
      graftit $PARENT
      ;;
    larevt)
      # redmine parent
      PARENT=4a9cbe630ca43151c3a1e3097e1802efbc03dd5d
      graftit $PARENT 
      ;;
    lareventdisplay)
      # redmine parent
      PARENT=f0fb83f0ab0922522f4af5dd8383e9c694dd3817
      graftit $PARENT 
      ;;
    larexamples)
      # redmine parent
      PARENT=caae4c6c649753832de0d3e5fa396f6f600e4c7a
      graftit $PARENT
      ;;
    larpandora)
      # redmine parent
      PARENT=68840d9292d5bd15a728e987b7aa678befd80661
      graftit $PARENT
      ;;
    larreco)
      # redmine parent
      PARENT=9de1fb03f1445b90e9db65d266d3e58ed6527d18
      graftit $PARENT
      ;;
    larsim)
      git  --git-dir=$PWD filter-branch -f --index-filter 'git rm --cached --ignore-unmatch *.root *.log' --tag-name-filter cat -- --all
      # redmine parent
      PARENT=0558fe7a5d9e05ad19d4e4875ad5ab6a6ab56b12
      graftit $PARENT
      ;;
    larsoft)
      # redmine parent
      PARENT=961edb6c5b2485e13aea9f367d1b2e745bb20315
      graftit $PARENT
      ;;
    larcorealg)
      git  --git-dir=$PWD tag -d v00_01_00a
      # redmine parent
      PARENT=112fb9a3f466fe835a304eb74c2440fc87f03d64
      PARENT2=bf44f9c88eb2cc2551e1418781d0dbb4df44539c
      graftit $PARENT
      graftit $PARENT2
      ;;
    lardataobj)
      git  --git-dir=$PWD filter-branch -f --index-filter 'git rm --cached --ignore-unmatch *.root *.log' --tag-name-filter cat -- --all
      ;;
    lar*)
      # Don't truncate history of the remaining lar* repos
      PARENT=""
      ;; 
  esac
}

dirs="larana larcore larcorealg larcoreobj lardata lardataalg lardataobj larevt lareventdisplay larexamples larg4 larpandora larsoft larsoftobj larwirecell larreco larsim"
#dirs="larana lareventdisplay larpandora larreco"

mkdir -p fbr

for dir in $dirs;do
  if [ ! -d ${dir}.git ];then
    git clone --mirror ssh://p-${dir}@cdcvs.fnal.gov/cvs/projects/${dir}
  fi
  pushd ${dir}.git;
  git remote update --prune;
  git branch --merged | grep -v master | grep -v develop
  popd;
  rm -rf fbr/${dir} fbr/${dir}.git
  #git clone ${dir}.git -b develop fbr/$dir;
  cp -rp ${dir}.git fbr/${dir}.git
  pushd fbr/${dir}.git
  checkoutbranches_cleantags
  git  --git-dir=$PWD reflog expire --expire=now --all
  #git gc --prune=now --aggressive;
  #du -sh .

  filterit $dir 

  #git reflog expire --expire=now --all
  #git gc --prune=now --aggressive;
  #du -sh .

  #gitk --all 
 
  export gh=git@github.com:LArSoft/${dir}.git;
  git remote add gh $gh
  git fetch gh
  git push gh --force master develop
  for br in $(git branch | tr '\*' ' '| grep -e '^  v');do
     git push gh --force $br
  done
#  for br in $(git branch | tr '\*' ' ' | grep feature);do
#     git push gh $br
#  done
  git --git-dir=$PWD push gh --force --tags
  popd
done

