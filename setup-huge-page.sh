#!/bin/bash

echo 'vm.nr_hugepages=2048' > /etc/sysctl.d/hugepages.conf

# To allocate: sysctl -w vm.nr_hugepages=N
grep HugePages_ /proc/meminfo

# To mount if not mounted: mount -t hugetlbfs none /dev/hugepages