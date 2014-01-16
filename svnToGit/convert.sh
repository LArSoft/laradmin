#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck

#Need to move
#Filters/ShowerSelectorFilter_module.cc -> ShowerFinder/ShowerSelectorFilter_module.cc1.

# Monitoring will be retired - create larobsolete for this
# make sure .root files are excluded
# use verbose on all

source /products/setup
setup git

working_dir=/home/garren/larsoft/2013.11.25
author_list=/home/garren/larsoft/convert/larsoft.git.author.list
larsoft_svn=http://cdcvs.fnal.gov/subversion/larsoftsvn
lardir=${working_dir}/larg-take2
larsoft_dir_list="larcore larexamples lardata larevt larsim larreco larana larpandora lareventdisplay larsoft"

if [ -d ${lardir} ]
then
  echo "ERROR: ${lardir} already exists - we need to create an empty directory"
  exit 1
fi


for dir in ${larsoft_dir_list}
do
  fulldir=${lardir}/${dir}
  echo "making ${fulldir}"
  mkdir -p ${fulldir} || ( echo "failed to create ${fulldir}"; exit 1; )
done

cd ${lardir}/larcore
echo "_____________________________________________________________________"
echo "make larcore"
svn2git ${larsoft_svn} --authors ${author_list} --verbose \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Genfit \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude Simulation \
--exclude SRT_LAR \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larcore.convert &

cd ${lardir}/lardata
echo "_____________________________________________________________________"
echo "make lardata"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
--exclude LArG4 \
--exclude LArPandoraAlgorithms \
--exclude LArPandoraInterface \
--exclude MCCheater \
--exclude 'OpticalDetector\b' \
--exclude ParticleIdentification \
--exclude PhotonPropagation \
--exclude RecoAlg \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude VertexFinder \
 >& ${lardir}/log.lardata.convert &

cd ${lardir}/larevt
echo "_____________________________________________________________________"
echo "make larevt"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larevt.convert &

cd ${lardir}/larsim
echo "_____________________________________________________________________"
echo "make larsim"
svn2git ${larsoft_svn} --authors ${author_list} \
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
 >& ${lardir}/log.larsim.convert &

cd ${lardir}/larreco
echo "_____________________________________________________________________"
echo "make larreco"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventGenerator \
--exclude Filters \
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
 >& ${lardir}/log.larreco.convert &

cd ${lardir}/larana
echo "_____________________________________________________________________"
echo "make larana"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
--exclude LArG4 \
--exclude LArPandoraAlgorithms \
--exclude LArPandoraInterface \
--exclude MCCheater \
--exclude Monitoring \
--exclude OpticalDetectorData \
--exclude PhotonPropagation \
--exclude RawData \
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larana.convert &

cd ${lardir}/lareventdisplay
echo "_____________________________________________________________________"
echo "make lareventdisplay"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.lareventdisplay.convert &

cd ${lardir}/larexamples
echo "_____________________________________________________________________"
echo "make larexamples"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larexamples.convert &

cd ${lardir}/larpandora
echo "_____________________________________________________________________"
echo "make larpandora"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
--exclude LArG4 \
--exclude MCCheater \
--exclude Monitoring \
--exclude OpticalDetector \
--exclude OpticalDetectorData \
--exclude ParticleIdentification \
--exclude PhotonPropagation \
--exclude RawData \
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larpandora.convert &

cd ${lardir}/larsoft
echo "_____________________________________________________________________"
echo "make larsoft"
svn2git ${larsoft_svn} --authors ${author_list} \
--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Geometry \
--exclude Genfit \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \
 >& ${lardir}/log.larsoft.convert &

echo 
echo "svn2git is running in the background"
echo 


exit 0

# list of svn packages

--exclude AnalysisAlg \
--exclude AnalysisBase \
--exclude AnalysisExample \
--exclude CalData \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator \
--exclude Filters \
--exclude Genfit \
--exclude Geometry \
--exclude HitFinder \
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
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude setup \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation \
--exclude SRT_LAR \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo \
--exclude Utilities \
--exclude VertexFinder \


