cmake_minimum_required (VERSION 3.12.0)

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

option(libA_BUILD_SHARED "Build C++ SDK as dynamic library" ON)

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../libB ${CMAKE_CURRENT_BINARY_DIR}/libB EXCLUDE_FROM_ALL)

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
if (libA_BUILD_SHARED)
  add_library(${PROJECT_NAME} SHARED ${ALL_FILES})
else()
  add_library(${PROJECT_NAME} STATIC ${ALL_FILES})
endif()

# Dependencies
target_link_libraries(${PROJECT_NAME} libB)

# Export header
include(GenerateExportHeader)
generate_export_header(${PROJECT_NAME} EXPORT_FILE_NAME "${PROJECT_NAME}_export.h" DEFINE_NO_DEPRECATED)

# Include directories
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)

# Installation
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)
install(FILES ${HDR_FILES} "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_export.h"
  DESTINATION include/${PROJECT_NAME}
)
if (${libA_BUILD_SHARED})
  install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> DESTINATION lib CONFIGURATIONS Debug OPTIONAL)
endif()

# Package configuration file
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  COMPATIBILITY ExactVersion
)

# export(EXPORT ${PROJECT_NAME}Targets
  # FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake"
  # NAMESPACE ${PROJECT_NAME}::
# )