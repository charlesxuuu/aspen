#!/bin/bash 
#
# One time setup:
# mkdir -p /usr/etc/openvswitch
# mkdir -p /usr/var/run/openvswitch
# rm /usr/etc/openvswitch/conf.db
# ovsdb-tool create /usr/etc/openvswitch/conf.db \
# /usr/share/openvswitch/vswitch.ovsschema

modprobe openvswitch

# Without SSL:
/usr/sbin/ovsdb-server --remote=punix:/var/run/openvswitch/db.sock \
 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
 --pidfile --detach

# With SSL:
# ovsdb-server --remote=punix:/usr/var/run/openvswitch/db.sock \
#                      --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
#                      --private-key=db:Open_vSwitch,SSL,private_key \
#                      --certificate=db:Open_vSwitch,SSL,certificate \
#                      --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
#                      --pidfile --detach
# One time setup:
# /usr/bin/ovs-vsctl --no-wait init

DB_SOCK=/var/run/openvswitch/db.sock
/usr/sbin/ovs-vswitchd unix:$DB_SOCK --pidfile --detach

