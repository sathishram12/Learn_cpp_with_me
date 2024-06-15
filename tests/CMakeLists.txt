if(ENABLE_TESTING)
    enable_testing()

    set(TEST_MAIN "unit_tests")
    set(TEST_SOURCES "calculator_test.cpp")

    add_executable(${TEST_MAIN} ${TEST_SOURCES})
    
    # Include directories for the tests
    target_include_directories(${TEST_MAIN} PRIVATE ${CMAKE_SOURCE_DIR}/src/include)
    
    target_link_libraries(${TEST_MAIN} 
        PRIVATE
            DivisionLib
            GTest::gtest_main)

    include(GoogleTest)
    gtest_discover_tests(${TEST_MAIN})

    if(${ENABLE_WARNINGS})
        target_set_warning(TARGET ${TEST_MAIN} ENABLE ON AS_ERROR OFF)
    endif()

    find_program(LCOV_PATH lcov)
    if(ENABLE_COVERAGE)
        if(NOT LCOV_PATH)
            message(FATAL_ERROR "lcov not found! Aborting...")
        endif()
        
        set(COVERAGE_MAIN "coverage")
        set(COVERAGE_EXCLUDES
            "${PROJECT_SOURCE_DIR}/cmake/*"
            "${PROJECT_SOURCE_DIR}/docs/*"
            "${PROJECT_SOURCE_DIR}/external/*"
            "${PROJECT_SOURCE_DIR}/tests/*"
            "*/gtest/*"
            "/usr/include/*"
            )
        setup_target_for_coverage_lcov(
            NAME ${COVERAGE_MAIN}
            EXECUTABLE ${TEST_MAIN}
            DEPENDENCIES ${TEST_MAIN})
    endif()

endif()