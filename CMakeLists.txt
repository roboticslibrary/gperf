cmake_minimum_required(VERSION 3.1)

project(gperf)

include(CheckCSourceCompiles)
include(GNUInstallDirs)

set(GPERF_VERSION_MAJOR 3)
set(GPERF_VERSION_MINOR 1)
set(GPERF_VERSION ${GPERF_VERSION_MAJOR}.${GPERF_VERSION_MINOR})

set(PACKAGE_BUGREPORT "bug-gnu-gperf-antispam@gnu.org")
set(PACKAGE_NAME "gperf")
set(PACKAGE_STRING "gperf ${GPERF_VERSION}")
set(PACKAGE_TARNAME "gperf")
set(PACKAGE_URL "https://www.gnu.org/software/gperf/")
set(PACKAGE_VERSION ${GPERF_VERSION})

check_c_source_compiles("int func (int n) { int dynamic_array[n]; }" HAVE_DYNAMIC_ARRAY)

configure_file(src/config.h.cmake.in src/config.h @ONLY)

add_library(
	gp
	STATIC
	lib/getopt.c
	lib/getopt.h
	lib/getopt1.c
	lib/getopt.h
	lib/getline.cc
	lib/getline.h
	lib/hash.cc
	lib/hash.h
)

target_include_directories(
	gp
	PRIVATE
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/lib>
)

add_executable(
	gperf
	src/version.cc
	src/version.h
	src/positions.cc
	src/positions.h
	src/options.cc
	src/options.h
	src/keyword.cc
	src/keyword.h
	src/keyword-list.cc
	src/keyword-list.h
	src/input.cc
	src/input.h
	src/bool-array.cc
	src/bool-array.h
	src/hash-table.cc
	src/hash-table.h
	src/search.cc
	src/search.h
	src/output.cc
	src/output.h
	src/main.cc
)

target_include_directories(
	gperf
	PRIVATE
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/lib>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
)

target_link_libraries(gperf PRIVATE gp)

install(TARGETS	gperf RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

#install(FILES doc/gperf.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
#install(FILES doc/gperf.html DESTINATION ${CMAKE_INSTALL_DOCDIR})
#install(FILES doc/gperf.info DESTINATION ${CMAKE_INSTALL_INFODIR})

configure_file(COPYING COPYING.txt COPYONLY)

set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
set(CPACK_NSIS_PACKAGE_NAME ${PACKAGE_STRING})
set(CPACK_NSIS_URL_INFO_ABOUT ${PACKAGE_URL})
set(CPACK_PACKAGE_CONTACT ${PACKAGE_BUGREPORT})
set(CPACK_PACKAGE_DISPLAY_NAME ${PACKAGE_STRING})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PACKAGE_TARNAME}-${PACKAGE_VERSION}")
set(CPACK_PACKAGE_NAME ${PACKAGE_TARNAME})
set(CPACK_PACKAGE_VENDOR "GNU Project")
set(CPACK_PACKAGE_VERSION ${PACKAGE_VERSION})
set(CPACK_PACKAGE_VERSION_MAJOR ${GPERF_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${GPERF_MINOR_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_BINARY_DIR}/COPYING.txt)
set(CPACK_RPM_FILE_NAME "RPM-DEFAULT")
set(CPACK_RPM_PACKAGE_GROUP "Development/Libraries")
set(CPACK_RPM_PACKAGE_LICENSE "GPL")
set(CPACK_RPM_PACKAGE_NAME ${PACKAGE_TARNAME})
set(CPACK_RPM_PACKAGE_URL ${PACKAGE_URL})
set(CPACK_WIX_PROPERTY_ARPHELPLINK ${PACKAGE_BUGREPORT})
set(CPACK_WIX_PROPERTY_ARPURLINFOABOUT ${PACKAGE_URL})

include(CPack)
