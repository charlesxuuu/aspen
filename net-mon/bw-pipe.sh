#!/bin/bash
# Format: bw-pipe -i [interface_name] -t [interval] -p [pipe_name]

IFACE="eno1"
INTVL=1
bw_pipe="/tmp/bw_pipe"
bw_info=""

while getopts "i:t:p:" opt; do
    case "$opt" in
    i)
        IFACE=$OPTARG
        ;;
    t)  INTVL=$OPTARG
        ;;
    p)  bw_pipe=$OPTARG
        ;;
    esac
done

read_bw() 
{
	# Obtain the measurements
	DATE=$(date +"%H:%M:%S")
	LINE_START=($(cat /proc/net/dev | grep $IFACE))
	sleep $INTVL
	LINE_END=($(cat /proc/net/dev | grep $IFACE))

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

	bw_info="$DATE $RECV_BW $SEND_BW $RECV_PKT_RATE $SEND_PKT_RATE"
}

trap "rm -f $bw_pipe" EXIT

# Create pipe
if [[ ! -p $bw_pipe ]]; then
  mkfifo $bw_pipe
fi

while true
do
  read_bw;
  echo $bw_info > $bw_pipe
done

