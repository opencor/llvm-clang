include(CheckIncludeFiles)

set(LLVM_LINK_COMPONENTS support)

set(DIRECTORY_WATCHER_SOURCES DirectoryScanner.cpp)

list(APPEND DIRECTORY_WATCHER_SOURCES default/DirectoryWatcher-not-implemented.cpp)

add_clang_library(clangDirectoryWatcher
  ${DIRECTORY_WATCHER_SOURCES}
  )

target_link_libraries(clangDirectoryWatcher PUBLIC ${CMAKE_THREAD_LIBS_INIT})
