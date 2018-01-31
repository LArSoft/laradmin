
INSTALL ( PROGRAMS cp-lar-tag
                   cp-lar-tag-old
                   dogit
                   make-release-notes
                   make-release-notes-old
                   tagLAr
          DESTINATION ${product}/${version}/build_tools )

INSTALL (FILES README
         DESTINATION ${product}/${version}/build_tools )
