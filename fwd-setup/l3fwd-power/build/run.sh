#!/bin/bash

./l3fwd-power -c 03 -n 2 -- -p 0x3 --config="(0,0,0),(0,1,1),(1,0,1),(1,1,1)" $@
