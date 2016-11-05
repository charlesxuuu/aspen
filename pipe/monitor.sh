#!/bin/bash

bw_pipe="/tmp/bw_pipe"

output="./output.txt"

# recevied EXIT signal, clean pipe
trap "rm -f $bw_pipe" EXIT

echo "==> monitor start"

if [[ ! -p $bw_pipe ]]; then
  echo "==> build bw_pipe"
  mkfifo $bw_pipe
fi

while true
do
  if read line < $bw_pipe; then
    echo "==> rcv from bw_pipe"
    echo $line >> $output
  fi
done

echo "monitor exit"
