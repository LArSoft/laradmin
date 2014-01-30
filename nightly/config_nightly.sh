#!/bin/bash

# set configuration variables for nightly scripts
# to be sourced from the other scripts
# expect the project name as a parameter

BASESCRIPT="$(basename $0)"
PROJECT="$1"

# MACHINES and OSES have to be corresponding and in the same order
declare -a MACHINES="(uboonegpvm01 uboonegpvm04)"
declare -a OSES="(slf5 slf6)"

LARSOFT_SCRIPTS="$(cd $(dirname $0);pwd)"
NIGHTLY_DIR="$(dirname $(dirname $LARSOFT_SCRIPTS))/${PROJECT}_nightly_build"
PROJ_PRODUCTS="/grid/fermiapp/products/$PROJECT"
SETUPS="$PROJ_PRODUCTS/setups"
#PROJ_PRODUCTS="$(dirname $NIGHTLY_DIR)/products/$PROJECT"  # for development test

case "$PROJECT" in
  "")
    usage
    exit 1
    ;;
  larsoft)
    PKGLIST="larana lardata larevt larpandora larsim larcore lareventdisplay larexamples larreco larsoft"
    ;;
  uboone|lbne)
    PKGLIST="${PROJECT}code"
    PROJ_PRODUCTS="/grid/fermiapp/$PROJECT/software/products/${PROJECT}code"
    SETUPS="/grid/fermiapp/$PROJECT/software/setup_${PROJECT}.sh"
    if [ $PROJECT = lbne ]
    then
    	MACHINES[0]="lbnegpvm01"
    fi
    ;;
  *)
    echo "$BASESCRIPT: unrecognized project $PROJECT" >&2
    echo "Expect larsoft, uboone, or lbne" >&2
    exit 1
    ;;
esac

TODAY="`date +%Y-%m-%d`"

source $SETUPS || exit 1
setup git || exit 1
setup gitflow || exit 1
setup mrb || exit 1
export MRB_PROJECT=$PROJECT
