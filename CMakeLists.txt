cmake_minimum_required(VERSION 2.8)

project(CountryCode)

# Load local CMake modules
set(CMAKE_MODULE_PATH 
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH}
)
include(FindPyQt5)
find_package(PyQt5 REQUIRED)


message(STATUS "PYUIC5BINARY ${PYUIC5BINARY}" )
message(STATUS "PYRCC5BINARY ${PYRCC5BINARY}" )

include(FindPythonInterp 2.7)

set(ui country_selector.ui)

PYQT5_WRAP_UI(ui_gen ${ui})

set(PYINSTALLER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/pyinstaller)

set(optimise "-O") # set to "" for a debug build
# To create main.spec
# python ../pyinstaller/pyinstaller.py -w -d -y ../main.py
add_custom_target(
	package-stage ALL
	# Get the Python version so that it appears in the build log
	COMMAND ${PYTHON_EXECUTABLE} -V
	COMMAND ${PYTHON_EXECUTABLE} ${optimise} ${PYINSTALLER_DIR}/pyinstaller.py
	    --windowed --debug --noconfirm --log-level=INFO
	    ${CMAKE_CURRENT_SOURCE_DIR}/main.spec
	DEPENDS ${ui}
)

install(
    DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/dist/CountryCode.app
    DESTINATION .
    USE_SOURCE_PERMISSIONS
)


if(APPLE)
    #set(CPACK_GENERATOR DragNDrop)
    set(CPACK_GENERATOR PackageMaker)
    set(CPACK_PACKAGE_DEFAULT_LOCATION "/Applications")
    set(CPACK_PACKAGING_INSTALL_PREFIX "/")
	set(CPACK_SYSTEM_NAME osx) # default is "Darwin"
endif()

include(CPack)
