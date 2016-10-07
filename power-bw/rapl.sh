#!/bin/bash

IFACE=$1

# Obtain the measurements
DATE=$(date +"%H:%M:%S")
POWER=$(./rapl-read-quiet)

echo $DATE $POWER
