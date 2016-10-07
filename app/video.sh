#!/bin/bash
# Usage: video.sh SERVER_URL PLAY_COUNTS

URL=$1
COUNT=$2


ffplay $1 -nodisp &