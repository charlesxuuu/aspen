#/bin/bash

mkdir -p /usr/local/etc/openvswitch
mkdir -p /usr/local/var/run/openvswitch
rm /usr/local/etc/openvswitch/conf.db
ovsdb-tool create /usr/local/etc/openvswitch/conf.db  \
/usr/local/share/openvswitch/vswitch.ovsschema
