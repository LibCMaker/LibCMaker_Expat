# ****************************************************************************
#  Project:  LibCMaker_Expat
#  Purpose:  A CMake build script for Expat library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2019 NikitaFeodonit
#
#    This file is part of the LibCMaker_Expat project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

#-----------------------------------------------------------------------
# The file is an example of the convenient script for the library build.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Lib's name, version, paths
#-----------------------------------------------------------------------

set(EXPAT_lib_NAME "Expat")
set(EXPAT_lib_VERSION "2.4.1" CACHE STRING "EXPAT_lib_VERSION")
set(EXPAT_lib_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE PATH "EXPAT_lib_DIR")

# To use our Find<LibName>.cmake.
list(APPEND CMAKE_MODULE_PATH "${EXPAT_lib_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# LibCMaker_<LibName> specific vars and options
#-----------------------------------------------------------------------

#option(SKIP_INSTALL_ALL "SKIP_INSTALL_ALL" ON)
option(COPY_EXPAT_CMAKE_BUILD_SCRIPTS "COPY_EXPAT_CMAKE_BUILD_SCRIPTS" OFF)


#-----------------------------------------------------------------------
# Library specific vars and options
#-----------------------------------------------------------------------

option(EXPAT_BUILD_TOOLS "build the xmlwf tool for expat library" OFF)
option(EXPAT_BUILD_EXAMPLES "build the examples for expat library" OFF)
option(EXPAT_BUILD_TESTS "build the tests for expat library" OFF)
# EXPAT_SHARED_LIBS is set by BUILD_SHARED_LIBS.
#option(EXPAT_SHARED_LIBS "build a shared expat library" ${_EXPAT_SHARED_LIBS_DEFAULT})
option(EXPAT_BUILD_DOCS "build man page for xmlwf" OFF)
option(EXPAT_BUILD_FUZZERS "build fuzzers for the expat library" OFF)
option(EXPAT_BUILD_PKGCONFIG "build pkg-config file" OFF)
option(EXPAT_OSSFUZZ_BUILD "build fuzzers via ossfuzz for the expat library" OFF)
if(UNIX)
  option(EXPAT_WITH_LIBBSD "utilize libbsd (for arc4random_buf)" OFF)
endif()
# Option INSTALL is set in lib_cmaker_expat() by NOT SKIP_INSTALL_ALL.
# Set in 'cmr_build_rules_expat' as NOT SKIP_INSTALL_ALL.
#option(EXPAT_ENABLE_INSTALL "install expat files in cmake install target" ${NOT SKIP_INSTALL_ALL})
set(EXPAT_CONTEXT_BYTES 1024 CACHE STRING "Define to specify how much context to retain around the current parse point")
option(EXPAT_DTD "Define to make parameter entity parsing functionality available" ON)
option(EXPAT_NS "Define to make XML Namespaces functionality available" ON)
option(EXPAT_WARNINGS_AS_ERRORS "Treat all compiler warnings as errors" OFF)
if(UNIX)
  option(EXPAT_DEV_URANDOM "Define to include code reading entropy from `/dev/urandom'." ON)
  set(EXPAT_WITH_GETRANDOM "AUTO" CACHE STRING
      "Make use of getrandom function (ON|OFF|AUTO) [default=AUTO]")
  set(EXPAT_WITH_SYS_GETRANDOM "AUTO" CACHE STRING
      "Make use of syscall SYS_getrandom (ON|OFF|AUTO) [default=AUTO]")
endif()
set(EXPAT_CHAR_TYPE "char" CACHE STRING "Character type to use (char|ushort|wchar_t) [default=char]")
option(EXPAT_ATTR_INFO "Define to allow retrieving the byte offsets for attribute names and values" OFF)
option(EXPAT_LARGE_SIZE "Make XML_GetCurrent* functions return <(unsigned) long long> rather than <(unsigned) long>" OFF)
option(EXPAT_MIN_SIZE "Get a smaller (but slower) parser (in particular avoid multiple copies of the tokenizer)" OFF)
# EXPAT_MSVC_STATIC_CRT is set by cmr_USE_STATIC_RUNTIME.
#if(MSVC)
#  set(EXPAT_MSVC_STATIC_CRT OFF CACHE BOOL "Use /MT flag (static CRT) when compiling in MSVC")
#endif()


#-----------------------------------------------------------------------
# Build, install and find the library
#-----------------------------------------------------------------------

cmr_find_package(
  LibCMaker_DIR   ${LibCMaker_DIR}
  NAME            ${EXPAT_lib_NAME}
  VERSION         ${EXPAT_lib_VERSION}
  LIB_DIR         ${EXPAT_lib_DIR}
  REQUIRED
  FIND_MODULE_NAME EXPAT
)
