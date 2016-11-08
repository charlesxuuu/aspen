cmake_minimum_required(VERSION 3.6)
project(aspen-agent)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DDEBUG")

set(SOURCE_FILES
    aspen-agent-collector.cc
    aspen-agent-collector.h
    aspen-agent-config.h
    aspen-agent-main.cc
    aspen-agent-power-tuner.cc
    aspen-agent-power-tuner.h
    aspen-agent.h)

add_executable(aspen-agent ${SOURCE_FILES})