#!/bin/bash

# SFLOW config
COLLECTOR_IP=127.0.0.1
COLLECTOR_PORT=6343
AGENT_IP=lo
HEADER_BYTES=128
SAMPLING_N=64
POLLING_SECS=1

# OvS config
BRIDGE_NAME=br0

UUID=$(sudo ovs-vsctl -- --id=@sflow create sflow agent=${AGENT_IP}  \
target=\"${COLLECTOR_IP}:${COLLECTOR_PORT}\" header=${HEADER_BYTES} \
sampling=${SAMPLING_N} polling=${POLLING_SECS} \
-- set bridge $BRIDGE_NAME sflow=@sflow)

echo $UUID


