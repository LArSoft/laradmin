#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck

# exclude LibraryData subdiretory 
# PhotonPropagation/LibraryData/ contains root data files which are now part of larsoft_data

usage()
{
   echo "USAGE: `basename ${0}` <working_dir>"
}

working_dir=${1}
author_list=${2}
larsoft_svn=${3}

if [ -z ${working_dir} ]
then
   echo "ERROR: please specify the working directory"
   usage
   exit 1
fi
if [ -z ${author_list} ]
then
   echo "ERROR: please specify the author list"
   usage
   exit 1
fi
if [ -z ${larsoft_svn} ]
then
   echo "ERROR: please specify the svn repository"
   usage
   exit 1
fi

if [ ! -d ${working_dir} ]
then
  echo "ERROR: ${working_dir} does not exist"
  exit 1
fi

source /products/setups || { echo "ERROR: setup of ups failed"; exit 1; }
setup git || { echo "ERROR: setup of git failed"; exit 1; }

cd ${working_dir}

svn2git ${larsoft_svn} --authors ${author_list} --verbose \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude EventDisplay \
--exclude EventFinder \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
--exclude LArPandoraAlgorithms \
--exclude LArPandoraInterface \
--exclude Monitoring \
--exclude OpticalDetector \
--exclude OpticalDetectorData \
--exclude ParticleIdentification \
--exclude RawData \
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude Utilities \
--exclude VertexFinder \
--exclude PhotonPropagation/LibraryData \
 >& ../log.larsim.convert &

exit 0