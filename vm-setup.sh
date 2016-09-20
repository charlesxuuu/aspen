#!/bin/bash

export VM_NAME=vhost-vm-test
export GUEST_MEM=1024M
export VM_IMAGE=/home/silvery/vm-img/ovs-dpdk-xenial0.qcow2
export CD_ROM=/home/silvery/vm-img/ubuntu-16.04.1-desktop-amd64.iso
export VHOST_SOCK_DIR=/usr/local/var/run/openvswitch

# taskset 0x20 qemu-system-x86_64 -name $VM_NAME -cpu host \
# -enable-kvm -m $GUEST_MEM \
# -object memory-backend-file,id=mem,size=$GUEST_MEM,mem-path=/dev/hugepages,share=on \
# -numa node,memdev=mem -mem-prealloc -smp sockets=1,cores=2 \
# -drive file=$QCOW2_IMAGE \
# -chardev socket,id=char0,path=$VHOST_SOCK_DIR/dpdkvhostuser0 \
# -netdev type=vhost-user,id=mynet1,chardev=char0,vhostforce \
# -device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1,mrg_rxbuf=off \
# -chardev socket,id=char1,path=$VHOST_SOCK_DIR/dpdkvhostuser1 \

# -netdev type=vhost-user,id=mynet2,chardev=char1,vhostforce \
# -device virtio-net-pci,mac=00:00:00:00:00:02,netdev=mynet2,mrg_rxbuf=off --nographic \
# -snapshot
# -cdrom $CD_ROM -boot d \

# sudo qemu-system-x86_64 -m $GUEST_MEM -name $VM_NAME -cpu host \
# -hda $VM_IMAGE \
# -cdrom $CD_ROM -boot d \
# -enable-kvm -no-reboot -net none \
# -chardev socket,id=char1,path=$VHOST_SOCK_DIR/dpdkvhostuser0 \
# -netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
# -device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1 \
# -object memory-backend-file,id=mem,size=$GUEST_MEM,mem-path=/dev/hugepages,share=on \
# -numa node,memdev=mem -mem-prealloc

sudo qemu-system-x86_64 -m $GUEST_MEM -name $VM_NAME -cpu host \
-hda $VM_IMAGE \
-enable-kvm -no-reboot -net none \
-chardev socket,id=char1,path=$VHOST_SOCK_DIR/dpdkvhostuser0 \
-netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1 \
-object memory-backend-file,id=mem,size=$GUEST_MEM,mem-path=/dev/hugepages,share=on \
-numa node,memdev=mem -mem-prealloc