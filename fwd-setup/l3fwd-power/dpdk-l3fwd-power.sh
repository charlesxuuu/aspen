#!/bin/bash

export RTE_SDK=/usr/src/dpdk-16.07
cd ${RTE_SDK}/examples/l3fwd-power
export RTE_TARGET=x86_64-native-linuxapp-gcc
make
