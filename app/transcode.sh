#!/bin/bash
# Usage: video.sh SERVER_URL PLAY_COUNTS

if [ "$#" -eq 0 ]; then
echo "==> Please specify the video source url."
exit
fi

pkill ffserver
ffserver -f /etc/ffserver.conf &
ffmpeg -i $1 http://localhost:8090/feed1.ffm 
