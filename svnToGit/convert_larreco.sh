#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck

# larevt/Filters/ShowerSelectorFilter_module.cc belongs in larreco/ShowerFinder


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
--exclude DetSim \
--exclude EventDisplay \
--exclude EventGenerator \
--exclude Filters/ADCFilter_module.cc  \
--exclude Filters/CMakeLists.txt  \
--exclude 'Filters/ChannelFilter.*'  \
--exclude Filters/EmptyFilter_module.cc  \
--exclude Filters/EventFilter_module.cc  \
--exclude Filters/FinalStateParticleFilter_module.cc  \
--exclude Filters/GNUmakefile  \
--exclude Filters/MuonFilter_module.cc  \
--exclude Filters/SmallClusterFilter_module.cc  \
--exclude 'Filters/*.fcl'  \
--exclude Geometry \
--exclude LArG4 \
--exclude LArPandoraAlgorithms \
--exclude LArPandoraInterface \
--exclude MCCheater \
--exclude Monitoring \
--exclude OpticalDetector \
--exclude OpticalDetectorData \
--exclude ParticleIdentification \
--exclude PhotonPropagation \
--exclude RawData \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TriggerAlgo \
--exclude Utilities \
 >& ../log.larreco.convert &

exit 0
