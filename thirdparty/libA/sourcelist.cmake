set(SRC_FILES src/libA.cpp)
set(HDR_FILES include/libA/libA.h)
set(ALL_FILES ${SRC_FILES} ${HDR_FILES} "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_export.h")
