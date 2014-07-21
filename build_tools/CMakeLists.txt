
INSTALL ( PROGRAMS cp-tag
                   tagLAr
		   build_one_jenkins.sh
		   build_one.sh
		   buildSLF.sh
		   buildMountainLion.sh
		   test_all.sh
		   test_one.sh
          DESTINATION ${product}/${version}/build_tools )

INSTALL (FILES README
         DESTINATION ${product}/${version}/build_tools )
