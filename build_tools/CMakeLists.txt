
INSTALL ( PROGRAMS cp-lar-tag
                   dogit
                   make-release-notes
                   tagLAr
          DESTINATION ${product}/${version}/build_tools )

INSTALL (FILES README
         DESTINATION ${product}/${version}/build_tools )
