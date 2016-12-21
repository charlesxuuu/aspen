#!/bin/bash

ffprobe -show_frames bbb_sunflower_1080p_30fps_normal.mp4 | grep video -A 15 | grep key_frame=0 -A 15 | grep pkt_dts_time > time.log &
ffprobe -show_frames bbb_sunflower_1080p_30fps_normal.mp4 | grep video -A 15 | grep key_frame=0 -A 15 | grep pkt_size > pkt_size.log

