#!/bin/bash

ulist="Utilities/AssociationUtil.h
Utilities/bo_reco.fcl
Utilities/CMakeLists.txt
Utilities/databaseutil_argoneut.fcl
Utilities/databaseutil_bo.fcl
Utilities/databaseutil.fcl
Utilities/DatabaseUtil.h
Utilities/databaseutil_jp250L.fcl
Utilities/databaseutil_lbne.fcl
Utilities/databaseutil_microboone.fcl
Utilities/DatabaseUtil_service.cc
Utilities/detectorproperties_argoneut.fcl
Utilities/detectorproperties_bo.fcl
Utilities/detectorproperties.fcl
Utilities/DetectorProperties.h
Utilities/detectorproperties_jp250L.fcl
Utilities/detectorproperties_lbne.fcl
Utilities/detectorproperties_microboone.fcl
Utilities/DetectorProperties_service.cc
Utilities/eventdump.fcl
Utilities/FileCatalogMetadataExtras.h
Utilities/FileCatalogMetadataExtras_service.cc
Utilities/GeometryUtilities.cxx
Utilities/GeometryUtilities.h
Utilities/GNUmakefile
Utilities/larfft_argoneut.fcl
Utilities/larfft_bo.fcl
Utilities/larfft.fcl
Utilities/LArFFT.h
Utilities/larfft_jp250L.fcl
Utilities/larfft_lbne.fcl
Utilities/larfft_microboone.fcl
Utilities/LArFFT_service.cc
Utilities/larproperties.fcl
Utilities/LArProperties.h
Utilities/LArProperties_service.cc
Utilities/messageservice.fcl
Utilities/optical_reco_uboone.fcl
Utilities/sam_microboone.fcl
Utilities/SeedCreator.h
Utilities/services_argoneut.fcl
Utilities/services_bo.fcl
Utilities/services.fcl
Utilities/services_jp250L.fcl
Utilities/services_lariat.fcl
Utilities/services_lbne.fcl
Utilities/services_microboone.fcl
Utilities/signalservices.fcl
Utilities/signalservices_lbne.fcl
Utilities/signalservices_microboone.fcl
Utilities/SignalShaping.cxx
Utilities/SignalShaping.h
Utilities/SignalShapingServiceLBNE10kt.h
Utilities/SignalShapingServiceLBNE10kt_service.cc
Utilities/SignalShapingServiceLBNE34kt.h
Utilities/SignalShapingServiceLBNE34kt_service.cc
Utilities/SignalShapingServiceLBNE35t.h
Utilities/SignalShapingServiceLBNE35t_service.cc
Utilities/SignalShapingServiceMicroBooNE.h
Utilities/SignalShapingServiceMicroBooNE_service.cc
Utilities/standard_reco_bo.fcl
Utilities/standard_reco.fcl
Utilities/standard_reco_jp250l.fcl
Utilities/standard_reco_lbne35t.fcl
Utilities/standard_reco_lbnefd.fcl
Utilities/standard_reco_uboone.fcl
Utilities/SumSecondFunction.h
Utilities/VectorMap.h"

for file in ${ulist}
do
 echo "--exclude ${file} \\"
done

utest="Utilities/test/CMakeLists.txt
Utilities/test/GNUmakefile
Utilities/test/LArPropTest_module.cc
Utilities/test/lartest.fcl
Utilities/test/lartest.sh
Utilities/test/README
Utilities/test/SignalShapingLBNE10ktTest_module.cc
Utilities/test/SignalShapingLBNE35tTest_module.cc
Utilities/test/SignalShapingMicroBooNETest_module.cc
Utilities/test/sss.fcl
Utilities/test/sss_lbne10kt.fcl
Utilities/test/sss_lbne35t.fcl"

for file in ${utest}
do
 echo "--exclude ${file} \\"
done


exit 0

