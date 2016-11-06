#!/bin/bash

VERSION=v2.0.6
RELEASE=hsflowd-ubuntu14_2.0.6-1_amd64.deb
URL=https://github.com/sflow/host-sflow/releases/download/$VERSION/$RELEASE
LOC=./

wget $URL
sudo dpkg -i $RELEASE
sudo systemctl enable hsflowd # or update-rc.d hsflowd defaults
sudo vi /etc/hsflowd.conf
