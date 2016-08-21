#!/bin/bash 
#
# One time setup:
# mkdir -p /usr/local/etc/openvswitch
# mkdir -p /usr/local/var/run/openvswitch
# rm /usr/local/etc/openvswitch/conf.db
# ovsdb-tool create /usr/local/etc/openvswitch/conf.db  \
#     /usr/local/share/openvswitch/vswitch.ovsschema

# Without SSL:
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
 --pidfile --detach

# With SSL:
# ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
#                      --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
#                      --private-key=db:Open_vSwitch,SSL,private_key \
#                      --certificate=db:Open_vSwitch,SSL,certificate \
#                      --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
#                      --pidfile --detach
# One time setup
# ovs-vsctl --no-wait init

# DB_SOCK=/usr/local/var/run/openvswitch/db.sock
# ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
# ovs-vswitchd unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach

DB_SOCK=/usr/local/var/run/openvswitch/db.sock
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
ovs-vswitchd unix:$DB_SOCK --pidfile --detach
