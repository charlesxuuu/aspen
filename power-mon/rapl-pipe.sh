#!/bin/bash

INTVL=1
power_pipe="/tmp/rapl_pipe"
power_info=""

while getopts "t:p:" opt; do
    case "$opt" in
    t)  INTVL=$OPTARG
        ;;
    p)  power_pipe=$OPTARG
        ;;
    esac
done

read_power() 
{
	# Obtain the measurements
	DATE=$(date +"%H:%M:%S")
	POWER=$(./rapl-read-quiet)

	power_info="$DATE $POWER"
}

trap "rm -f $power_pipe" EXIT

# Create pipe
if [[ ! -p $power_pipe ]]; then
  mkfifo $power_pipe
fi

while true
do
  read_power;
  echo $power_info > $power_pipe
done