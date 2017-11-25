#!/bin/bash

EXTERNAL_BRIDGE='lbr-ex'

# Destroy linux bridge
ip l set dev ${EXTERNAL_BRIDGE} down
brctl delbr ${EXTERNAL_BRIDGE}

# Destroy veth
ip l set dev veth0 down
ip l del dev veth0

# Clean iptables rules
iptables -D INPUT -p udp -i ${EXTERNAL_BRIDGE} --dport 53 -j ACCEPT
iptables -D INPUT -p tcp -i ${EXTERNAL_BRIDGE} --dport 53 -j ACCEPT 
iptables -D INPUT -p udp -i ${EXTERNAL_BRIDGE} --dport 67 -j ACCEPT 
iptables -D INPUT -p tcp -i ${EXTERNAL_BRIDGE} --dport 67 -j ACCEPT 

iptables -D FORWARD -p all -o ${EXTERNAL_BRIDGE} -d 10.0.0.0/8 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -D FORWARD -p all -i ${EXTERNAL_BRIDGE} -s 10.0.0.0/8 -j ACCEPT
iptables -D FORWARD -p all -i ${EXTERNAL_BRIDGE} -o ${EXTERNAL_BRIDGE} -j ACCEPT
iptables -D FORWARD -p all -o ${EXTERNAL_BRIDGE} -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -p all -i ${EXTERNAL_BRIDGE} -j REJECT --reject-with icmp-port-unreachable

iptables -D OUTPUT -o ${EXTERNAL_BRIDGE} -p udp -m udp --dport 68 -j ACCEPT
