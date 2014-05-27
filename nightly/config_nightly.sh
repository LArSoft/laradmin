#!/bin/bash

# set configuration variables for nightly scripts
# to be sourced from the other scripts
# expect the project name as a parameter

BASESCRIPT="$(basename $0)"

# The default is to checkout an existing nightly tag.
# only the official larsoft nightly update should use the -t (tag) option
NIGHTLYDEVELOPMODE=
FORCE=
case "$1" in
  -d)
    NIGHTLYDEVELOPMODE=true
    shift
    ;;
  -f)
    FORCE=true
    shift
    ;;
  -t)
    NIGHTLYTAG=true
    shift
    ;;
  -*)
    echo "$BASESCRIPT: unrecognized option $1" >&2
    usage
    exit 1
    ;;
esac

PROJECT="$1"

# MACHINES and OSES have to be corresponding and in the same order
# these lines are for the standard nightly build
# edit them for your own build
declare -a MACHINES="(uboonegpvm01 uboonegpvm04)"
declare -a OSES="(slf5 slf6)"
# if you just want to build on a single machine, the machine name should be "no_ssh"
#declare -a MACHINES="(no_ssh)"
#declare -a OSES="(slf6)"

# edit NIGHTLY_DIR and PROJ_PRODUCTS for your machine(s)
LARSOFT_SCRIPTS="$(cd $(dirname $0);pwd)"
NIGHTLY_DIR="$(dirname $(dirname $LARSOFT_SCRIPTS))/${PROJECT}_nightly_build"
PROJ_PRODUCTS="/grid/fermiapp/products/$PROJECT"
SETUPS="$PROJ_PRODUCTS/setup"
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
    PROJ_PRODUCTS="/grid/fermiapp/$PROJECT/products"
    SETUPS="/grid/fermiapp/$PROJECT/setup_${PROJECT}.sh"
    if [ $PROJECT = lbne ]
    then
      MACHINES[0]="lbnegpvm01"
      MACHINES[1]="lbnesl6test"
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

if [ -n "$NIGHTLYDEVELOPMODE" ]
then
  PROJ_PRODUCTS="$(dirname $NIGHTLY_DIR)/products/$PROJECT"
fi
