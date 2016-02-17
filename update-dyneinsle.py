#!/usr/bin/env python3

from netifaces import AF_INET
import netifaces as ni


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


def get_ip_of(if_name):
    """
    Returns ip4 address of interface given by if_name.

    Parameters:
      if_name - name of interface to return ip4 address
    """
    if ni.ifaddresses(if_name)[AF_INET]:
        if_ip_addr = ni.ifaddresses(if_name)[AF_INET][0]['addr']
        return if_ip_addr
    else:
        return None


if __name__ == "__main__":
    if_list = get_if_list(['lo'])
    print(if_list)
    for int in if_list:
        if_ip = get_ip_of(int)
        print(if_ip)
