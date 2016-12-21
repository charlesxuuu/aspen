#!/bin/bash
# Fix the libnuma, libpcap, python six issue: 
sudo ln -s /usr/lib/x86_64-linux-gnu/libnuma.so.1 /usr/lib/x86_64-linux-gnu/libnuma.so
sudo ln -s /usr/lib/x86_64-linux-gnu/libpcap.so.0.8 /usr/lib/x86_64-linux-gnu/libpcap.so
pip install six
 
cd /usr/src/
git clone https://github.com/openvswitch/ovs.git

export OVS_DIR=/usr/src/ovs
export DPDK_DIR=/usr/src/dpdk-16.07
export DPDK_TARGET=x86_64-native-linuxapp-gcc
export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET

cd $OVS_DIR
./boot.sh
./configure --with-dpdk=$DPDK_BUILD
make install
