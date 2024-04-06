#!/bin/bash

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
ufw disable

/app/open5gs/install/bin/open5gs-upfd
