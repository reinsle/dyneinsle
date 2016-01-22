#!/usr/bin/env python3

from netifaces import AF_INET, AF_INET6, AF_LINK, AF_PACKET, AF_BRIDGE
import netifaces as ni

ni.interfaces()
ni.ifaddresses('eth0')[AF_LINK]
ni.ifaddresses('eth0')[AF_INET]
ni.ifaddresses('eth0')[AF_INET][0]['addr']
