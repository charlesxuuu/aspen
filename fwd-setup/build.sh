#!/bin/bash

sudo bash build-tool.sh && \
	bash dpdk-build.sh && \
	bash ovs-build-on-dpdk.sh
