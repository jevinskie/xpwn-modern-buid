include(${PROJECT_SOURCE_DIR}/FindUSB.cmake)

if(NOT USB_FOUND AND NOT APPLE)
		message(STATUS "libusb is required for dfu-util!")
else()
		add_executable(dfu-util dfu.c sam7dfu.c main.c)
		target_include_directories(dfu-util PRIVATE ${PROJECT_SOURCE_DIR}/include)
		target_link_libraries(dfu-util PRIVATE common hfs ipsw-patch usb xpwn)

		install(TARGETS dfu-util DESTINATION .)
endif()
