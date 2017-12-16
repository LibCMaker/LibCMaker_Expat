# Code from:
# https://github.com/qgis/QGIS/blob/master/cmake/FindExpat.cmake
#
# Find Expat
# ~~~~~~~~~~
# Copyright (c) 2007, Martin Dobias <wonder.sk at gmail.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# CMake module to search for Expat library
# (library for parsing XML files)
#
# If it's found it sets EXPAT_FOUND to TRUE
# and following variables are set:
#    EXPAT_INCLUDE_DIR
#    EXPAT_LIBRARY

# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing. 
find_path(EXPAT_INCLUDE_DIR expat.h
    "$ENV{LIB_DIR}/include/"
    "$ENV{LIB_DIR}/include/expat"
    c:/msys/local/include
  NO_DEFAULT_PATH
  )
find_path(EXPAT_INCLUDE_DIR expat.h)

# libexpat needed for msvc version
find_library(EXPAT_LIBRARY
  NAMES expat libexpat
  PATHS 
    "$ENV{LIB_DIR}/lib"
    c:/msys/local/lib
  NO_DEFAULT_PATH
  )
find_library(EXPAT_LIBRARY
  NAMES expat libexpat
)

if(EXPAT_INCLUDE_DIR AND EXPAT_LIBRARY)
  set(EXPAT_FOUND TRUE)
endif(EXPAT_INCLUDE_DIR AND EXPAT_LIBRARY)


if(EXPAT_FOUND)
  if(NOT EXPAT_FIND_QUIETLY)
    message(STATUS "Found Expat: ${EXPAT_LIBRARY}")
  endif(NOT EXPAT_FIND_QUIETLY)
else(EXPAT_FOUND)
  if(EXPAT_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find Expat")
  else(EXPAT_FIND_REQUIRED)
    if(NOT EXPAT_FIND_QUIETLY)
     message(STATUS "Could not find Expat")
    endif(NOT EXPAT_FIND_QUIETLY)
  endif(EXPAT_FIND_REQUIRED)
endif(EXPAT_FOUND)
