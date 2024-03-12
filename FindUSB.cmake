find_package(PkgConfig)
set(CMAKE_FIND_DEBUG_MODE ON)
pkg_search_module(LIBUSB REQUIRED IMPORTED_TARGET libusb-1.0)

add_library(usb ALIAS PkgConfig::LIBUSB)
