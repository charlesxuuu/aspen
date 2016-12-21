#!/bin/bash

cd /usr/src/
wget http://dpdk.org/browse/dpdk/snapshot/dpdk-16.07.zip
unzip dpdk-16.07.zip

export DPDK_DIR=/usr/src/dpdk-16.07
cd $DPDK_DIR

export DPDK_TARGET=x86_64-native-linuxapp-gcc
export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
make install T=$DPDK_TARGET DESTDIR=install

sudo modprobe uio
sudo insmod $DPDK_BUILD/kmod/igb_uio.ko
