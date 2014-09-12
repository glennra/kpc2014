# Try to find PYQT5 utilities, pyuic5 and pyrcc5:
# PYUIC5BINARY - Location of pyuic5 executable
# PYRCC5BINARY - Location of pyrcc5 executable
# PYQT5_FOUND - PYQT5 utilities found.

# Also provides macro similar to FindQt5.cmake's WRAP_UI and WRAP_RC,
# for the automatic generation of Python code from Qt5's user interface
# ('.ui') and resource ('.qrc') files. These macros are called:
# - PYQT5_WRAP_UI
# - PYQT5_WRAP_RC

IF(PYUIC5BINARY AND PYRCC5BINARY)
  # Already in cache, be silent
  set(PYQT5_FIND_QUIETLY TRUE)
ENDIF(PYUIC5BINARY AND PYRCC5BINARY)

if(WIN32)
	FIND_PROGRAM(PYUIC5BINARY pyuic5.bat)
	FIND_PROGRAM(PYRCC5BINARY pyrcc5)
endif(WIN32)
if(APPLE)
	FIND_PROGRAM( PYUIC5BINARY pyuic5
		HINTS ${PYTHON_BIN_DIR} 
		)
	FIND_PROGRAM(PYRCC5BINARY pyrcc5
		HINTS ${PYTHON_BIN_DIR} 
		)
endif(APPLE)
#message(STATUS "PYUIC5BINARY ${PYUIC5BINARY}" )
#message(STATUS "PYRCC5BINARY ${PYRCC5BINARY}" )

MACRO(PYQT5_WRAP_UI outfiles)
  FOREACH(it ${ARGN})
    GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
    GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
    SET(outfile ${CMAKE_CURRENT_SOURCE_DIR}/ui_${outfile}.py)
    ADD_CUSTOM_TARGET(${it} ALL
      DEPENDS ${outfile}
    )
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
      COMMAND ${PYUIC5BINARY} ${infile} -o ${outfile}
      MAIN_DEPENDENCY ${infile}
    )
    SET(${outfiles} ${${outfiles}} ${outfile})
  ENDFOREACH(it)
ENDMACRO (PYQT5_WRAP_UI)

MACRO(PYQT5_WRAP_RC outfiles)
  FOREACH(it ${ARGN})
    GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
    GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
    SET(outfile ${CMAKE_CURRENT_SOURCE_DIR}/${outfile}_rc.py)
    message("target: ${it}")
    # remove slashes from the filename because target names can't have slashes in them
	string(REPLACE "/" "-" target-name ${it} )
    
    ADD_CUSTOM_TARGET(${target-name} ALL
      DEPENDS ${outfile}
    )
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
      COMMAND ${PYRCC5BINARY} ${infile} -o ${outfile}
      MAIN_DEPENDENCY ${infile}
    )
    SET(${outfiles} ${${outfiles}} ${outfile})
  ENDFOREACH(it)
ENDMACRO (PYQT5_WRAP_RC)

IF(EXISTS ${PYUIC5BINARY} AND EXISTS ${PYRCC5BINARY})
   set(PYQT5_FOUND TRUE)
ENDIF(EXISTS ${PYUIC5BINARY} AND EXISTS ${PYRCC5BINARY})

if(PYQT5_FOUND)
  if(NOT PYQT5_FIND_QUIETLY)
    message(STATUS "Found PYQT5: ${PYUIC5BINARY}, ${PYRCC5BINARY}")
  endif(NOT PYQT5_FIND_QUIETLY)
endif(PYQT5_FOUND)
