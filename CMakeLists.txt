cmake_minimum_required(VERSION 3.1)

project(gperf)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(CheckCSourceCompiles)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(GPERF_VERSION_MAJOR 3)
set(GPERF_VERSION_MINOR 1)
set(GPERF_VERSION ${GPERF_VERSION_MAJOR}.${GPERF_VERSION_MINOR})

option(GPERF_BUILD_DOCUMENTATION "Build documentation" OFF)

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

install(
	TARGETS	gperf
	EXPORT gperf
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(GPERF_BUILD_DOCUMENTATION)
	find_package(Help2man REQUIRED)
	find_package(Texinfo REQUIRED)
	file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc)
	add_custom_command(
		OUTPUT doc/gperf.dvi
		COMMAND texinfo::texi2dvi -o ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.dvi ${CMAKE_CURRENT_SOURCE_DIR}/doc/gperf.texi
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_target(dvi DEPENDS doc/gperf.dvi)
	add_custom_command(
		OUTPUT doc/gperf.html
		COMMAND texinfo::texi2html -o ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.html ${CMAKE_CURRENT_SOURCE_DIR}/doc/gperf.texi
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_command(
		OUTPUT doc/gperf_toc.html
		COMMAND texinfo::texi2html -o ${CMAKE_CURRENT_BINARY_DIR}/doc -number -split_chapter ${CMAKE_CURRENT_SOURCE_DIR}/doc/gperf.texi
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_target(html DEPENDS doc/gperf.html doc/gperf_toc.html)
	add_custom_command(
		OUTPUT doc/gperf.info
		COMMAND texinfo::makeinfo -o ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.info --no-split ${CMAKE_CURRENT_SOURCE_DIR}/doc/gperf.texi
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_target(info DEPENDS doc/gperf.info)
	add_custom_command(
		OUTPUT doc/gperf.1
		COMMAND help2man::help2man --name='generate a perfect hash function from a key set' -o ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.1 $<TARGET_FILE:gperf>
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_target(man DEPENDS doc/gperf.1)
	add_custom_command(
		OUTPUT doc/gperf.pdf
		COMMAND texinfo::texi2pdf -o ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.pdf ${CMAKE_CURRENT_SOURCE_DIR}/doc/gperf.texi
		DEPENDS doc/gperf.texi doc/gpl-3.0.texi
	)
	add_custom_target(pdf DEPENDS doc/gperf.pdf)
	add_custom_target(doc ALL DEPENDS html info man)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.html DESTINATION ${CMAKE_INSTALL_DOCDIR})
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.info DESTINATION ${CMAKE_INSTALL_INFODIR})
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/doc/gperf.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
endif()

export(
	TARGETS gperf
	NAMESPACE gperf::
	FILE ${CMAKE_CURRENT_BINARY_DIR}/gperf-export.cmake
)

configure_package_config_file(
	gperf-config.cmake.in gperf-config.cmake
	INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gperf-${GPERF_VERSION}
)

install(
	FILES ${CMAKE_CURRENT_BINARY_DIR}/gperf-config.cmake
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gperf-${GPERF_VERSION}
	COMPONENT development
)

write_basic_package_version_file(
	${CMAKE_CURRENT_BINARY_DIR}/gperf-config-version.cmake
	VERSION ${GPERF_VERSION}
	COMPATIBILITY ExactVersion
)

install(
	FILES ${CMAKE_CURRENT_BINARY_DIR}/gperf-config-version.cmake
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gperf-${GPERF_VERSION}
	COMPONENT development
)

install(
	EXPORT gperf
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gperf-${GPERF_VERSION}
	NAMESPACE gperf::
	FILE gperf-export.cmake
	COMPONENT development
)

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
