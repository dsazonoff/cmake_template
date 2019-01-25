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

option(${PROJECT_NAME}_BUILD_SHARED "Build C++ SDK as dynamic library" ON)

# Temporary, for debug
set(libA_BUILD_SHARED ON)
set(libB_BUILD_SHARED OFF)

# Temporary cratch to prevent recursion
if (${PROJECT_NAME} STREQUAL "libA")
  add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../libB ${CMAKE_CURRENT_BINARY_DIR}/libB EXCLUDE_FROM_ALL)
endif()

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

# Dependencies
# Temporary cratch to prevent recursion
if (${PROJECT_NAME} STREQUAL "libA")
  target_link_libraries(${PROJECT_NAME} libB)
endif()

# Include directories
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
target_include_directories(${PROJECT_NAME} INTERFACE
  $<INSTALL_INTERFACE:include/${PROJECT_NAME}>
)

# Export header
include(GenerateExportHeader)
generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME "${PROJECT_NAME}_export.h" DEFINE_NO_DEPRECATED)

# Installation
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION  ${PROJECT_NAME}/lib
  ARCHIVE DESTINATION  ${PROJECT_NAME}/lib
  RUNTIME DESTINATION  ${PROJECT_NAME}/lib
  INCLUDES DESTINATION ${PROJECT_NAME}/include
)
install(FILES ${HDR_FILES} "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_export.h"
  DESTINATION ${PROJECT_NAME}/include/${PROJECT_NAME}
)
if (${${PROJECT_NAME}_BUILD_SHARED})
  install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> DESTINATION ${PROJECT_NAME}/lib CONFIGURATIONS Debug OPTIONAL)
endif()

# Package configuration file
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  COMPATIBILITY ExactVersion
)
export(EXPORT ${PROJECT_NAME}Targets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake"
  NAMESPACE ${PROJECT_NAME}::
)
set(INCLUDE_INSTALL_DIR ${PROJECT_NAME}/include)
set(LIB_INSTALL_DIR ${PROJECT_NAME}/lib)
configure_package_config_file(cmake/${PROJECT_NAME}Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${PROJECT_NAME}/cmake
  PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${PROJECT_NAME}/cmake
)