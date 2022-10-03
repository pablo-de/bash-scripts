#!/bin/bash

#PING A GOOGLE
google=$(ping -qc1 8.8.8.8 2>&1 | awk -F'/' 'END{ print (/^rtt/? "OK ("$5" ms) ":"FAIL") }')

echo "Ping a google: $google"

#PING A GATEWAY
gateway=$(ip r | awk '/^def/{print $3}')
ping=$(ping -qc1 $gateway 2>&1 | awk -F'/' 'END{ print (/^rtt/? "OK ("$5 " ms)":"FAIL") }')

echo "Ping a gateway: $gateway" "$ping"

#IP LOCAL
IPv4=$(hostname -I | awk '{print $1}')

echo "IP: $IPv4"

#IP PUBLIC
public_ip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')

echo "IP PUBLICA: $public_ip"