#!/bin/bash
# Fix the libnuma, libpcap, python six issue: 

export OVS_DIR=/usr/src/ovs
export DPDK_DIR=/usr/src/dpdk-16.07
export DPDK_TARGET=x86_64-native-linuxapp-gcc
export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET

cd $OVS_DIR
./boot.sh
./configure --with-dpdk=$DPDK_BUILD
make install
