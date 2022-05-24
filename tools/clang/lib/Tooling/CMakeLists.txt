set(LLVM_LINK_COMPONENTS
  Option
  FrontendOpenMP
  Support
  )

add_subdirectory(Core)
add_subdirectory(Inclusions)
add_subdirectory(Refactoring)
add_subdirectory(ASTDiff)
add_subdirectory(Syntax)
add_subdirectory(DependencyScanning)
add_subdirectory(Transformer)

# Replace the last lib component of the current binary directory with include
string(FIND ${CMAKE_CURRENT_BINARY_DIR} "/lib/" PATH_LIB_START REVERSE)
if(PATH_LIB_START EQUAL -1)
  message(FATAL_ERROR "Couldn't find lib component in binary directory")
endif()
math(EXPR PATH_LIB_END "${PATH_LIB_START}+5")
string(SUBSTRING ${CMAKE_CURRENT_BINARY_DIR} 0 ${PATH_LIB_START} PATH_HEAD)
string(SUBSTRING ${CMAKE_CURRENT_BINARY_DIR} ${PATH_LIB_END} -1 PATH_TAIL)
string(CONCAT BINARY_INCLUDE_DIR ${PATH_HEAD} "/include/clang/" ${PATH_TAIL})

configure_file(
  EmptyNodeIntrospection.inc.in
  ${BINARY_INCLUDE_DIR}/NodeIntrospection.inc
  COPYONLY
)
set(CLANG_TOOLING_BUILD_AST_INTROSPECTION "OFF" CACHE BOOL "")

add_clang_library(clangTooling
  AllTUsExecution.cpp
  ArgumentsAdjusters.cpp
  CommonOptionsParser.cpp
  CompilationDatabase.cpp
  Execution.cpp
  ExpandResponseFilesCompilationDatabase.cpp
  FileMatchTrie.cpp
  FixIt.cpp
  GuessTargetAndModeCompilationDatabase.cpp
  InterpolatingCompilationDatabase.cpp
  JSONCompilationDatabase.cpp
  Refactoring.cpp
  RefactoringCallbacks.cpp
  StandaloneExecution.cpp
  NodeIntrospection.cpp
  ${BINARY_INCLUDE_DIR}/NodeIntrospection.inc
  Tooling.cpp

  DEPENDS
  ClangDriverOptions
  omp_gen

  LINK_LIBS
  clangAST
  clangASTMatchers
  clangBasic
  clangDriver
  clangFormat
  clangFrontend
  clangLex
  clangRewrite
  clangSerialization
  clangToolingCore
  )
