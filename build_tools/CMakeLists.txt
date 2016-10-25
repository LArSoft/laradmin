
INSTALL ( PROGRAMS cp-lar-tag
                   dogit
                   make-release-notes
                   tagLAr
		   build-larsoft-products.sh
		   build_one_jenkins.sh
		   build_one.sh
		   buildSLF.sh
		   test_all.sh
		   test_one.sh
          DESTINATION ${product}/${version}/build_tools )

INSTALL (FILES README
         DESTINATION ${product}/${version}/build_tools )
