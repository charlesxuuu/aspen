#!/bin/bash

ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk
ovs-vsctl add-port br0 dpdkvhostuser0 -- set Interface dpdkvhostuser0 type=dpdkvhostuser
ovs-vsctl add-port br0 dpdkvhostuser1 -- set Interface dpdkvhostuser1 type=dpdkvhostuser
