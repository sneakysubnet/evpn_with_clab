#!/bin/sh

ip link add VRF_A type vrf table 1000
ip link set VRF_A up

ip link add br0 type bridge vlan_filtering 1 vlan_default_pvid 0
ip link set br0 addrgenmode none

ip link add vxlan0 type vxlan local 172.16.1.1 dstport 4789 nolearning external
ip link set vxlan0 master br0 addr 00:11:11:11:11:11

ip link set br0 up
ip link set vxlan0 up

bridge link set dev vxlan0 vlan_tunnel on neigh_suppress on learning off

bridge vlan add dev br0 vid 10 self
bridge vlan add dev vxlan0 vid 10
bridge vlan add dev vxlan0 vid 10 tunnel_info id 10010

bridge vlan add dev br0 vid 20 self
bridge vlan add dev vxlan0 vid 20
bridge vlan add dev vxlan0 vid 20 tunnel_info id 10020

bridge vlan add dev br0 vid 4000 self
bridge vlan add dev vxlan0 vid 4000
bridge vlan add dev vxlan0 vid 4000 tunnel_info id 10100

ip link add vlan4000 link br0 type vlan id 4000
ip link set vlan4000 address 00:11:11:11:11:11 addrgenmode none master VRF_A up

ip link add vlan10 link br0 type vlan id 10
ip link set vlan10 master VRF_A
ip link set vlan10 up

ip link add vlan20 link br0 type vlan id 20
ip link set vlan20 master VRF_A
ip link set vlan20 up


ip link add vlan10agw link vlan10 type macvlan mode private
ip link set vlan10agw address 00:88:88:88:88:88
ip addr add 10.10.10.1/24 dev vlan10agw
ip link set vlan10agw up
ip link set dev vlan10agw master VRF_A


ip link add vlan20agw link vlan20 type macvlan mode private
ip link set vlan20agw address 00:88:88:88:88:88
ip addr add 10.20.20.1/24 dev vlan20agw
ip link set vlan20agw up
ip link set dev vlan20agw master VRF_A

ip link set dev eth1 master br0
ip link set dev eth2 master br0
bridge vlan add dev eth2 vid 20 pvid untagged
bridge vlan add dev eth1 vid 10 pvid untagged

bridge fdb add 00:88:88:88:88:88 dev br0 self local

sysctl -w net.ipv4.conf.all.arp_accept=1
