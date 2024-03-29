INCLUDE(FindBZip2)
INCLUDE(FindPNG)

IF(NOT BZIP2_FOUND)
	message(FATAL_ERROR "libbz2 is required for ipsw!")
ENDIF(NOT BZIP2_FOUND)

IF(NOT PNG_FOUND)
	message(FATAL_ERROR "libpng is required for ipsw!")
ENDIF(NOT PNG_FOUND)

include_directories(${BZIP2_INCLUDE_DIR})
link_directories(${BZIP2_LIBRARIES})
include_directories(${PNG_INCLUDE_DIR})
link_directories(${PNG_LIBRARIES})

link_directories(${PROJECT_BINARY_DIR}/common ${PROJECT_BINARY_DIR}/hfs ${PROJECT_BINARY_DIR}/dmg)

IF(HAVE_HW_CRYPTO)
	add_definitions(-DHAVE_HW_CRYPTO)
ENDIF(HAVE_HW_CRYPTO)

add_library(xpwn 8900.c bspatch.c ibootim.c img2.c img3.c libxpwn.c lzss.c lzssfile.c nor_files.c outputstate.c plist.c pwnutil.c)

IF(HAVE_HW_CRYPTO)
	target_link_libraries(xpwn IOKit)
ENDIF(HAVE_HW_CRYPTO)

target_link_libraries(xpwn dmg hfs common minizip-ng mbedcrypto ${BZIP2_LIBRARIES} ${PNG_LIBRARIES} ${ZLIB_LIBRARIES} m)

IF(APPLE)
	ADD_CUSTOM_TARGET(libXPwn.a
		COMMAND powerpc-apple-darwin8-libtool -static -o libXPwn.a
			${PROJECT_BINARY_DIR}/ipsw-patch/libxpwn.a ${PROJECT_BINARY_DIR}/minizip/libminizip.a
			${PROJECT_BINARY_DIR}/common/libcommon.a ${PROJECT_BINARY_DIR}/hfs/libhfs.a
			${PROJECT_BINARY_DIR}/dmg/libdmg.a ${PNG_LIBRARIES} ${BZIP2_LIBRARIES}
			${CRYPTO_LIBRARIES}
		DEPENDS xpwn dmg hfs common minizip)
ELSE(APPLE)
	ADD_CUSTOM_TARGET(libXPwn.a
		COMMAND ${CMAKE_C_COMPILER} ${CMAKE_C_FLAGS}
			-L${PROJECT_BINARY_DIR}/ipsw-patch -L${PROJECT_BINARY_DIR}/dmg -L${PROJECT_BINARY_DIR}/hfs
			-L${PROJECT_BINARY_DIR}/hfs -L${PROJECT_BINARY_DIR}/minizip -L${PROJECT_BINARY_DIR}/common
			-Xlinker --whole-archive -lxpwn -ldmg -lhfs -lcommon -lminizip
			${CRYPTO_LIBRARIES} ${BZIP2_LIBRARIES} ${PNG_LIBRARIES}
			-Xlinker --unresolved-symbols=ignore-all -Xlinker -r -nostdlib -o libXPwn.o
		COMMAND ${CMAKE_AR} cr libXPwn.a libXPwn.o
		COMMAND ${CMAKE_RANLIB} libXPwn.a
		DEPENDS xpwn dmg hfs common minizip-ng)
ENDIF(APPLE)

IF(WIN32)
	TARGET_LINK_LIBRARIES(xpwn gdi32)
ENDIF(WIN32)

add_executable(ipsw main.c)
target_link_libraries(ipsw xpwn)

add_executable(xpwntool xpwntool.c)
target_link_libraries(xpwntool xpwn)

add_executable(imagetool imagetool.c)
target_link_libraries(imagetool xpwn)

add_executable(validate validate.c)
target_link_libraries(validate xpwn)

add_executable(ticket ticket.c)
target_link_libraries(ticket xpwn)

IF(WIN32)
	ADD_EXECUTABLE(itunespwn itunespwn.c)
	TARGET_LINK_LIBRARIES(itunespwn xpwn gdi32)
	install(TARGETS itunespwn RUNTIME DESTINATION .)
ENDIF(WIN32)

install(TARGETS ipsw xpwntool validate ticket RUNTIME DESTINATION .)
install(DIRECTORY FirmwareBundles/ DESTINATION FirmwareBundles)
install(DIRECTORY bundles/ DESTINATION bundles)
