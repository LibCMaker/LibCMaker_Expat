# ****************************************************************************
#  Project:  LibCMaker_Expat
#  Purpose:  A CMake build script for Expat library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2018 NikitaFeodonit
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

# Part of "LibCMaker/cmake/cmr_build_rules.cmake".

  set(expat_INSTALL ON)
  if(SKIP_INSTALL_ALL)
    set(expat_INSTALL OFF)
  endif()
  option(EXPAT_ENABLE_INSTALL "install expat files in cmake install target" ${expat_INSTALL})

  if(MSVC)
    set(_EXPAT_MSVC_STATIC_CRT OFF)
    if(cmr_USE_STATIC_RUNTIME)
      set(_EXPAT_MSVC_STATIC_CRT ON)
    endif()
    set(EXPAT_MSVC_STATIC_CRT ${_EXPAT_MSVC_STATIC_CRT} CACHE BOOL "Use /MT flag (static CRT) when compiling in MSVC")
  endif()

  # Copy CMake build scripts.
  if(COPY_EXPAT_CMAKE_BUILD_SCRIPTS)
    cmr_print_status("Copy CMake build scripts to unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${lib_BASE_DIR}/patch/expat-${lib_VERSION}
        ${lib_SRC_DIR}/
    )
  endif()

  # Configure library.
  add_subdirectory(${lib_SRC_DIR} ${lib_VERSION_BUILD_DIR})
