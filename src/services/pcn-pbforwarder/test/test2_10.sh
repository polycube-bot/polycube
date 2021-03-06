#!/bin/bash

source "${BASH_SOURCE%/*}/helpers.bash"

function pbfeanup {
  set +e
  del_pbforwarders 1
  del_veths 2
}
trap pbfeanup EXIT

set -x
set -e

TYPE="TC"

if [ -n "$1" ]; then
  TYPE=$1
fi

# setup
create_veth 2

polycubectl pbforwarder add pbf1 type=$TYPE

pbforwarder_add_port pbf1 veth1
pbforwarder_add_port pbf1 veth2

polycubectl pbforwarder pbf1 set loglevel=TRACE

# Add a bunch of not meaningful rules
pbforwarder_add_rules_l2 0 6 pbf1

# Get the MAC addresses of the namespaces
veth1_mac=`LANG=C sudo ip netns exec ns1 ifconfig -a | grep -Po 'HWaddr \K.*$'`
veth2_mac=`LANG=C sudo ip netns exec ns2 ifconfig -a | grep -Po 'HWaddr \K.*$'`

# Allows ns1->ns2 ARP Request
polycubectl pbforwarder pbf1 rules add 7 dst_mac=FF:FF:FF:FF:FF:FF action=FORWARD out_port=veth2

polycubectl pbforwarder pbf1 rules add 8 dst_mac=$veth1_mac action=FORWARD out_port=veth1

polycubectl pbforwarder pbf1 rules add 9 dst_mac=$veth2_mac action=FORWARD out_port=veth2

sudo ip netns exec ns1 ping 10.0.0.2 -c 2
