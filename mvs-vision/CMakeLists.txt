cmake_minimum_required(VERSION 3.9)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(framesync)

# Options
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")

set(SUPER_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../..)

set(LIBRARY_DIR ${SUPER_PROJECT_DIR}/libs CACHE PATH "Path to libs folder")
set(SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src CACHE PATH "Path to src folder")

set(OpenCV_DIR /usr/local/lib/cmake/opencv4 CACHE PATH "Path to OpenCV folder")
set(Eigen3_DIR /usr/local/share/eigen3/cmake CACHE PATH "Path to installed Eigen")
set(Spdlog_DIR /usr/local/lib/cmake/spdlog CACHE PATH "Path to install spdlog")

find_package(OpenCV REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(Spdlog REQUIRED)
include_directories( ${OpenCV_INCLUDE_DIRS})

include(FetchContent)

FetchContent_Declare(
        yaml-cpp
        GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
        GIT_TAG master # Can be a tag (yaml-cpp-x.x.x), a commit hash, or a branch name (master)
)
FetchContent_GetProperties(yaml-cpp)

if(NOT yaml-cpp_POPULATED)
    message(STATUS "Fetching yaml-cpp...")
    FetchContent_Populate(yaml-cpp)
    add_subdirectory(${yaml-cpp_SOURCE_DIR} ${yaml-cpp_BINARY_DIR})
endif()

set(HEADER_FILES 
    ${SOURCE_DIR}/FSImage.h
    ${SOURCE_DIR}/FSUtils.h
    
)

set(SOURCE_FILES 
    ${SOURCE_DIR}/FSImage.cpp
    ${SOURCE_DIR}/FSUtils.cpp
)


add_executable(${PROJECT_NAME} ${SOURCE_DIR}/main.cpp ${HEADER_FILES} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME}
    ${OpenCV_LIBS} 
    Eigen3::Eigen 
    yaml-cpp::yaml-cpp 
    spdlog::spdlog
)