#!/bin/bash

if [ "$#" -eq 0 ]; then 
echo "==> Please specify the interface."
exit
fi

IFACE=$1

# Obtain the measurements
DATE=$(date +"%H:%M:%S")
LINE_START=($(cat /proc/net/dev | grep $1))
sleep 1
LINE_END=($(cat /proc/net/dev | grep $1))

# Start the calculation
RECV_START=${LINE_START[1]}
RECV_END=${LINE_END[1]}
RECV_BW=$(($RECV_END - $RECV_START))

SEND_START=${LINE_START[9]}
SEND_END=${LINE_END[9]}
SEND_BW=$(($SEND_END - $SEND_START))

RECV_PKT_START=${LINE_START[2]}
RECV_PKT_END=${LINE_END[2]}
RECV_PKT_RATE=$(($RECV_PKT_END - $RECV_PKT_START))

SEND_PKT_START=${LINE_START[10]}
SEND_PKT_END=${LINE_END[10]}
SEND_PKT_RATE=$(($SEND_PKT_END - $SEND_PKT_START))

echo $DATE $RECV_BW $SEND_BW $RECV_PKT_RATE $SEND_PKT_RATE
