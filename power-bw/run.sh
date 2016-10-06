#!/bin/bash

./rapl-bw-read &
ifstat -i eno1 1 1 &
date +"%H:%M:%S"



wait
