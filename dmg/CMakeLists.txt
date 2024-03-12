add_library(dmg checksum.c dmgfile.c dmglib.c filevault.c io.c partition.c resources.c udif.c)

target_include_directories(dmg PUBLIC ${PROJECT_SOURCE_DIR}/include)
target_link_libraries(dmg common hfs mbedcrypto zlib)

add_executable(dmg-bin dmg.c)
target_link_libraries(dmg-bin PRIVATE dmg)

set_target_properties(dmg-bin PROPERTIES OUTPUT_NAME "dmg")

install(TARGETS dmg-bin DESTINATION .)
