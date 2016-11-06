#!/bin/bash
#
# Append additional parameters behind the script
# e.g., vm-setup-x-x.sh -
# The default user name is dpdk-ovs0

if [ "$#" -eq 0 ]; then
echo "==> You may append more parameters for qemu."
fi

VM_NAME=ovs-native-xenial0
GUEST_MEM=1024M
VM_IMAGE=/home/silvery/vm-img/ovs-native-xenial0.qcow2
CD_ROM=/home/silvery/vm-img/ubuntu-16.04.1-desktop-amd64.iso
VHOST_SOCK_DIR=/usr/local/var/run/openvswitch

sudo echo "=> Lauching VM..."

sudo qemu-system-x86_64 -m $GUEST_MEM -name $VM_NAME -cpu host \
-hda $VM_IMAGE \
-enable-kvm -no-reboot \
-netdev tap,id=vnic1,vhost=on \
-device virtio-net-pci,netdev=vnic1,mac=00:00:00:00:00:01 $@

# -net nic,macaddr=00:00:00:00:00:02 \
# -net tap,vhost=on # Manually add the tap device to the ovs


# -net tap,script=/home/silvery/ovs-dpdk-build/ovs-native-ifup,downscript=/home/silvery/ovs-dpdk-build/ovs-native-ifdown 
# -netdev type=tap,script=/etc/ovs-ifup,downscript=/etc/ovs-ifdown,id=vnic1,vhost=on -device virtio-net-pci,netdev=vnic1,mac=00:00:00:00:00:02

echo "=> $VM_NAME up."
