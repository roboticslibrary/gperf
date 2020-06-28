include(FindPackageHandleStandardArgs)

find_program(TEXINFO_MAKEINFO_EXECUTABLE makeinfo)
mark_as_advanced(TEXINFO_MAKEINFO_EXECUTABLE)

find_program(TEXINFO_TEXI2DVI_EXECUTABLE texi2dvi)
mark_as_advanced(TEXINFO_TEXI2DVI_EXECUTABLE)

find_program(TEXINFO_TEXI2HTML_EXECUTABLE texi2html)
mark_as_advanced(TEXINFO_TEXI2HTML_EXECUTABLE)

find_program(TEXINFO_TEXI2PDF_EXECUTABLE texi2pdf)
mark_as_advanced(TEXINFO_TEXI2PDF_EXECUTABLE)

find_package_handle_standard_args(
	Texinfo
	DEFAULT_MSG
	TEXINFO_MAKEINFO_EXECUTABLE
	TEXINFO_TEXI2DVI_EXECUTABLE
	TEXINFO_TEXI2HTML_EXECUTABLE
	TEXINFO_TEXI2PDF_EXECUTABLE
)

if(TEXINFO_MAKEINFO_EXECUTABLE AND NOT TARGET texinfo::makeinfo)
	add_executable(texinfo::makeinfo IMPORTED GLOBAL)
	set_target_properties(texinfo::makeinfo PROPERTIES IMPORTED_LOCATION "${TEXINFO_MAKEINFO_EXECUTABLE}")
endif()

if(TEXINFO_TEXI2DVI_EXECUTABLE AND NOT TARGET texinfo::texi2dvi)
	add_executable(texinfo::texi2dvi IMPORTED GLOBAL)
	set_target_properties(texinfo::texi2dvi PROPERTIES IMPORTED_LOCATION "${TEXINFO_TEXI2DVI_EXECUTABLE}")
endif()

if(TEXINFO_TEXI2HTML_EXECUTABLE AND NOT TARGET texinfo::texi2html)
	add_executable(texinfo::texi2html IMPORTED GLOBAL)
	set_target_properties(texinfo::texi2html PROPERTIES IMPORTED_LOCATION "${TEXINFO_TEXI2HTML_EXECUTABLE}")
endif()

if(TEXINFO_TEXI2PDF_EXECUTABLE AND NOT TARGET texinfo::texi2pdf)
	add_executable(texinfo::texi2pdf IMPORTED GLOBAL)
	set_target_properties(texinfo::texi2pdf PROPERTIES IMPORTED_LOCATION "${TEXINFO_TEXI2PDF_EXECUTABLE}")
endif()
