#!/bin/bash

module_list="AnalysisAlg
AnalysisBase
AnalysisExample
CalData
Calorimetry
ClusterFinder
DetSim
EventDisplay
EventFinder
EventGenerator
Filters
Genfit
Geometry
HitFinder
LArG4
LArPandoraAlgorithms
LArPandoraInterface
MCCheater
Monitoring
OpticalDetector
OpticalDetectorData
ParticleIdentification
PhotonPropagation
RawData
RecoAlg
RecoBase
RecoObjects
setup
ShowerFinder
SimpleTypesAndConstants
Simulation
SRT_LAR
SummaryData
TrackFinder
TriggerAlgo
Utilities
VertexFinder"

larsoft_svn=http://cdcvs.fnal.gov/subversion/larsoftsvn
for module in ${module_list}
do
echo "checking ${module}"
svn log --quiet http://cdcvs.fnal.gov/subversion/larsoftsvn/trunk/${module} | grep -E "r[0-9]+ \| .+ \|" | awk '{print $3}' | sort | uniq > ${module}.authors
done

exit 0


