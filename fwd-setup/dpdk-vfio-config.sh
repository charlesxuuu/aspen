#!/bin/bash
#Inputs: huge_page_size

SDK_DIR=/usr/src/dpdk-16.07

if [ "$#" == 0 ]; then
NIC_PCI_PATH=0000:01:00.1
else
NIC_PCI_PATH=$@
fi

HUGEPGSZ=`cat /proc/meminfo  | grep Hugepagesize | cut -d : -f 2 | tr -d ' '`
HUGEPGCOUNT=2048

export RTE_SDK=$SDK_DIR

load_vfio_module()
{
	remove_vfio_module

	VFIO_PATH="kernel/drivers/vfio/pci/vfio-pci.ko"

	echo "Loading VFIO module"
	/sbin/lsmod | grep -s vfio_pci > /dev/null
	if [ $? -ne 0 ] ; then
		if [ -f /lib/modules/$(uname -r)/$VFIO_PATH ] ; then
			sudo /sbin/modprobe vfio-pci
		fi
	fi

	# make sure regular users can read /dev/vfio
	echo "chmod /dev/vfio"
	sudo chmod a+x /dev/vfio
	if [ $? -ne 0 ] ; then
		echo "FAIL"
		quit
	fi
	echo "OK"

	# check if /dev/vfio/vfio exists - that way we
	# know we either loaded the module, or it was
	# compiled into the kernel
	if [ ! -e /dev/vfio/vfio ] ; then
		echo "## ERROR: VFIO not found!"
	fi
}

remove_vfio_module()
{
        echo "Unloading any existing VFIO module"
        /sbin/lsmod | grep -s vfio > /dev/null
        if [ $? -eq 0 ] ; then
                sudo /sbin/rmmod vfio-pci
                sudo /sbin/rmmod vfio_iommu_type1
                sudo /sbin/rmmod vfio
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

bind_nics_to_vfio()
{
	if [ -d /sys/module/vfio_pci ]; then
		${RTE_SDK}/tools/dpdk-devbind.py --status
		echo ""
		echo -n "Enter PCI address of device to bind to VFIO driver: "
		
		for nic in $NIC_PCI_PATH; do
		sudo ${RTE_SDK}/tools/dpdk-devbind.py -b vfio-pci $nic &&
			echo "OK"
		done
	else
		echo "# Please load the 'vfio-pci' kernel module before querying or "
		echo "# adjusting NIC device bindings"
	fi
}

set_vfio_permissions()
{
	# make sure regular users can read /dev/vfio
	echo "chmod /dev/vfio"
	sudo chmod a+x /dev/vfio
	if [ $? -ne 0 ] ; then
		echo "FAIL"
		quit
	fi
	echo "OK"

	# make sure regular user can access everything inside /dev/vfio
	echo "chmod /dev/vfio/*"
	sudo chmod 0666 /dev/vfio/*
	if [ $? -ne 0 ] ; then
		echo "FAIL"
		quit
	fi
	echo "OK"

	# since permissions are only to be set when running as
	# regular user, we only check ulimit here
	#
	# warn if regular user is only allowed
	# to memlock <64M of memory
	MEMLOCK_AMNT=`ulimit -l`

	if [ "$MEMLOCK_AMNT" != "unlimited" ] ; then
		MEMLOCK_MB=`expr $MEMLOCK_AMNT / 1024`
		echo ""
		echo "Current user memlock limit: ${MEMLOCK_MB} MB"
		echo ""
		echo "This is the maximum amount of memory you will be"
		echo "able to use with DPDK and VFIO if run as current user."
		echo -n "To change this, please adjust limits.conf memlock "
		echo "limit for current user."

		if [ $MEMLOCK_AMNT -lt 65536 ] ; then
			echo ""
			echo "## WARNING: memlock limit is less than 64MB"
			echo -n "## DPDK with VFIO may not be able to initialize "
			echo "if run as current user."
		fi
	fi
}

load_vfio_module
create_mnt_huge
remove_mnt_huge
clear_huge_pages
set_numa_pages
bind_nics_to_vfio
set_vfio_permissions
