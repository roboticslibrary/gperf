include(FindPackageHandleStandardArgs)

find_program(HELP2MAN_EXECUTABLE help2man)

mark_as_advanced(HELP2MAN_EXECUTABLE)

find_package_handle_standard_args(
	Help2man
	DEFAULT_MSG
	HELP2MAN_EXECUTABLE
)

if(HELP2MAN_EXECUTABLE AND NOT TARGET help2man::help2man)
	add_executable(help2man::help2man IMPORTED GLOBAL)
	set_target_properties(help2man::help2man PROPERTIES IMPORTED_LOCATION "${HELP2MAN_EXECUTABLE}")
endif()
