cmake_minimum_required (VERSION 3.12.0)

cmake_policy(SET CMP0077 NEW)

get_filename_component(CURRENT_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
project(${CURRENT_DIR_NAME} VERSION 0.1.0 HOMEPAGE_URL https://github.com/dsazonoff LANGUAGES CXX)

# Settings
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)
set(CMAKE_DEBUG_POSTFIX "d")
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

option(${PROJECT_NAME}_BUILD_SHARED "Build C++ SDK as dynamic library" OFF)

if(WIN32)
  # Windows
  add_definitions(-D_WIN32_WINNT=0x0600)
elseif(APPLE)
  # Mac OS
elseif(UNIX AND NOT APPLE)
  # Linux
endif()

include(./sourcelist.cmake)

# Library
if (${PROJECT_NAME}_BUILD_SHARED)
  add_library(${PROJECT_NAME} SHARED ${ALL_FILES})
else()
  add_library(${PROJECT_NAME} STATIC ${ALL_FILES})
endif()

# Include directories
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/includeB>
  $<INSTALL_INTERFACE:includeB_inst>
)

# Export header
include(GenerateExportHeader)
generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME "${PROJECT_NAME}_export.h" DEFINE_NO_DEPRECATED)

# Package
include(CMakePackageConfigHelpers)

# Package for local build
set(_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(CMAKE_CONFIG_DESTINATION "${CMAKE_BINARY_DIR}")

configure_package_config_file(
  cmake/${PROJECT_NAME}Config.cmake.in
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_CONFIG_DESTINATION}
  PATH_VARS _INCLUDE_DIRS
)
export(TARGETS ${PROJECT_NAME} FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
export(PACKAGE ${PROJECT_NAME})

unset(_INCLUDE_DIRS)
unset(CMAKE_CONFIG_DESTINATION)

# Package for installation
set(_INCLUDE_DIRS "include")
set(CMAKE_CONFIG_DESTINATION "cmake")

configure_package_config_file(
  cmake/${PROJECT_NAME}Config.cmake.in
  "${CMAKE_INSTALL_PREFIX}/${CMAKE_CONFIG_DESTINATION}/${PROJECT_NAME}-config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}/${CMAKE_CONFIG_DESTINATION}
  PATH_VARS _INCLUDE_DIRS
)
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}
  LIBRARY DESTINATION  lib
  ARCHIVE DESTINATION  lib
  RUNTIME DESTINATION  bin
  INCLUDES DESTINATION ${_INCLUDE_DIRS}
)
install(EXPORT ${PROJECT_NAME} DESTINATION ${CMAKE_CONFIG_DESTINATION} FILE ${PROJECT_NAME}Targets.cmake)
install(
  FILES ${HDR_FILES} "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_export.h"
  DESTINATION include/${PROJECT_NAME}
)
if (${${PROJECT_NAME}_BUILD_SHARED})
  install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> DESTINATION bin CONFIGURATIONS Debug OPTIONAL)
endif()

unset(_INCLUDE_DIRS)
unset(CMAKE_CONFIG_DESTINATION)
