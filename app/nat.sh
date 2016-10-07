#!/bin/bash

if [ "$#" -le 2 ]; then
echo "==> Please specify the interface, source and destination IP."
exit
fi

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE
iptables -A PREROUTING -t nat -d $2 -j DNAT --to $3
