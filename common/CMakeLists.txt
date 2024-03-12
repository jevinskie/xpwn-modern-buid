add_library(common abstractfile.c base64.c)
target_include_directories(common PUBLIC ${PROJECT_SOURCE_DIR}/include)
