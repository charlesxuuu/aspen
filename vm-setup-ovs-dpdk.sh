#!/bin/bash
#
# Append additional parameters behind the script
# e.g., vm-setup-x-x.sh -
# The default user name is dpdk-ovs0

VM_NAME=ovs-dpdk-xenial0
GUEST_MEM=1024M
VM_IMAGE=/home/silvery/vm-img/ovs-native-xenial0.qcow2
CD_ROM=/home/silvery/vm-img/ubuntu-16.04.1-desktop-amd64.iso
VHOST_SOCK_DIR=/usr/local/var/run/openvswitch

sudo echo "=> Lauching VM..."

sudo qemu-system-x86_64 -m $GUEST_MEM -name $VM_NAME -cpu host \
-hda $VM_IMAGE \
-enable-kvm -no-reboot -net none \
-chardev socket,id=char1,path=$VHOST_SOCK_DIR/dpdkvhostuser0 \
-netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1 \
-object memory-backend-file,id=mem,size=$GUEST_MEM,mem-path=/dev/hugepages,share=on \
-numa node,memdev=mem -mem-prealloc \
$@ &

# sudo qemu-system-x86_64 -m $GUEST_MEM -name $VM_NAME -cpu host \
# -hda $VM_IMAGE \
# -enable-kvm -no-reboot \
# -netdev tap,id=vnic1,vhost=on \
# -device virtio-net-pci,netdev=vnic1,mac=00:00:00:00:00:07


echo "=> $VM_NAME up."