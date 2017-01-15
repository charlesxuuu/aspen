Setup
==

To build:

1. build.sh, dpdk-[vfio|uio]-config.sh NIC_1...N_PCI_ADDR

Or:

1. Run build-tool.sh, dpdk-build.sh
2. ovs-build-on-dpdk.sh
3. dpdk-config.sh # Use dpdk-config-manual to check the NIC's PCI address

To start:

1. (First time) ovs-db-setup.sh
2. dpdk-[vfio|uio]-config.sh, ovs-dpdk-init.sh
3. ovs-dpdk-config.sh

Note: You may need to change the locked memory size in the host: /etc/security/limits.conf
