#!/bin/bash
#
# Script zum Updaten der IP
#
# (c) Robert Einsle <robert@einsle.de>
#

source /etc/dyneinsle/dyneinsle.conf

# Auslesen der Interfaces des Hosts
function get_interfaces() {
  echo `cat /proc/net/dev | grep : | grep -v lo | cut -d: -f1 | tr -d ' '`
}

# Auslesen einer IPv4-Adresse des uebergebenen Interfaces
function get_ip_of() {
  IF=$1
  echo `ifconfig $IF | grep inet | grep -v inet6 | cut -d: -f2 | cut -d' ' -f1`
}

# Bestimmen der externen IP-Adresse
function get_external_ip() {
  echo `curl --silent http://showip.spamt.net`
}

# Update des DNS-Servers
function update_dns() {
  NAME=$1
  IP=$2
  /usr/bin/nsupdate -k $KEY << EOF
server ns-dyn.einsle.de
update delete $NAME A
update add $NAME 60 A $IP
send
EOF
  logger -t dyneinsle "DNS-Record $NAME using ip $IP updated"
}

update_dns $ZONE `get_external_ip`
for IF in `get_interfaces`; do
    IF_IP=`get_ip_of $IF`
    if [ -n "$IF_IP" ]; then
        update_dns $IF.$ZONE $IF_IP
    fi
done
