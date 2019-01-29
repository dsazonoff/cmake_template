cmake_minimum_required (VERSION 3.12.0)

project(TEST CXX)

# Settings
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_DEBUG_POSTFIX "d")

find_package(libA CONFIG REQUIRED)

if(WIN32)
  # Windows
  add_definitions(-D_WIN32_WINNT=0x0600)
elseif(APPLE)
  # Mac OS
elseif(UNIX AND NOT APPLE)
  # Linux
endif()

set(SRC_FILES "main.cpp")

# Library
add_executable(${PROJECT_NAME} ${SRC_FILES})
target_link_libraries(${PROJECT_NAME} PUBLIC libA)