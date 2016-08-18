#!/bin/bash

modprobe vfio-pci
sudo /bin/chmod a+x /dev/vfio
sudo /bin/chmod 0666 /dev/vfio/*

DPDK_DIR=/usr/src/dpdk-16.07
$DPDK_DIR/tools/dpdk-devbind.py --bind=vfio-pci eno1
$DPDK_DIR/tools/dpdk-devbind.py --status