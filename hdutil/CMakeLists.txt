add_executable(hdutil hdutil.c)
target_include_directories(hdutil PRIVATE ${PROJECT_SOURCE_DIR}/include)
target_link_libraries(hdutil PRIVATE dmg hfs common)

install(TARGETS hdutil DESTINATION .)
