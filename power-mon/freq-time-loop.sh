#!/bin/bash

if [ "$#" -eq 0 ]; then
echo "==> Please specify the core."
exit
fi

while true; do echo $(date +"%H:%M:%S") $(bash freq.sh $1); sleep 1; done

