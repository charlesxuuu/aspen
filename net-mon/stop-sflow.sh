#!/bin/bash

sudo ovs-vsctl remove bridge ovsbr1 sflow $SFLOWUUID
sudo ovs-vsctl -- clear Bridge ovsbr1 sflow
sudo ovs-vsctl list sflow