#!/bin/bash

#Inputs: NIC PCI addresses

SDK_DIR=/usr/src/dpdk-16.07

if [ "$#" == 0 ]; then
NIC_PCI_PATH=0000:01:00.1
else
NIC_PCI_PATH=$@
fi

HUGEPGSZ=`cat /proc/meminfo  | grep Hugepagesize | cut -d : -f 2 | tr -d ' '`
HUGEPGCOUNT=2048

export RTE_SDK=$SDK_DIR

load_igb_uio_module()
{
	if [ ! -f $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko ];then
		echo "## ERROR: Target does not have the DPDK UIO Kernel Module."
		echo "       To fix, please try to rebuild target."
		return
	fi

	remove_igb_uio_module

	/sbin/lsmod | grep -s uio > /dev/null
	if [ $? -ne 0 ] ; then
		modinfo uio > /dev/null
		if [ $? -eq 0 ]; then
			echo "Loading uio module"
			sudo /sbin/modprobe uio
		fi
	fi

	# UIO may be compiled into kernel, so it may not be an error if it can't
	# be loaded.

	echo "Loading DPDK UIO module"
	sudo /sbin/insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko
	if [ $? -ne 0 ] ; then
		echo "## ERROR: Could not load kmod/igb_uio.ko."
		quit
	fi
}

set_numa_pages()
{
	clear_huge_pages

	echo ""
	echo "  Input the number of ${HUGEPGSZ} hugepages for each node"
	echo "  Example: to have 128MB of hugepages available per node in a 2MB huge page system,"
	echo "  enter '64' to reserve 64 * 2MB pages on each node"

	echo > .echo_tmp
	for d in /sys/devices/system/node/node? ; do
		node=$(basename $d)
		echo -n "Number of pages for $node: "
		echo "echo $HUGEPGCOUNT > $d/hugepages/hugepages-${HUGEPGSZ}/nr_hugepages" >> .echo_tmp
	done
	echo "Reserving hugepages"
	sudo sh .echo_tmp
	rm -f .echo_tmp

	create_mnt_huge
}

create_mnt_huge()
{
	echo "Creating /mnt/huge and mounting as hugetlbfs"
	sudo mkdir -p /mnt/huge

	grep -s '/mnt/huge' /proc/mounts > /dev/null
	if [ $? -ne 0 ] ; then
		sudo mount -t hugetlbfs nodev /mnt/huge
	fi
}

clear_huge_pages()
{
	echo > .echo_tmp
	for d in /sys/devices/system/node/node? ; do
		echo "echo 0 > $d/hugepages/hugepages-${HUGEPGSZ}/nr_hugepages" >> .echo_tmp
	done
	echo "Removing currently reserved hugepages"
	sudo sh .echo_tmp
	rm -f .echo_tmp

	remove_mnt_huge
}

remove_mnt_huge()
{
	echo "Unmounting /mnt/huge and removing directory"
	grep -s '/mnt/huge' /proc/mounts > /dev/null
	if [ $? -eq 0 ] ; then
		sudo umount /mnt/huge
	fi

	if [ -d /mnt/huge ] ; then
		sudo rm -R /mnt/huge
	fi
}

bind_nics_to_igb_uio()
{
	if [ -d /sys/module/igb_uio ]; then
		${RTE_SDK}/tools/dpdk-devbind.py --status
		echo ""
		for nic in $NIC_PCI_PATH; do
			sudo ${RTE_SDK}/tools/dpdk-devbind.py -b igb_uio $nic && echo "OK"
		done
	else
		echo "# Please load the 'igb_uio' kernel module before querying or "
		echo "# adjusting NIC device bindings"
	fi
}

load_igb_uio_module
create_mnt_huge
remove_mnt_huge
clear_huge_pages
set_numa_pages
bind_nics_to_igb_uio
