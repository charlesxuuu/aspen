#!/bin/bash
# Usage: video.sh SERVER_URL PLAY_COUNTS

if [ "$#" -eq 0 ]; then
echo "==> Please specify the server url, loop count (default 1), \
and step count (default 10)."
exit
fi

if [[ -z "$2" ]]; then
COUNT=1
else
COUNT=$2
fi

if [[ -z "$3" ]]; then
STEP=10
else
STEP=$3
fi

URL=$1

for (( i=0; i<=$COUNT; i++ )); do
	if [ "$i" -eq 0 ]; then
		ffplay $1 -nodisp &
		echo "==> Start session 0."
		sleep 10
		continue
	fi
	for (( j=1; j<=$STEP; j++ )); do
		ffplay $1 -nodisp &
	done
	echo "==> Start session Loop $i, Step $STEP."
	sleep 10
done
