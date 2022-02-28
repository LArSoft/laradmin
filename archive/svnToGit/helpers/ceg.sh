#!/bin/bash

eglist="EventGenerator/CMakeLists.txt
EventGenerator/csu40L_buildopticallibrary.fcl
EventGenerator/csu40L_fastoptical.fcl
EventGenerator/csu40L_fulloptical.fcl
EventGenerator/filemuons.fcl
EventGenerator/FileMuons_module.cc
EventGenerator/GNUmakefile
EventGenerator/lar20jdjmuons.fcl
EventGenerator/lightsource.fcl
EventGenerator/lightsource_microboone.fcl
EventGenerator/LightSource_module.cc
EventGenerator/LightSourceSteering.txt
EventGenerator/NDKGen_module.cc
EventGenerator/nuance_argoneut.fcl
EventGenerator/nuance.fcl
EventGenerator/NUANCEGen_module.cc
EventGenerator/prodndkGolden.fcl
EventGenerator/prodnuance.fcl
EventGenerator/prodrandsingle.fcl
EventGenerator/prodsingle_buildopticallibrary.fcl
EventGenerator/prodsingle_fastoptical.fcl
EventGenerator/prodsingle.fcl
EventGenerator/prodsingle_fulloptical.fcl
EventGenerator/prodsingle_jp250L.fcl
EventGenerator/prodsingle_lariat.fcl
EventGenerator/prodsingle_lbne35t.fcl
EventGenerator/prodsingle_lbnefd_buildoplib.fcl
EventGenerator/prodsingle_lbnefd_fastoptical.fcl
EventGenerator/prodsingle_lbnefd.fcl
EventGenerator/prodsingleNEST_uboone.fcl
EventGenerator/prodsingle_uboone_comp.fcl
EventGenerator/prodsingle_uboone.fcl
EventGenerator/prodtext.fcl
EventGenerator/prodtext_lbne35t.fcl
EventGenerator/prodtext_lbnefd.fcl
EventGenerator/SingleGen_module.cc
EventGenerator/singles_argoneut.fcl
EventGenerator/singles.fcl
EventGenerator/singles_lbne.fcl
EventGenerator/singles_microboone.fcl
EventGenerator/textfilegen.fcl
EventGenerator/TextFileGen_module.cc"


for file in ${eglist}
do
 echo "--exclude ${file} \\"
done

crylist="EventGenerator/CRY/CMakeLists.txt
EventGenerator/CRY/CosmicsGen_module.cc
EventGenerator/CRY/cry.fcl
EventGenerator/CRY/GNUmakefile
EventGenerator/CRY/prodcosmics.fcl
EventGenerator/CRY/prodcosmics_lbne35t.fcl
EventGenerator/CRY/prodcosmics_lbnefd.fcl"

for file in ${crylist}
do
 echo "--exclude ${file} \\"
done

glist="EventGenerator/GENIE/CMakeLists.txt
EventGenerator/GENIE/genie_argoneut.fcl
EventGenerator/GENIE/genie.fcl
EventGenerator/GENIE/GENIEGen_module.cc
EventGenerator/GENIE/genie_lbne.fcl
EventGenerator/GENIE/genie_microboone.fcl
EventGenerator/GENIE/GNUmakefile
EventGenerator/GENIE/prodgenie.fcl
EventGenerator/GENIE/prodgenie_lbne35t.fcl
EventGenerator/GENIE/prodgenie_lbnefd.fcl"

for file in ${glist}
do
 echo "--exclude ${file} \\"
done
