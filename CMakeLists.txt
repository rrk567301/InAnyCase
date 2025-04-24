cmake_minimum_required(VERSION 3.10)
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)

project("InAnyCase")
add_subdirectory("Dobby")

add_library(inanycase SHARED src/main.mm src/syscall_hooks.mm src/popup_hooks.mm)
target_compile_features(inanycase PRIVATE cxx_std_20)
target_include_directories(inanycase PRIVATE Dobby/include)
target_link_libraries(inanycase PRIVATE dobby_static "-framework Foundation")
