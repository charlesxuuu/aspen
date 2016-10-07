#!/bin/bash

if [ "$#" -eq 0 ]; then
echo "==> Please specify the destination IP."
exit
fi

iptables -A PREROUTING -t nat -j DNAT --to $1
