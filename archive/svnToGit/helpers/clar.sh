#!/bin/bash

g4list="LArG4/atree.mac
LArG4/AuxDetReadout.cxx
LArG4/AuxDetReadoutGeometry.cxx
LArG4/AuxDetReadoutGeometry.h
LArG4/AuxDetReadout.h
LArG4/CMakeLists.txt
LArG4/ConfigurablePhysicsList.hh
LArG4/ConfigurablePhysicsList.icc
LArG4/CustomPhysicsBuiltIns.cxx
LArG4/CustomPhysicsBuiltIns.hh
LArG4/CustomPhysicsFactory.hh
LArG4/CustomPhysicsTable.cxx
LArG4/CustomPhysicsTable.hh
LArG4/FastOpticalPhysics.cxx
LArG4/FastOpticalPhysics.h
LArG4/G4BadIdeaAction.cxx
LArG4/G4BadIdeaAction.h
LArG4/G4ThermalElectron.cxx
LArG4/G4ThermalElectron.hh
LArG4/GNUmakefile
LArG4/IonizationAndScintillationAction.cxx
LArG4/IonizationAndScintillationAction.h
LArG4/IonizationAndScintillation.cxx
LArG4/IonizationAndScintillation.h
LArG4/ISCalculation.cxx
LArG4/ISCalculation.h
LArG4/ISCalculationNEST.cxx
LArG4/ISCalculationNEST.h
LArG4/ISCalculationSeparate.cxx
LArG4/ISCalculationSeparate.h
LArG4/LArG4Ana_module.cc
LArG4/LArG4.mac
LArG4/LArG4_module.cc
LArG4/largeantmodules_argoneut.fcl
LArG4/largeantmodules.fcl
LArG4/largeantmodules_lbne.fcl
LArG4/largeantmodules_microboone.fcl
LArG4/LArSimChannelAna_module.cc
LArG4/LArStackingAction.cxx
LArG4/LArStackingAction.h
LArG4/LArVoxelReadout.cxx
LArG4/LArVoxelReadoutGeometry.cxx
LArG4/LArVoxelReadoutGeometry.h
LArG4/LArVoxelReadout.h
LArG4/MaterialPropertyLoader.cxx
LArG4/MaterialPropertyLoader.h
LArG4/MuNuclearSplittingProcess.cxx
LArG4/MuNuclearSplittingProcess.h
LArG4/MuNuclearSplittingProcessXSecBias.cxx
LArG4/MuNuclearSplittingProcessXSecBias.h
LArG4/NestAlg.cxx
LArG4/NestAlg.h
LArG4/OpBoundaryProcessSimple.cxx
LArG4/OpBoundaryProcessSimple.hh
LArG4/OpDetLookup.cxx
LArG4/OpDetLookup.h
LArG4/OpDetPhotonTable.cxx
LArG4/OpDetPhotonTable.h
LArG4/OpDetReadoutGeometry.cxx
LArG4/OpDetReadoutGeometry.h
LArG4/OpDetSensitiveDetector.cxx
LArG4/OpDetSensitiveDetector.h
LArG4/OpFastScintillation.cxx
LArG4/OpFastScintillation.hh
LArG4/OpParamAction.cxx
LArG4/OpParamAction.h
LArG4/OpParamSD.cxx
LArG4/OpParamSD.h
LArG4/OpticalPhysics.cxx
LArG4/OpticalPhysics.hh
LArG4/ParticleListAction.cxx
LArG4/ParticleListAction.h
LArG4/PhysicsList.cxx
LArG4/PhysicsList.h
LArG4/VisualizationAction.cxx
LArG4/VisualizationAction.h"


for file in ${g4list}
do
 echo "--exclude ${file} \\"
done
