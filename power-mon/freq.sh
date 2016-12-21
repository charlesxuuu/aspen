#!/bin/bash
# Gives current cpu frequency

if [ "$#" == 0 ]; then
	CORE=0
else
	CORE=$1
fi

cpufreq-info -c $CORE | grep "asserted" | awk '{print $5}'
