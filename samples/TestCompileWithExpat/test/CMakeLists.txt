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

# Testing with Google Test.
if(BUILD_TESTING)
  find_package(GTest REQUIRED)

  set(test_NAME "Examle_test")
  add_executable(${test_NAME} ${IOS_MACOSX_BUNDLE} "")
  target_sources(${test_NAME}
    PRIVATE
      ${test_src_DIR}/example_test.cpp
  )
  set_target_properties(${test_NAME} PROPERTIES
    CXX_STANDARD 11
    C_STANDARD 11
  )

  # Expat
  if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(${test_NAME} PRIVATE
      -DXML_STATIC
    )
  endif()
  target_include_directories(${test_NAME} PRIVATE ${EXPAT_INCLUDE_DIR})
  target_link_libraries(${test_NAME} PRIVATE ${EXPAT_LIBRARY})

  target_link_libraries(${test_NAME} PRIVATE
    GTest::GTest GTest::Main
  )

  if(NOT ANDROID AND NOT IOS)  # Linux, Windows, macOS
    add_test(NAME ${test_NAME} COMMAND ${test_NAME})
  endif()

  if(ANDROID)
    find_program(adb_exec adb)
    if(NOT adb_exec)
      message(FATAL_ERROR "Could not find 'adb'")
    endif()

    set(TEST_WORK_DIR "/data/local/tmp/LibCMaker_test")

    add_test(NAME rm_work_dir
      COMMAND ${adb_exec} shell "if [ -d \"${TEST_WORK_DIR}\" ] ; then rm -r \"${TEST_WORK_DIR}\" ; fi"
    )

    if(BUILD_SHARED_LIBS)
      add_test(NAME push_libs
        COMMAND ${adb_exec} push "${cmr_INSTALL_DIR}/lib" "${TEST_WORK_DIR}/lib"
      )

      find_library(cpp_shared_LIB "c++_shared")
      if(NOT cpp_shared_LIB)
        message(FATAL_ERROR "The library 'c++_shared' can not be found.")
      endif()

      get_filename_component(cpp_shared_LIB_FILE_NAME ${cpp_shared_LIB} NAME)

      add_test(NAME push_cpp_shared
        COMMAND ${adb_exec} push
          "${cpp_shared_LIB}"
          "${TEST_WORK_DIR}/lib/${cpp_shared_LIB_FILE_NAME}"
      )
    endif()

    add_test(NAME push_${test_NAME}
      COMMAND ${adb_exec} push ${test_NAME} "${TEST_WORK_DIR}/${test_NAME}"
    )
    add_test(NAME chmod_${test_NAME}
      COMMAND ${adb_exec} shell chmod 775 "${TEST_WORK_DIR}/${test_NAME}"
    )
    add_test(NAME cd_to_work_dir COMMAND ${adb_exec} shell
      cd "${TEST_WORK_DIR}"
    )
    add_test(NAME ${test_NAME} COMMAND ${adb_exec} shell
      "cd ${TEST_WORK_DIR} && "
      "LD_LIBRARY_PATH=${TEST_WORK_DIR}/lib ${TEST_WORK_DIR}/${test_NAME}"
      # :${LD_LIBRARY_PATH} || :/vendor/lib64:/system/lib64
    )
  endif()

  if(IOS)
    set(IOS_APP_BUNDLE_IDENTIFIER_GTEST "${IOS_APP_BUNDLE_IDENTIFIER}.gtest")
    set(IOS_TEST_APP_BIN_DIR
      "${PROJECT_BINARY_DIR}/test/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${test_NAME}.app"
    )
    set(IOS_TEST_APP_FULL_BIN_DIR
      "${PROJECT_BINARY_DIR}/test/$<CONFIG>-iphonesimulator/${test_NAME}.app"
    )

    set_target_properties(${test_NAME} PROPERTIES
      MACOSX_BUNDLE_INFO_STRING "${IOS_APP_BUNDLE_IDENTIFIER_GTEST}"
      MACOSX_BUNDLE_GUI_IDENTIFIER "${IOS_APP_BUNDLE_IDENTIFIER_GTEST}"
      MACOSX_BUNDLE_BUNDLE_NAME "${IOS_APP_BUNDLE_IDENTIFIER_GTEST}"

      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "${IOS_CODE_SIGN_IDENTITY}"
      XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${IOS_DEPLOYMENT_TARGET}
      XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${IOS_DEVICE_FAMILY}
    )

    if(BUILD_SHARED_LIBS)
      add_custom_command(TARGET ${test_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory
          "${IOS_TEST_APP_BIN_DIR}/lib"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
          "${CMAKE_INSTALL_PREFIX}/lib"
          "${IOS_TEST_APP_BIN_DIR}/lib/"
      )
    endif()

    if(IOS_CODE_SIGN_IDENTITY)
      # Codesign the framework in it's new spot
      add_custom_command(TARGET ${test_NAME} POST_BUILD
        #COMMAND codesign --force --verbose
        #    ${IOS_TEST_APP_BIN_DIR}/Frameworks/${FRAMEWORK_NAME}.framework
        #    --sign ${IOS_CODE_SIGN_IDENTITY}
        #COMMAND codesign --force --verbose
        #    \${BUILT_PRODUCTS_DIR}/${test_NAME}.app/Frameworks/${FRAMEWORK_NAME}.framework
        #    --sign ${IOS_CODE_SIGN_IDENTITY}
        COMMAND codesign --force --verbose
            ${IOS_TEST_APP_BIN_DIR}/${test_NAME}
            --sign ${IOS_CODE_SIGN_IDENTITY}
      )
    endif()

    add_test(NAME install_${test_NAME}
      COMMAND xcrun simctl install booted ${IOS_TEST_APP_FULL_BIN_DIR}/
    )
    add_test(NAME ${test_NAME}
      COMMAND xcrun simctl launch --console-pty booted
        ${IOS_APP_BUNDLE_IDENTIFIER_GTEST}
    )

    # NOTE: Use '--console-pty' with 'xcrun simctl launch' for Travis CI,
    # not '--console'. With '--console' is error:
    # -----------------------------------------------------------------------
    # Unable to establish FIFO: Error 2
    # An error was encountered processing the command (domain=NSPOSIXErrorDomain, code=2):
    # The operation couldn.t be completed. No such file or directory
    # No such file or directory
    # -----------------------------------------------------------------------
  endif()

  set_tests_properties(${test_NAME} PROPERTIES
    PASS_REGULAR_EXPRESSION "PASSED"
  )
  set_tests_properties(${test_NAME} PROPERTIES
    FAIL_REGULAR_EXPRESSION "FAILED"
  )
endif()


# For running test, 1st build all:
#   cmake .. -DBUILD_TESTING=ON
#   cmake --build .
# Then run test with this command:
#   cmake -E env CTEST_OUTPUT_ON_FAILURE=1 cmake --build . --target test
# Or with this command:
#   ctest --verbose
# Env var CTEST_OUTPUT_ON_FAILURE or key --verbose are for show test outputs,
# see
# https://stackoverflow.com/a/37123943
# https://stackoverflow.com/a/38386596

# For Visual Studio:
# https://stackoverflow.com/a/31124523
# https://stackoverflow.com/a/37123943
# cmake -E env CTEST_OUTPUT_ON_FAILURE=1 cmake --build . --target RUN_TESTS
