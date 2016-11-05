#!/bin/bash

pipe="./tp"

# recevied EXIT signal, clean pipe
trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
  mkfifo $pipe
fi

while true
do
  if read line < $pipe; then
    if [[ "$line" == 'quit' ]]; then
      break
    fi
    echo $line
  fi
done

echo "Reader exit"
