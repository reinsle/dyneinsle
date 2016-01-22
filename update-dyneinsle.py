#!/usr/bin/env python3

from netifaces import AF_INET, AF_INET6, AF_LINK, AF_PACKET, AF_BRIDGE
import netifaces as ni

#ifaces = ni.interfaces()
#print(ifaces)
#ni.ifaddresses('eth0')[AF_LINK]
#ni.ifaddresses('eth0')[AF_INET]
#ni.ifaddresses('eth0')[AF_INET][0]['addr']

def get_if_list(exclude_if=None):
    """
    Reads list of interfaces and returns it. If exclude_id is set, interfaces are removed from list.

    Parameters:
      exclude_id - remove this interfaces from list of returned values.
    """
    ifaces = ni.interfaces()
    if exclude_if is not None:
        for ex_if in exclude_if:
            try:
                ifaces.remove(ex_if)
            except ValueError:
                pass
    return ifaces

if __name__ == "__main__":
    print(get_if_list(['lo', 'en0']))
