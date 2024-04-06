#!/bin/bash

ip netns add tun_ue
sleep 5
ip netns list

/app/srsRAN_4G/build/srsue/src/srsue \
    --rf.device_name=zmq \
    --rf.device_args='tx_port=tcp://192.168.128.5:2001,rx_port=tcp://192.168.128.6:2000,id=ue,base_srate=23.04e6' \
    --gw.netns=tun_ue \
    /app/ue.conf 2>&1 &

echo "sleeping"
sleep 40
echo "sleep ended"
ip netns exec tun_ue ip route add default via 10.45.0.1
ip netns exec tun_ue ping 8.8.8.8

# test download big file
# ip netns exec tun_ue curl -L -k https://185.125.190.40/22.04.4/ubuntu-22.04.4-desktop-amd64.iso -H "Host: releases.ubuntu.com" >/tmp/toto
ip netns exec tun_ue curl -L -k https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-desktop-amd64.iso >/tmp/toto
