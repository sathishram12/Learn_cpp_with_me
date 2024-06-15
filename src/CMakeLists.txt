# Include directories (if any)
include_directories(${CMAKE_SOURCE_DIR}/src/include)

add_library(DivisionLib division/division.cpp)

add_executable(calculator calculator.cpp division/division.cpp)

if(${ENABLE_WARNINGS})
    target_set_warnings(TARGET ${EXECUTABLE_NAME} ENABLE ON AS_ERROR OFF)
endif()