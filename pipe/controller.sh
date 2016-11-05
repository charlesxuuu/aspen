#!/bin/bash

bw_pipe="/tmp/bw_pipe"

bw_name="bw.sh"
bw_call="./bw.sh eno1"

if [[ ! -p $bw_pipe ]]; then
  echo "==> pipe for bw not exist"
  exit 1
fi

while :
do
  raw_res=`bash $bw_call`
  format=${bw_name}" : "${raw_res}
  echo $format > $bw_pipe
  sleep 1
done
