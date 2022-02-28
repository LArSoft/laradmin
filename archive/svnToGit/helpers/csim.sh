#!/bin/bash

simlist="Simulation/AuxDetSimChannel.cxx
Simulation/AuxDetSimChannel.h
Simulation/BeamGateInfo.h
Simulation/classes_def.xml
Simulation/classes.h
Simulation/CMakeLists.txt
Simulation/EmEveIdCalculator.cxx
Simulation/EmEveIdCalculator.h
Simulation/EveIdCalculator.cxx
Simulation/EveIdCalculator.h
Simulation/GNUmakefile
Simulation/LArG4Parameters.h
Simulation/LArG4Parameters_service.cc
Simulation/LArVoxelCalculator.h
Simulation/LArVoxelCalculator_service.cc
Simulation/LArVoxelData.cxx
Simulation/LArVoxelData.h
Simulation/LArVoxelID.cxx
Simulation/LArVoxelID.h
Simulation/LArVoxelList.cxx
Simulation/LArVoxelList.h
Simulation/ParticleHistory.cxx
Simulation/ParticleHistory.h
Simulation/ParticleList.cxx
Simulation/ParticleList.h
Simulation/PhotonVoxels.cxx
Simulation/PhotonVoxels.h
Simulation/SimChannel.cxx
Simulation/SimChannel.h
Simulation/sim.h
Simulation/SimListUtils.cxx
Simulation/SimListUtils.h
Simulation/SimPhotons.cxx
Simulation/SimPhotons.h
Simulation/simulationservices_argoneut.fcl
Simulation/simulationservices_bo.fcl
Simulation/simulationservices.fcl
Simulation/simulationservices_jp250L.fcl
Simulation/simulationservices_lbne.fcl
Simulation/simulationservices_microboone.fcl"

for file in ${simlist}
do
 echo "--exclude ${file} \\"
done
