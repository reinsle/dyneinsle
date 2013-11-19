#!/bin/bash
#
# Script zum Updaten der IP
#
# (c) Robert Einsle <robert@einsle.de>
#

VERBOSE=0

source /etc/dyneinsle/dyneinsle.conf

if [ "$ENABLED" != "1" ]
then
    exit 0
fi

if [ -z "$KEY" ]
then
    echo "Config-option KEY must be set!"
    exit 2
fi

if [ ! -r "$KEY" ]
then
    echo "Config-option KEY must be a readable file!"
    exit 2
fi

# Auslesen der Interfaces des Hosts
function get_interfaces() {
  echo `cat /proc/net/dev | grep : | grep -v lo | cut -d: -f1 | tr -d ' '`
}

# Auslesen einer IPv4-Adresse des uebergebenen Interfaces
function get_ip_of() {
  IF=$1
  echo `/sbin/ifconfig $IF | grep inet | grep -v inet6 | cut -d: -f2 | cut -d' ' -f1`
}

# Bestimmen der externen IP-Adresse
function get_external_ip() {
  echo `curl -4 --silent http://showip.spamt.net`
}

# Update des DNS-Servers
function update_dns() {
  NAME=$1
  IP=$2
  EXIST_IP=`host $1 | grep -v IPv6 | cut -d' ' -f4`
  if [ $VERBOSE -eq 1 ]; then
    printf "Upgrading %s using new IP: %s\n" "$NAME" "$IP"
  fi
  if [ "$IP" != "$EXIST_IP" ]
  then
    /usr/bin/nsupdate -k $KEY << EOF
server $NS_SERVER
update delete $NAME A
update add $NAME 60 A $IP
send
EOF
    logger -t dyneinsle "DNS-Record: $NAME: $IP changed, updating dns-record"
  else
    logger -t dyneinsle "DNS-Record: $NAME: $IP not changed, not updating"
  fi
}

function usage() {
cat << EOF
usage: $0 options

This script updates dynamic dns service using bind.

OPTIONS:
    -h    Show this help
    -v    Verbose

EOF
}

while getopts "hv" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        v)
            VERBOSE=1
            ;;
    esac
done

update_dns $ZONE `get_external_ip`
for IF in `get_interfaces`; do
    IF_IP=`get_ip_of $IF`
    if [ -n "$IF_IP" ]; then
        update_dns $IF.$ZONE $IF_IP
    fi
done
