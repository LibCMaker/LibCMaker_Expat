# ****************************************************************************
#  Project:  LibCMaker_Expat
#  Purpose:  A CMake build script for Expat library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2020 NikitaFeodonit
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

if(IOS)
  cmake_minimum_required(VERSION 3.15)
else()
  cmake_minimum_required(VERSION 3.4)
endif()

project(LibCMaker_Expat_Compile_Test CXX C)

option(CMAKE_VERBOSE_MAKEFILE "CMAKE_VERBOSE_MAKEFILE" OFF)
option(cmr_PRINT_DEBUG "cmr_PRINT_DEBUG" OFF)

if(IOS)
  # https://help.apple.com/xcode/mac/8.0/#/itcaec37c2a6
  # Build settings reference
  # google search string: "build setting reference" site:developer.apple.com
  #
  # https://stackoverflow.com/questions/6910901/how-do-i-print-a-list-of-build-settings-in-xcode-project
  # "How do I print a list of .Build Settings. in Xcode project?"
  #
  # $ xcodebuild -project myProj.xcodeproj -target "myTarg" -showBuildSettings

  # "Building iOS applications using xcodebuild without codesign"
  # https://stackoverflow.com/a/58451900
  # https://stackoverflow.com/a/11647504
  # https://stackoverflow.com/a/39901677
  #
  # CODE_SIGN_IDENTITY=""
  # CODE_SIGNING_REQUIRED="NO"
  # CODE_SIGN_ENTITLEMENTS=""
  # CODE_SIGNING_ALLOWED="NO"


  # From https://github.com/ruslo/sugar
  #set(CMAKE_MACOSX_BUNDLE YES)
  #set(CMAKE_OSX_SYSROOT "iphoneos")
  #set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
  #set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos;-iphonesimulator")
  #set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.example.sugar.iOSGTest")

  # From https://stackoverflow.com/a/972579
  #set(CMAKE_OSX_SYSROOT iphoneos2.2.1)
  #set(CMAKE_OSX_ARCHITECTURES $(ARCHS_STANDARD_32_BIT))
  #set(CMAKE_CXX_FLAGS "-x objective-c++")
  #set(CMAKE_EXE_LINKER_FLAGS "-framework AudioToolbox -framework CoreGraphics -framework QuartzCore -framework UIKit")
  #link_directories(\${HOME}/\${SDKROOT}/lib)
  #set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.mycompany.\${PRODUCT_NAME:identifier}")
  #set(APP_TYPE MACOSX_BUNDLE)


  option(IOS_DISABLE_CODESIGN "IOS_DISABLE_CODESIGN" ON)

  set(IOS_MACOSX_BUNDLE MACOSX_BUNDLE)

  set(DEVELOPMENT_TEAM_ID "TODO")  # Team ID from Apple.
  set(IOS_APP_NAME "LibCMakerTestApp")
  set(IOS_APP_BUNDLE_IDENTIFIER "ru.libcmaker.testapp")
  set(IOS_CODE_SIGN_IDENTITY "iPhone Developer")
  if(IOS_DISABLE_CODESIGN)
    set(IOS_CODE_SIGN_IDENTITY "")
  endif()
  set(IOS_DEPLOYMENT_TARGET 8.0)  # Deployment target version of iOS.
  # Set to "1" to target iPhone, "2" to target iPad, "1,2" to target both.
  set(IOS_DEVICE_FAMILY "1")

  # See CMake's docs for MACOSX_BUNDLE_INFO_PLIST target property for these vars.
  set(MACOSX_BUNDLE_EXECUTABLE_NAME ${IOS_APP_NAME})  # See file MacOSXBundleInfo.plist.in
#  set(MACOSX_BUNDLE_INFO_STRING ${IOS_APP_BUNDLE_IDENTIFIER})
#  set(MACOSX_BUNDLE_GUI_IDENTIFIER ${IOS_APP_BUNDLE_IDENTIFIER})
#  set(MACOSX_BUNDLE_BUNDLE_NAME ${IOS_APP_BUNDLE_IDENTIFIER})
  set(MACOSX_BUNDLE_ICON_FILE "")
  set(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
  set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
  set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
  set(MACOSX_BUNDLE_COPYRIGHT "Copyright (c) 2017-2020 NikitaFeodonit")
  set(MACOSX_DEPLOYMENT_TARGET ${IOS_DEPLOYMENT_TARGET})

  #set(CMAKE_MACOSX_BUNDLE ON)
  #set(CMAKE_FRAMEWORK ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
  #set(CMAKE_INSTALL_RPATH "@executable_path/Frameworks" "@loader_path/Frameworks")
  set(CMAKE_INSTALL_RPATH "@executable_path/lib" "@loader_path/lib")
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif()


#-----------------------------------------------------------------------
# Configure to find_package()
#-----------------------------------------------------------------------

# Set CMake's search path for find_*() commands.
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

if(ANDROID OR IOS)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()


#-----------------------------------------------------------------------
# Set path vars
#-----------------------------------------------------------------------

set(LibCMaker_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/libs")
set(cmr_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")

if(NOT cmr_UNPACKED_DIR)
  set(cmr_UNPACKED_DIR "${PROJECT_BINARY_DIR}/download/unpacked")
endif()


#-----------------------------------------------------------------------
# LibCMaker settings
#-----------------------------------------------------------------------

set(LibCMaker_DIR "${LibCMaker_LIB_DIR}/LibCMaker")
list(APPEND CMAKE_MODULE_PATH "${LibCMaker_DIR}/cmake")
include(cmr_find_package)


#-----------------------------------------------------------------------
# Download, configure, build, install and find the required libraries
#-----------------------------------------------------------------------

option(BUILD_TESTING "Build the testing tree." OFF)
if(BUILD_TESTING)
  enable_testing()
  include(${LibCMaker_LIB_DIR}/LibCMaker_GoogleTest/cmr_build_googletest.cmake)
endif()

include(${LibCMaker_LIB_DIR}/LibCMaker_Expat/cmr_build_expat.cmake)


#-----------------------------------------------------------------------
# Build the executable of the example
#-----------------------------------------------------------------------

set(example_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

add_executable(${PROJECT_NAME} ${IOS_MACOSX_BUNDLE}
  ${example_src_DIR}/example.cpp
)
set_target_properties(${PROJECT_NAME} PROPERTIES
  CXX_STANDARD 11
  C_STANDARD 11
)


#-----------------------------------------------------------------------
# Link to the libraries
#-----------------------------------------------------------------------

# Expat
if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(${PROJECT_NAME} PRIVATE
    -DXML_STATIC
  )
endif()
target_include_directories(${PROJECT_NAME} PRIVATE ${EXPAT_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} PRIVATE ${EXPAT_LIBRARY})


#-----------------------------------------------------------------------
# iOS Bundle
#-----------------------------------------------------------------------

if(IOS)
  set(IOS_APP_BUNDLE_IDENTIFIER_MAIN "${IOS_APP_BUNDLE_IDENTIFIER}.main")
  set(IOS_MAIN_APP_BIN_DIR
    "${PROJECT_BINARY_DIR}/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${PROJECT_NAME}.app"
  )

  set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_INFO_STRING "${IOS_APP_BUNDLE_IDENTIFIER_MAIN}"
    MACOSX_BUNDLE_GUI_IDENTIFIER "${IOS_APP_BUNDLE_IDENTIFIER_MAIN}"
    MACOSX_BUNDLE_BUNDLE_NAME "${IOS_APP_BUNDLE_IDENTIFIER_MAIN}"

    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "${IOS_CODE_SIGN_IDENTITY}"
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${IOS_DEPLOYMENT_TARGET}
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${IOS_DEVICE_FAMILY}
    #
    # From https://github.com/sheldonth/ios-cmake
    #
    #  RESOURCE "${RESOURCES}"
    #  XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES NO
    #
    #  MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/plist.in
    #  XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)"
    #  XCODE_ATTRIBUTE_ENABLE_TESTABILITY YES
    #
    #  XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
    #  XCODE_ATTRIBUTE_GCC_PREFIX_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/Prefix.pch"
    #  XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES"
    #  XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN YES
    #  XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
  )

  if(BUILD_SHARED_LIBS)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory
        "${IOS_MAIN_APP_BIN_DIR}/lib"
      COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_INSTALL_PREFIX}/lib"
        "${IOS_MAIN_APP_BIN_DIR}/lib/"
    )
  endif()

  if(IOS_CODE_SIGN_IDENTITY)
    # Codesign the framework in it's new spot
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
      #COMMAND codesign --force --verbose
      #    ${IOS_MAIN_APP_BIN_DIR}/Frameworks/${FRAMEWORK_NAME}.framework
      #    --sign ${IOS_CODE_SIGN_IDENTITY}
      #COMMAND codesign --force --verbose
      #    \${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.app/Frameworks/${FRAMEWORK_NAME}.framework
      #    --sign ${IOS_CODE_SIGN_IDENTITY}
      COMMAND codesign --force --verbose
          ${IOS_MAIN_APP_BIN_DIR}/${PROJECT_NAME}
          --sign ${IOS_CODE_SIGN_IDENTITY}
    )
  endif()
endif()


#-----------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------

set(test_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")
add_subdirectory(test)
