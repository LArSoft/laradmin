use strict;

use vars qw(%dir_list);
BEGIN { %dir_list = (
                        "CoreUtils" => "larcore_CoreUtils",
                        "Geometry" => "larcore_Geometry",
                        "SimpleTypesAndConstants" => "larcore_SimpleTypesAndConstants",
                        "SummaryData" => "larcore_SummaryData",
                        "AnalysisAlg" => "lardata_AnalysisAlg",
                        "AnalysisBase" => "lardata_AnalysisBase",
                        "DetectorInfo" => "lardata_DetectorInfo",
                        "DetectorInfoServices" => "lardata_DetectorInfoServices",
                        "MCBase" => "lardata_MCBase",
                        "OpticalDetectorData" => "lardata_OpticalDetectorData",
                        "RawData" => "lardata_RawData",
                        "RecoBase" => "lardata_RecoBase",
                        "RecoBase_dict" => "lardata_RecoBase_dict",
                        "RecoBaseArt" => "lardata_RecoBaseArt",
                        "RecoObjects" => "lardata_RecoObjects",
                        "Utilities" => "lardata_Utilities",
                        "ComputePi_module" => "lardata_Utilities_ComputePi_module",
                        "DatabaseUtil_service" => "lardata_Utilities_DatabaseUtil_service",
                        "FileCatalogMetadataExtras_service" => "lardata_Utilities_FileCatalogMetadataExtras_service",
                        "Utilities_LArFFT_service" => "lardata_Utilities_Utilities_LArFFT_service",
                        "MemoryPeakReporter_service" => "lardata_Utilities_MemoryPeakReporter_service",
                        "CalData" => "larevt_CalData",
                        "CalibrationDBI" => "larevt_CalibrationDBI",
                        "Filters" => "larevt_Filters",
                        "SpaceCharge" => "larevt_SpaceCharge",
                        "DetSim" => "larsim_DetSim",
                        "EventGenerator" => "larsim_EventGenerator",
                        "LArG4" => "larsim_LArG4",
                        "MCCheater" => "larsim_MCCheater",
                        "MCSTReco" => "larsim_MCSTReco",
                        "PhotonPropagation" => "larsim_PhotonPropagation",
                        "SimFilters" => "larsim_SimFilters",
                        "GeneratedEventTimestamp" => "larsim_GeneratedEventTimestamp",
                        "TriggerAlgo" => "larsim_TriggerAlgo",
                        "EventDisplay" => "lareventdisplay_EventDisplay",
                        "AnalysisExample" => "larexamples_AnalysisExample",
                        "ClusterFinder" => "larreco_ClusterFinder",
                        "DirOfGamma" => "larreco_DirOfGamma",
                        "EventFinder" => "larreco_EventFinder",
                        "Genfit" => "larreco_Genfit",
                        "HitFinder" => "larreco_HitFinder",
                        "MCComp" => "larreco_MCComp",
                        "RecoAlg" => "larreco_RecoAlg",
                        "ShowerFinder" => "larreco_ShowerFinder",
                        "SpacePointFinder" => "larreco_SpacePointFinder",
                        "TrackFinder" => "larreco_TrackFinder",
                        "VertexFinder" => "larreco_VertexFinder",
                        "WireCell" => "larreco_WireCell",
                        "LArPandoraInterface" => "larpandora_LArPandoraInterface",
                        "Calorimetry" => "larana_Calorimetry",
                        "CosmicRemoval" => "larana_CosmicRemoval",
                        "OpticalDetector" => "larana_OpticalDetector",
                        "ParticleIdentification" => "larana_ParticleIdentification",
                        "T0Finder" => "larana_T0Finder"
		       ); }
use vars qw(%plugin_list);
BEGIN { %plugin_list = (
                        "EventGenerator" => "larsim_EventGenerator",
                        "LArG4Parameters_service" => "larsim_Simulation_LArG4Parameters_service",
                        "LArVoxelCalculator_service" => "larsim_Simulation_LArVoxelCalculator_service",
                        "TriggerAlgoBase_service" => "larsim_TriggerAlgo_TriggerAlgoBase_service",
                        "GeneratedEventTimestamp_plugin" => "larsim_EventGenerator_GeneratedEventTimestamp_plugin"
		       ); }

foreach my $lib (sort keys %plugin_list) {
  s&^(\s*\.+\s+)\Q$lib\E(.*)&${1}$plugin_list{$lib}${2}& and last;
}
