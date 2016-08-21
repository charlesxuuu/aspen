OvS-DPDK Testbed
================

Overview
--------

Steps to setup:

* A host<->ovs-dpdk<->kvm testbed
* A host<->ovs-native<->kvm testbed
* A host<->linux-native<->kvm testbed

Prerequisites 
-------------

* OvS (Open vSwitch) built and installed
* OvS-DPDK built and installed

Details
-------

### host<->ovs-dpdk<->kvm

1. Use DPDK_SRC/tools/dpdk-setup.sh to configure dpdk
  1. Insert VFIO module
  2. Setup hugepage
  3. Bind devices
  4. Setup VFIO permissions

2. Start ovs-dpdk 
  * Run ./ovs-dpdk-init.sh

3. Start kvm:
  * Run ./vm-setup-ovs-dpdk.sh

### host<->ovs-native<->kvm

1. Start ovs-native:
  * Run ./ovs-native-init.sh

2. Start kvm:
  * Run ./vm-setup-ovs-native.sh

### host<->linux-native<->kvm