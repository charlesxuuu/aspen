#!/bin/bash

if [ "$#" -eq 0 ]; then 
echo "==> Please specify the interface."
exit
fi

IFACE=$1

# Obtain the measurements
DATE=$(date +"%H:%M:%S")
POWER=$(./rapl-read-quiet)

echo $DATE $POWER
