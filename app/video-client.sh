#!/bin/bash
# Usage: video.sh SERVER_URL PLAY_COUNTS

URL=$1
COUNT=$2

for (( i=1; i<=$COUNT; i++ ))
do
#ffplay $1 -nodisp &
sleep 10
echo one
done
