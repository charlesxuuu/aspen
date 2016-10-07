#!/bin/bash

if [ "$#" -eq 0 ]; then
echo "==> Please specify the video file."
exit
fi

vlc -vvv $1 --sout '#duplicate{dst=rtp{sdp=rtsp://:8554/live}}' --sout-keep
