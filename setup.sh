#!/bin/bash

MININET_BRIDGE='s1'
EXTERNAL_BRIDGE='lbr-ex'

# Create bridge to outside world
brctl addbr ${EXTERNAL_BRIDGE}
ip a add 10.0.0.100/8 dev ${EXTERNAL_BRIDGE}
ip l set dev ${EXTERNAL_BRIDGE} up

# Create veth pair
ip l add name veth0 type veth peer name veth1
ip l set dev veth0 up
ip l set dev veth1 up

# Connect ovs and linux bridges
brctl addif ${EXTERNAL_BRIDGE} veth0
ovs-vsctl add-port ${MININET_BRIDGE} veth1

# Create rules in iptables
iptables -A INPUT -p udp -i ${EXTERNAL_BRIDGE} --dport 53 -j ACCEPT # DNS
iptables -A INPUT -p tcp -i ${EXTERNAL_BRIDGE} --dport 53 -j ACCEPT # DNS
iptables -A INPUT -p udp -i ${EXTERNAL_BRIDGE} --dport 67 -j ACCEPT # BOOTP
iptables -A INPUT -p tcp -i ${EXTERNAL_BRIDGE} --dport 67 -j ACCEPT # BOOTP

iptables -A FORWARD -p all -o ${EXTERNAL_BRIDGE} -d 10.0.0.0/8 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p all -i ${EXTERNAL_BRIDGE} -s 10.0.0.0/8 -j ACCEPT
iptables -A FORWARD -p all -i ${EXTERNAL_BRIDGE} -o ${EXTERNAL_BRIDGE} -j ACCEPT
iptables -A FORWARD -p all -o ${EXTERNAL_BRIDGE} -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -p all -i ${EXTERNAL_BRIDGE} -j REJECT --reject-with icmp-port-unreachable

iptables -A OUTPUT -o ${EXTERNAL_BRIDGE} -p udp -m udp --dport 68 -j ACCEPT

