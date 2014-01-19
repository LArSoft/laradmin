#!/bin/bash

# convert svn to get
# select only desired packages for each new git repository
# run convert.sh on cluck

# need to pick up some files from CalData

# RawData/uboone_datatypes belongs in uboonecode

usage()
{
   echo "USAGE: `basename ${0}` <working_dir> <author_list> <svn_repository>"
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
--exclude CalData/MicrobooneResponseFile \
--exclude CalData/CMakeLists.txt \
--exclude CalData/CalGausHFLBNE10kt_module.cc \
--exclude CalData/CalGausHFLBNE35t_module.cc \
--exclude CalData/CalWireAna_module.cc \
--exclude CalData/CalWireLBNE10kt_module.cc \
--exclude CalData/CalWireLBNE35t_module.cc \
--exclude CalData/CalWireT1034_module.cc \
--exclude CalData/CalWireT962_module.cc \
--exclude CalData/CalWire_module.cc \
--exclude CalData/DeconvGausHFLBNE10kt_module.cc \
--exclude CalData/DeconvGausHFLBNE35t_module.cc \
--exclude CalData/GNUmakefile \
--exclude CalData/caldata.fcl \
--exclude CalData/caldata_argoneut.fcl \
--exclude CalData/caldata_bo.fcl \
--exclude CalData/caldata_lariat.fcl \
--exclude CalData/caldata_lbne.fcl \
--exclude CalData/test/CMakeLists.txt \
--exclude CalData/test/FFTTest_module.cc \
--exclude CalData/test/GNUmakefile \
--exclude CalData/test/README \
--exclude CalData/test/ffttest.sh \
--exclude CalData/test/ffttest_argoneut.fcl \
--exclude CalData/test/simwire_argoneut.fcl \
--exclude Calorimetry \
--exclude ClusterFinder \
--exclude DetSim/MakeLists.txt \
--exclude DetSim/GNUmakefile \
--exclude DetSim/SimWireAna_module.cc \
--exclude DetSim/SimWireLBNE10kt_module.cc \
--exclude DetSim/SimWireLBNE35t_module.cc \
--exclude DetSim/SimWireT962_module.cc \
--exclude DetSim/SimWire_module.cc \
--exclude DetSim/WienerFilterAna_module.cc \
--exclude DetSim/detsimmodules.fcl \
--exclude DetSim/detsimmodules_argoneut.fcl \
--exclude DetSim/detsimmodules_bo.fcl \
--exclude DetSim/detsimmodules_lbne.fcl \
--exclude EventDisplay \
--exclude EventFinder \
--exclude EventGenerator/CMakeLists.txt \
--exclude EventGenerator/CRY \
--exclude EventGenerator/GNUmakefile \
--exclude EventGenerator/FileMuons_module.cc \
--exclude EventGenerator/LightSource_module.cc \
--exclude EventGenerator/NDKGen_module.cc \
--exclude EventGenerator/NUANCEGen_module.cc \
--exclude EventGenerator/SingleGen_module.cc \
--exclude EventGenerator/TextFileGen_module.cc \
--exclude EventGenerator/LightSourceSteering.txt \
--exclude EventGenerator/NuWro \
--exclude EventGenerator/csu40L_buildopticallibrary.fcl \
--exclude EventGenerator/csu40L_fastoptical.fcl \
--exclude EventGenerator/csu40L_fulloptical.fcl \
--exclude EventGenerator/filemuons.fcl \
--exclude EventGenerator/lar20jdjmuons.fcl \
--exclude EventGenerator/lightsource.fcl \
--exclude EventGenerator/nuance.fcl \
--exclude EventGenerator/nuance_argoneut.fcl \
--exclude EventGenerator/prodndkGolden.fcl \
--exclude EventGenerator/prodnuance.fcl \
--exclude EventGenerator/prodrandsingle.fcl \
--exclude EventGenerator/prodsingle.fcl \
--exclude EventGenerator/prodsingle_buildopticallibrary.fcl \
--exclude EventGenerator/prodsingle_fastoptical.fcl \
--exclude EventGenerator/prodsingle_fulloptical.fcl \
--exclude EventGenerator/prodsingle_jp250L.fcl \
--exclude EventGenerator/prodsingle_lariat.fcl \
--exclude EventGenerator/prodsingle_lbne35t.fcl \
--exclude EventGenerator/prodsingle_lbnefd.fcl \
--exclude EventGenerator/prodsingle_lbnefd_buildoplib.fcl \
--exclude EventGenerator/prodsingle_lbnefd_fastoptical.fcl \
--exclude EventGenerator/prodtext.fcl \
--exclude EventGenerator/prodtext_lbne35t.fcl \
--exclude EventGenerator/prodtext_lbnefd.fcl \
--exclude EventGenerator/singles.fcl \
--exclude EventGenerator/singles_argoneut.fcl \
--exclude EventGenerator/singles_lbne.fcl \
--exclude EventGenerator/textfilegen.fcl \
--exclude EventGenerator/GENIE/CMakeLists.txt \
--exclude EventGenerator/GENIE/GENIEGen_module.cc \
--exclude EventGenerator/GENIE/GNUmakefile \
--exclude EventGenerator/GENIE/genie.fcl \
--exclude EventGenerator/GENIE/genie_argoneut.fcl \
--exclude EventGenerator/GENIE/genie_lbne.fcl \
--exclude EventGenerator/GENIE/prodgenie.fcl \
--exclude EventGenerator/GENIE/prodgenie_lbne35t.fcl \
--exclude EventGenerator/GENIE/prodgenie_lbnefd.fcl \
--exclude Filters \
--exclude Genfit \
--exclude Geometry/AuxDetGeo.cxx \
--exclude Geometry/AuxDetGeo.h \
--exclude Geometry/ChannelMap35Alg.cxx \
--exclude Geometry/ChannelMap35Alg.h \
--exclude Geometry/ChannelMapAlg.cxx \
--exclude Geometry/ChannelMapAlg.h \
--exclude Geometry/ChannelMapAPAAlg.cxx \
--exclude Geometry/ChannelMapAPAAlg.h \
--exclude Geometry/ChannelMapStandardAlg.cxx \
--exclude Geometry/ChannelMapStandardAlg.h \
--exclude Geometry/CMakeLists.txt \
--exclude Geometry/CryostatGeo.cxx \
--exclude Geometry/CryostatGeo.h \
--exclude Geometry/ExptGeoHelperInterface.h \
--exclude Geometry/geo.h \
--exclude Geometry/geometry_argoneut.fcl \
--exclude Geometry/geometry_bo.fcl \
--exclude Geometry/geometry_csu40L.fcl \
--exclude Geometry/geometry.fcl \
--exclude Geometry/Geometry.h \
--exclude Geometry/geometry_icarus.fcl \
--exclude Geometry/geometry_jp250L.fcl \
--exclude Geometry/geometry_lariat.fcl \
--exclude Geometry/geometry_lbne.fcl \
--exclude Geometry/Geometry_service.cc \
--exclude Geometry/GeoObjectSorter35.cxx \
--exclude Geometry/GeoObjectSorter35.h \
--exclude Geometry/GeoObjectSorterAPA.cxx \
--exclude Geometry/GeoObjectSorterAPA.h \
--exclude Geometry/GeoObjectSorter.cxx \
--exclude Geometry/GeoObjectSorter.h \
--exclude Geometry/GeoObjectSorterStandard.cxx \
--exclude Geometry/GeoObjectSorterStandard.h \
--exclude Geometry/GNUmakefile \
--exclude Geometry/LBNEGeometryHelper.h \
--exclude Geometry/LBNEGeometryHelper_service.cc \
--exclude Geometry/OpDetGeo.cxx \
--exclude Geometry/OpDetGeo.h \
--exclude Geometry/PlaneGeo.cxx \
--exclude Geometry/PlaneGeo.h \
--exclude Geometry/StandardGeometryHelper.h \
--exclude Geometry/StandardGeometryHelper_service.cc \
--exclude Geometry/TPCGeo.cxx \
--exclude Geometry/TPCGeo.h \
--exclude Geometry/WireGeo.cxx \
--exclude Geometry/WireGeo.h \
--exclude Geometry/test \
--exclude Geometry/gdml/argoneut \
--exclude Geometry/gdml/bo \
--exclude Geometry/gdml/lbne \
--exclude Geometry/gdml/argoneut.gdml \
--exclude Geometry/gdml/argoneut-gdml-fragments.xml \
--exclude Geometry/gdml/argoneut_geo.C \
--exclude Geometry/gdml/bo.gdml \
--exclude Geometry/gdml/bo-gdml-fragments.xml \
--exclude Geometry/gdml/bo_geo.C \
--exclude Geometry/gdml/csu40l.gdml \
--exclude Geometry/gdml/generate_35t4apa.pl \
--exclude Geometry/gdml/generate_35t.pl \
--exclude Geometry/gdml/generate_APAoutside.pl \
--exclude Geometry/gdml/generate_gdml_simple.pl \
--exclude Geometry/gdml/generate_gdml_test.pl \
--exclude Geometry/gdml/generate_ICARUS.pl \
--exclude Geometry/gdml/generate_lar1_gdml.pl \
--exclude Geometry/gdml/generate_lbne10kT.pl \
--exclude Geometry/gdml/generate_lbne34kt.pl \
--exclude Geometry/gdml/generate_lbne_gdml.pl \
--exclude Geometry/gdml/generate_lbnend_gdml.pl \
--exclude Geometry/gdml/generate_voltpc.pl \
--exclude Geometry/gdml/genmake \
--exclude Geometry/gdml/global-defs.gdml \
--exclude Geometry/gdml/icarus.gdml \
--exclude Geometry/gdml/icarus_nowires.gdml \
--exclude Geometry/gdml/jp250L.gdml \
--exclude Geometry/gdml/lar1.gdml \
--exclude Geometry/gdml/lar1_geo.C \
--exclude Geometry/gdml/lariat.gdml \
--exclude Geometry/gdml/lariat_geo.C \
--exclude Geometry/gdml/lariat_geo_wdisk.C \
--exclude Geometry/gdml/lariat_wdisk.gdml \
--exclude Geometry/gdml/lbne10kt_20Paddles.gdml \
--exclude Geometry/gdml/lbne10kt36.gdml \
--exclude Geometry/gdml/lbne10kt36_nowires.gdml \
--exclude Geometry/gdml/lbne10kt_APAoutside.gdml \
--exclude Geometry/gdml/lbne10kt_APAoutside_nowires.gdml \
--exclude Geometry/gdml/lbne10kt.gdml \
--exclude Geometry/gdml/lbne10kt_nowires.gdml \
--exclude Geometry/gdml/lbne34kt.gdml \
--exclude Geometry/gdml/lbne34kt_nowires.gdml \
--exclude Geometry/gdml/lbne35t4apa.gdml \
--exclude Geometry/gdml/lbne35t4apa_nowires.gdml \
--exclude Geometry/gdml/lbne35t.gdml \
--exclude Geometry/gdml/lbne35t_nowires.gdml \
--exclude Geometry/gdml/lbne4apa36deg.gdml \
--exclude Geometry/gdml/lbne4apa36deg_nowires.gdml \
--exclude Geometry/gdml/lbne4apa45deg.gdml \
--exclude Geometry/gdml/lbne4apa45deg_nowires.gdml \
--exclude Geometry/gdml/lbnebulky.gdml \
--exclude Geometry/gdml/lbnebulky_geo.C \
--exclude Geometry/gdml/lbnebulky_onecryo.C \
--exclude Geometry/gdml/lbnebulky_onecryo.gdml \
--exclude Geometry/gdml/lbne.gdml \
--exclude Geometry/gdml/lbne-gdml-fragments.xml \
--exclude Geometry/gdml/lbne_geo.C \
--exclude Geometry/gdml/lbnend.gdml \
--exclude Geometry/gdml/lbnend_geo.C \
--exclude Geometry/gdml/longbo.gdml \
--exclude Geometry/gdml/make_gdml.pl \
--exclude Geometry/gdml/make_lbne_gdml.pl \
--exclude Geometry/gdml/materials.gdml \
--exclude Geometry/gdml/print_lbne_gdml.pl \
--exclude Geometry/gdml/README \
--exclude Geometry/gdml/voltpc.gdml \
--exclude Geometry/gdml/voltpc_geo.C \
--exclude HitFinder \
--exclude LArG4/atree.mac \
--exclude LArG4/AuxDetReadout.cxx \
--exclude LArG4/AuxDetReadoutGeometry.cxx \
--exclude LArG4/AuxDetReadoutGeometry.h \
--exclude LArG4/AuxDetReadout.h \
--exclude LArG4/CMakeLists.txt \
--exclude LArG4/ConfigurablePhysicsList.hh \
--exclude LArG4/ConfigurablePhysicsList.icc \
--exclude LArG4/CustomPhysicsBuiltIns.cxx \
--exclude LArG4/CustomPhysicsBuiltIns.hh \
--exclude LArG4/CustomPhysicsFactory.hh \
--exclude LArG4/CustomPhysicsTable.cxx \
--exclude LArG4/CustomPhysicsTable.hh \
--exclude LArG4/FastOpticalPhysics.cxx \
--exclude LArG4/FastOpticalPhysics.h \
--exclude LArG4/G4BadIdeaAction.cxx \
--exclude LArG4/G4BadIdeaAction.h \
--exclude LArG4/G4ThermalElectron.cxx \
--exclude LArG4/G4ThermalElectron.hh \
--exclude LArG4/GNUmakefile \
--exclude LArG4/IonizationAndScintillationAction.cxx \
--exclude LArG4/IonizationAndScintillationAction.h \
--exclude LArG4/IonizationAndScintillation.cxx \
--exclude LArG4/IonizationAndScintillation.h \
--exclude LArG4/ISCalculation.cxx \
--exclude LArG4/ISCalculation.h \
--exclude LArG4/ISCalculationNEST.cxx \
--exclude LArG4/ISCalculationNEST.h \
--exclude LArG4/ISCalculationSeparate.cxx \
--exclude LArG4/ISCalculationSeparate.h \
--exclude LArG4/LArG4Ana_module.cc \
--exclude LArG4/LArG4.mac \
--exclude LArG4/LArG4_module.cc \
--exclude LArG4/largeantmodules_argoneut.fcl \
--exclude LArG4/largeantmodules.fcl \
--exclude LArG4/largeantmodules_lbne.fcl \
--exclude LArG4/LArSimChannelAna_module.cc \
--exclude LArG4/LArStackingAction.cxx \
--exclude LArG4/LArStackingAction.h \
--exclude LArG4/LArVoxelReadout.cxx \
--exclude LArG4/LArVoxelReadoutGeometry.cxx \
--exclude LArG4/LArVoxelReadoutGeometry.h \
--exclude LArG4/LArVoxelReadout.h \
--exclude LArG4/MaterialPropertyLoader.cxx \
--exclude LArG4/MaterialPropertyLoader.h \
--exclude LArG4/MuNuclearSplittingProcess.cxx \
--exclude LArG4/MuNuclearSplittingProcess.h \
--exclude LArG4/MuNuclearSplittingProcessXSecBias.cxx \
--exclude LArG4/MuNuclearSplittingProcessXSecBias.h \
--exclude LArG4/NestAlg.cxx \
--exclude LArG4/NestAlg.h \
--exclude LArG4/OpBoundaryProcessSimple.cxx \
--exclude LArG4/OpBoundaryProcessSimple.hh \
--exclude LArG4/OpDetLookup.cxx \
--exclude LArG4/OpDetLookup.h \
--exclude LArG4/OpDetPhotonTable.cxx \
--exclude LArG4/OpDetPhotonTable.h \
--exclude LArG4/OpDetReadoutGeometry.cxx \
--exclude LArG4/OpDetReadoutGeometry.h \
--exclude LArG4/OpDetSensitiveDetector.cxx \
--exclude LArG4/OpDetSensitiveDetector.h \
--exclude LArG4/OpFastScintillation.cxx \
--exclude LArG4/OpFastScintillation.hh \
--exclude LArG4/OpParamAction.cxx \
--exclude LArG4/OpParamAction.h \
--exclude LArG4/OpParamSD.cxx \
--exclude LArG4/OpParamSD.h \
--exclude LArG4/OpticalPhysics.cxx \
--exclude LArG4/OpticalPhysics.hh \
--exclude LArG4/ParticleListAction.cxx \
--exclude LArG4/ParticleListAction.h \
--exclude LArG4/PhysicsList.cxx \
--exclude LArG4/PhysicsList.h \
--exclude LArG4/VisualizationAction.cxx \
--exclude LArG4/VisualizationAction.h \
--exclude LArPandoraAlgorithms \
--exclude LArPandoraInterface \
--exclude MCCheater \
--exclude Monitoring \
--exclude OpticalDetector \
--exclude OpticalDetectorData \
--exclude ParticleIdentification \
--exclude PhotonPropagation/CMakeLists.txt \
--exclude PhotonPropagation/GNUmakefile \
--exclude PhotonPropagation/LibraryBuildTools \
--exclude PhotonPropagation/LibraryData \
--exclude PhotonPropagation/PhotonLibraryAnalyzer_module.cc \
--exclude PhotonPropagation/PhotonLibrary.cxx \
--exclude PhotonPropagation/PhotonLibrary.h \
--exclude PhotonPropagation/PhotonVisibilityService.h \
--exclude PhotonPropagation/PhotonVisibilityService_service.cc \
--exclude PhotonPropagation/photpropmodules.fcl \
--exclude PhotonPropagation/photpropmodules_lbne.fcl \
--exclude PhotonPropagation/photpropservices.fcl \
--exclude PhotonPropagation/photpropservices_lbne.fcl \
--exclude PhotonPropagation/prodsingle_libraryana.fcl \
--exclude RawData/CMakeLists.txt \
--exclude RawData/GNUmakefile \
--exclude RawData/AuxDetDigit.cxx \
--exclude RawData/AuxDetDigit.h \
--exclude RawData/BeamInfo.cxx \
--exclude RawData/BeamInfo.h \
--exclude RawData/classes_def.xml \
--exclude RawData/classes.h \
--exclude RawData/DAQHeader.cxx \
--exclude RawData/DAQHeader.h \
--exclude RawData/ExternalTrigger.cxx \
--exclude RawData/ExternalTrigger.h \
--exclude RawData/OpDetPulse.cxx \
--exclude RawData/OpDetPulse.h \
--exclude RawData/raw.cxx \
--exclude RawData/RawDigit.cxx \
--exclude RawData/RawDigit.h \
--exclude RawData/raw.h \
--exclude RawData/utils/CMakeLists.txt \
--exclude RawData/utils/GNUmakefile \
--exclude RawData/utils/LArRawInputDriver.cxx \
--exclude RawData/utils/LArRawInputDriver.h \
--exclude RawData/utils/LArRawInputDriverJP250L.cxx \
--exclude RawData/utils/LArRawInputDriverJP250L.h \
--exclude RawData/utils/LArRawInputDriverLongBo.cxx \
--exclude RawData/utils/LArRawInputDriverLongBo.h \
--exclude RawData/utils/LArRawInputDriverShortBo.cxx \
--exclude RawData/utils/LArRawInputDriverShortBo.h \
--exclude RawData/utils/LArRawInputSourceJP250L_source.cc \
--exclude RawData/utils/LArRawInputSourceLB_source.cc \
--exclude RawData/utils/LArRawInputSourceSB_source.cc \
--exclude RawData/utils/LArRawInputSource_source.cc \
--exclude RawData/utils/rawtorootconvert.fcl \
--exclude RecoAlg \
--exclude RecoBase \
--exclude RecoObjects \
--exclude ShowerFinder \
--exclude SimpleTypesAndConstants \
--exclude Simulation/AuxDetSimChannel.cxx \
--exclude Simulation/AuxDetSimChannel.h \
--exclude Simulation/BeamGateInfo.h \
--exclude Simulation/classes_def.xml \
--exclude Simulation/classes.h \
--exclude Simulation/CMakeLists.txt \
--exclude Simulation/EmEveIdCalculator.cxx \
--exclude Simulation/EmEveIdCalculator.h \
--exclude Simulation/EveIdCalculator.cxx \
--exclude Simulation/EveIdCalculator.h \
--exclude Simulation/GNUmakefile \
--exclude Simulation/LArG4Parameters.h \
--exclude Simulation/LArG4Parameters_service.cc \
--exclude Simulation/LArVoxelCalculator.h \
--exclude Simulation/LArVoxelCalculator_service.cc \
--exclude Simulation/LArVoxelData.cxx \
--exclude Simulation/LArVoxelData.h \
--exclude Simulation/LArVoxelID.cxx \
--exclude Simulation/LArVoxelID.h \
--exclude Simulation/LArVoxelList.cxx \
--exclude Simulation/LArVoxelList.h \
--exclude Simulation/ParticleHistory.cxx \
--exclude Simulation/ParticleHistory.h \
--exclude Simulation/ParticleList.cxx \
--exclude Simulation/ParticleList.h \
--exclude Simulation/PhotonVoxels.cxx \
--exclude Simulation/PhotonVoxels.h \
--exclude Simulation/SimChannel.cxx \
--exclude Simulation/SimChannel.h \
--exclude Simulation/sim.h \
--exclude Simulation/SimListUtils.cxx \
--exclude Simulation/SimListUtils.h \
--exclude Simulation/SimPhotons.cxx \
--exclude Simulation/SimPhotons.h \
--exclude Simulation/simulationservices_argoneut.fcl \
--exclude Simulation/simulationservices_bo.fcl \
--exclude Simulation/simulationservices.fcl \
--exclude Simulation/simulationservices_jp250L.fcl \
--exclude Simulation/simulationservices_lbne.fcl \
--exclude SummaryData \
--exclude TrackFinder \
--exclude TriggerAlgo/CMakeLists.txt \
--exclude TriggerAlgo/GNUmakefile \
--exclude TriggerAlgo/example_trigger_sim.fcl \
--exclude TriggerAlgo/triggeralgo_service.fcl \
--exclude TriggerAlgo/TriggerAlgoBase.h \
--exclude TriggerAlgo/TriggerAlgoBase_service.cc \
--exclude TriggerAlgo/TriggerTypes.hh \
--exclude Utilities/AssociationUtil.h \
--exclude Utilities/bo_reco.fcl \
--exclude Utilities/CMakeLists.txt \
--exclude Utilities/databaseutil_argoneut.fcl \
--exclude Utilities/databaseutil_bo.fcl \
--exclude Utilities/databaseutil.fcl \
--exclude Utilities/DatabaseUtil.h \
--exclude Utilities/databaseutil_jp250L.fcl \
--exclude Utilities/databaseutil_lbne.fcl \
--exclude Utilities/DatabaseUtil_service.cc \
--exclude Utilities/detectorproperties_argoneut.fcl \
--exclude Utilities/detectorproperties_bo.fcl \
--exclude Utilities/detectorproperties.fcl \
--exclude Utilities/DetectorProperties.h \
--exclude Utilities/detectorproperties_jp250L.fcl \
--exclude Utilities/detectorproperties_lbne.fcl \
--exclude Utilities/DetectorProperties_service.cc \
--exclude Utilities/eventdump.fcl \
--exclude Utilities/FileCatalogMetadataExtras.h \
--exclude Utilities/FileCatalogMetadataExtras_service.cc \
--exclude Utilities/GeometryUtilities.cxx \
--exclude Utilities/GeometryUtilities.h \
--exclude Utilities/GNUmakefile \
--exclude Utilities/larfft_argoneut.fcl \
--exclude Utilities/larfft_bo.fcl \
--exclude Utilities/larfft.fcl \
--exclude Utilities/LArFFT.h \
--exclude Utilities/larfft_jp250L.fcl \
--exclude Utilities/larfft_lbne.fcl \
--exclude Utilities/LArFFT_service.cc \
--exclude Utilities/larproperties.fcl \
--exclude Utilities/LArProperties.h \
--exclude Utilities/LArProperties_service.cc \
--exclude Utilities/messageservice.fcl \
--exclude Utilities/SeedCreator.h \
--exclude Utilities/services_argoneut.fcl \
--exclude Utilities/services_bo.fcl \
--exclude Utilities/services.fcl \
--exclude Utilities/services_jp250L.fcl \
--exclude Utilities/services_lariat.fcl \
--exclude Utilities/services_lbne.fcl \
--exclude Utilities/signalservices.fcl \
--exclude Utilities/signalservices_lbne.fcl \
--exclude Utilities/SignalShaping.cxx \
--exclude Utilities/SignalShaping.h \
--exclude Utilities/SignalShapingServiceLBNE10kt.h \
--exclude Utilities/SignalShapingServiceLBNE10kt_service.cc \
--exclude Utilities/SignalShapingServiceLBNE34kt.h \
--exclude Utilities/SignalShapingServiceLBNE34kt_service.cc \
--exclude Utilities/SignalShapingServiceLBNE35t.h \
--exclude Utilities/SignalShapingServiceLBNE35t_service.cc \
--exclude Utilities/standard_reco_bo.fcl \
--exclude Utilities/standard_reco.fcl \
--exclude Utilities/standard_reco_jp250l.fcl \
--exclude Utilities/standard_reco_lbne35t.fcl \
--exclude Utilities/standard_reco_lbnefd.fcl \
--exclude Utilities/SumSecondFunction.h \
--exclude Utilities/VectorMap.h \
--exclude Utilities/test/CMakeLists.txt \
--exclude Utilities/test/GNUmakefile \
--exclude Utilities/test/LArPropTest_module.cc \
--exclude Utilities/test/lartest.fcl \
--exclude Utilities/test/lartest.sh \
--exclude Utilities/test/README \
--exclude Utilities/test/SignalShapingLBNE10ktTest_module.cc \
--exclude Utilities/test/SignalShapingLBNE35tTest_module.cc \
--exclude Utilities/test/sss.fcl \
--exclude Utilities/test/sss_lbne10kt.fcl \
--exclude Utilities/test/sss_lbne35t.fcl \
--exclude Utilities/test/sss.sh \
--exclude VertexFinder \
--exclude setup \
--exclude SRT_LAR \
 >& ../log.uboonecode.convert &

exit 0
