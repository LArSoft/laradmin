# this is cumbersome because we aren't using cetbuildtools

include(CMakePackageConfigHelpers)

execute_process( COMMAND date
                 OUTPUT_VARIABLE datime
                 OUTPUT_STRIP_TRAILING_WHITESPACE )

CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/${product}.table.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${product}.table @ONLY )
CONFIGURE_FILE ( ${CMAKE_CURRENT_SOURCE_DIR}/${product}.version.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${UPSFLAVOR}_ @ONLY )

INSTALL (FILES ${CMAKE_CURRENT_BINARY_DIR}/${product}.table
         DESTINATION ${product}/${version}/ups)
INSTALL (FILES ${CMAKE_CURRENT_BINARY_DIR}/${UPSFLAVOR}_
         DESTINATION ${product}/${version}.version/ )
