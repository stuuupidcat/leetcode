cmake_minimum_required(VERSION "3.21")
project("leet-code" CXX)

# Global configuration.
if(MSVC)
    set(CMAKE_INCLUDE_SYSTEM_FLAG_C "/external:I")
    set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "/external:I")

    add_compile_options("/experimental:external" "/external:W0")
endif()

# The main library.
add_library("leet-code" INTERFACE)

if(PROJECT_IS_TOP_LEVEL)
    target_include_directories("leet-code" INTERFACE "include")
else()
    target_include_directories("leet-code" SYSTEM INTERFACE "include")
endif()

target_compile_features("leet-code" INTERFACE cxx_std_17)

# Tests.
if(PROJECT_IS_TOP_LEVEL)
    include("GoogleTest")
    find_package("GTest" CONFIG REQUIRED)

    enable_testing()

    # Common compile options.
    add_library("common-compile-options" INTERFACE)

    if(MSVC)
        target_compile_options(
            "common-compile-options"
            INTERFACE
            "/permissive-"
            "/W4"
            "/we4287"
            "/we4365"
            "/we4388"
            "/we4826"
            "/WX"
        )
    else()
        target_compile_options(
            "common-compile-options"
            INTERFACE
            "-Wall"
            "-Wextra"
            "-Wpedantic"
            "-Wconversion"
            "-Werror"
        )
    endif()

    # Check headers.
    set(
        LEET_CODE_HEADERS
        "include/leet-code/data-structures/list-node.h"
        "include/leet-code/data-structures/tree-node-with-next-right-pointer.h"
        "tests/leet-code/test-utilities.h"
        # Add new problem headers here.
    )

    set(CHECK_LEET_CODE_HEADERS_SOURCES)

    foreach(LEET_CODE_HEADER ${LEET_CODE_HEADERS})
        string(REGEX REPLACE "^(include|tests)/" "" RELATIVE_HEADER_PATH "${LEET_CODE_HEADER}")
        string(REGEX REPLACE "\.[^.]*$" "" BASE_PATH "${RELATIVE_HEADER_PATH}")
        set(SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/leet-code-check-headers/src/${BASE_PATH}.cpp")

        file(GENERATE OUTPUT "${SOURCE_FILE}" CONTENT "#include <${RELATIVE_HEADER_PATH}>")

        list(APPEND CHECK_LEET_CODE_HEADERS_SOURCES "${SOURCE_FILE}")
    endforeach()

    add_library("check-leet-code-headers" OBJECT ${CHECK_LEET_CODE_HEADERS_SOURCES})

    target_include_directories("check-leet-code-headers" PRIVATE "tests")
    target_link_libraries("check-leet-code-headers" PRIVATE "common-compile-options" "leet-code" "GTest::gtest_main")

    set_target_properties(
        "check-leet-code-headers"
        PROPERTIES
        CXX_EXTENSIONS OFF
        CXX_STANDARD_REQUIRED ON
    )

    # Test executable.
    add_executable(
        "leet-code-tests"
        "tests/leet-code/test-utilities.cpp"
        # Add new problem test .cpp files here.
    )

    target_link_libraries("leet-code-tests" PRIVATE "common-compile-options" "leet-code" "GTest::gtest_main")

    set_target_properties(
        "leet-code-tests"
        PROPERTIES
        CXX_EXTENSIONS OFF
        CXX_STANDARD_REQUIRED ON
    )

    gtest_discover_tests("leet-code-tests")

    # Options.
    set(ENABLE_CLANG_TIDY OFF CACHE STRING "Enable Clang-Tidy check.")

    if(ENABLE_CLANG_TIDY)
        set_target_properties(
            "leet-code-tests"
            PROPERTIES CXX_CLANG_TIDY "${ENABLE_CLANG_TIDY}"
        )
    endif()
endif()
