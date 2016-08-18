#!/bin/bash
# Usage: `./ovs-dpdk-env.sh`

echo export DPDK_DIR=/usr/src/dpdk-16.07
echo export DPDK_TARGET=x86_64-native-linuxapp-gcc
echo export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
echo export OVS_DIR=/usr/src/ovs