cmake_minimum_required(VERSION 3.14)
project(lpp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX)
find_package(BISON)

find_program (TREECC treecc
              PATHS /usr /usr/local /opt /opt/local $ENV{TREECC_DIR}
              PATH_SUFFIXES treecc/bin bin )

if (TREECC)
    message(STATUS "Using treecc executable ${TREECC}")
else(TREECC)
    message(FATAL_ERROR "treecc was not found. Try setting TREECC_DIR environment variable")
endif(TREECC)

# Run treecc to generate the AST
add_custom_command (
  OUTPUT lppAst.cpp lppAst.hpp
  COMMAND ${TREECC} -o lppAst.cpp -h lppAst.hpp ${PROJECT_SOURCE_DIR}/lppAst.tc
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/lppAst.tc
  )

FLEX_TARGET(lppLexer lppLexerImpl.l
            ${CMAKE_CURRENT_BINARY_DIR}/lppLexerImpl.cpp
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lppLexerImpl.h
            )

BISON_TARGET(lppParser lppParserImpl.y
            ${CMAKE_CURRENT_BINARY_DIR}/lppParserImpl.cpp
            COMPILE_FLAGS -Wcounterexamples
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lppParserImpl.hpp
            )

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})

add_executable(${PROJECT_NAME}
    ${FLEX_lppLexer_OUTPUTS}
    ${BISON_lppParser_OUTPUTS}
    lppLexer.hpp
    lppLexer.cpp
    lppParser.hpp
    lppParser.cpp
    lppAst.hpp
    lppAst.cpp
    main.cpp
 )
