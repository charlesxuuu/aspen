#!/bin/bash

prev_time=0
frame_time=0.04
sudo cpufreq-set -f 1.60GHz -c 0
while IFS='' read -r line || [[ -n "$line" ]]; do
	vars=($line)
	time=${vars[0]}
	echo $(echo "$time - $prev_time - $frame_time" | bc)
	sleep $(echo "$time - $prev_time - $frame_time" | bc) 
	sudo cpufreq-set -f 3.40GHz -c 0
	sleep $frame_time
	sudo cpufreq-set -f 1.60GHz -c 0
	prev_time=$time
done < policy.csv
