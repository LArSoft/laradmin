
INSTALL ( PROGRAMS build_nightly.sh
		   cleanold_nightly.sh
		   config_nightly.sh
		   copy_build.sh
		   doxylar
		   init_nightly.sh
		   nightly.sh
		   nightly_wrapper.sh
		   tag_nightly.sh
		   update_lar_doxygen.sh
          DESTINATION ${product}/${version}/nightly )

INSTALL (FILES README
         DESTINATION ${product}/${version}/nightly )
