#!/bin/bash

glist="Geometry/AuxDetGeo.cxx
Geometry/AuxDetGeo.h
Geometry/ChannelMap35Alg.cxx
Geometry/ChannelMap35Alg.h
Geometry/ChannelMapAlg.cxx
Geometry/ChannelMapAlg.h
Geometry/ChannelMapAPAAlg.cxx
Geometry/ChannelMapAPAAlg.h
Geometry/ChannelMapStandardAlg.cxx
Geometry/ChannelMapStandardAlg.h
Geometry/CMakeLists.txt
Geometry/CryostatGeo.cxx
Geometry/CryostatGeo.h
Geometry/ExptGeoHelperInterface.h
Geometry/geo.h
Geometry/geometry_argoneut.fcl
Geometry/geometry_bo.fcl
Geometry/geometry_csu40L.fcl
Geometry/geometry.fcl
Geometry/Geometry.h
Geometry/geometry_icarus.fcl
Geometry/geometry_jp250L.fcl
Geometry/geometry_lariat.fcl
Geometry/geometry_lbne.fcl
Geometry/geometry_microboone.fcl
Geometry/Geometry_service.cc
Geometry/GeoObjectSorter35.cxx
Geometry/GeoObjectSorter35.h
Geometry/GeoObjectSorterAPA.cxx
Geometry/GeoObjectSorterAPA.h
Geometry/GeoObjectSorter.cxx
Geometry/GeoObjectSorter.h
Geometry/GeoObjectSorterStandard.cxx
Geometry/GeoObjectSorterStandard.h
Geometry/GNUmakefile
Geometry/LBNEGeometryHelper.h
Geometry/LBNEGeometryHelper_service.cc
Geometry/OpDetGeo.cxx
Geometry/OpDetGeo.h
Geometry/PlaneGeo.cxx
Geometry/PlaneGeo.h
Geometry/StandardGeometryHelper.h
Geometry/StandardGeometryHelper_service.cc
Geometry/TPCGeo.cxx
Geometry/TPCGeo.h
Geometry/WireGeo.cxx
Geometry/WireGeo.h"


for file in ${glist}
do
 echo "--exclude ${file} \\"
done

gdmlist="Geometry/gdml/argoneut.gdml
Geometry/gdml/argoneut-gdml-fragments.xml
Geometry/gdml/argoneut_geo.C
Geometry/gdml/bo.gdml
Geometry/gdml/bo-gdml-fragments.xml
Geometry/gdml/bo_geo.C
Geometry/gdml/csu40l.gdml
Geometry/gdml/generate_35t4apa.pl
Geometry/gdml/generate_35t.pl
Geometry/gdml/generate_APAoutside.pl
Geometry/gdml/generate_gdml_simple.pl
Geometry/gdml/generate_gdml_test.pl
Geometry/gdml/generate_ICARUS.pl
Geometry/gdml/generate_lar1_gdml.pl
Geometry/gdml/generate_lbne10kT.pl
Geometry/gdml/generate_lbne34kt.pl
Geometry/gdml/generate_lbne_gdml.pl
Geometry/gdml/generate_lbnend_gdml.pl
Geometry/gdml/generate_voltpc.pl
Geometry/gdml/genmake
Geometry/gdml/global-defs.gdml
Geometry/gdml/icarus.gdml
Geometry/gdml/icarus_nowires.gdml
Geometry/gdml/jp250L.gdml
Geometry/gdml/lar1.gdml
Geometry/gdml/lar1_geo.C
Geometry/gdml/lariat.gdml
Geometry/gdml/lariat_geo.C
Geometry/gdml/lariat_geo_wdisk.C
Geometry/gdml/lariat_wdisk.gdml
Geometry/gdml/lbne10kt_20Paddles.gdml
Geometry/gdml/lbne10kt36.gdml
Geometry/gdml/lbne10kt36_nowires.gdml
Geometry/gdml/lbne10kt_APAoutside.gdml
Geometry/gdml/lbne10kt_APAoutside_nowires.gdml
Geometry/gdml/lbne10kt.gdml
Geometry/gdml/lbne10kt_nowires.gdml
Geometry/gdml/lbne34kt.gdml
Geometry/gdml/lbne34kt_nowires.gdml
Geometry/gdml/lbne35t4apa.gdml
Geometry/gdml/lbne35t4apa_nowires.gdml
Geometry/gdml/lbne35t.gdml
Geometry/gdml/lbne35t_nowires.gdml
Geometry/gdml/lbne4apa36deg.gdml
Geometry/gdml/lbne4apa36deg_nowires.gdml
Geometry/gdml/lbne4apa45deg.gdml
Geometry/gdml/lbne4apa45deg_nowires.gdml
Geometry/gdml/lbnebulky.gdml
Geometry/gdml/lbnebulky_geo.C
Geometry/gdml/lbnebulky_onecryo.C
Geometry/gdml/lbnebulky_onecryo.gdml
Geometry/gdml/lbne.gdml
Geometry/gdml/lbne-gdml-fragments.xml
Geometry/gdml/lbne_geo.C
Geometry/gdml/lbnend.gdml
Geometry/gdml/lbnend_geo.C
Geometry/gdml/longbo.gdml
Geometry/gdml/make_gdml.pl
Geometry/gdml/make_lbne_gdml.pl
Geometry/gdml/materials.gdml
Geometry/gdml/microboone_5mm.gdml
Geometry/gdml/microboone.gdml
Geometry/gdml/microboone_geo.C
Geometry/gdml/microboone-granite.gdml
Geometry/gdml/microboone-granite_geo.C
Geometry/gdml/microboone_nowires.gdml
Geometry/gdml/microboone_simplegeo.C
Geometry/gdml/print_lbne_gdml.pl
Geometry/gdml/README
Geometry/gdml/voltpc.gdml
Geometry/gdml/voltpc_geo.C"


for file in ${gdmlist}
do
 echo "--exclude ${file} \\"
done
