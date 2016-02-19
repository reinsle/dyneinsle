#!/usr/bin/env python3

from netifaces import AF_INET, AF_INET6
import netifaces as ni
import urllib3


def get_if_list(exclude_if=None):
    """
    Reads list of interfaces and returns it. If exclude_id is set, interfaces are removed from list.

    Args:
        exclude_if: remove this interfaces from list of returned values.

    Returns:
        List of Interfaces from system.
        If exclude_if interfaces are set, they will removed from list.
    """
    ifaces = ni.interfaces()
    if exclude_if is not None:
        for ex_if in exclude_if:
            try:
                ifaces.remove(ex_if)
            except ValueError:
                pass
    return ifaces


def get_ip4_of(if_name):
    """
    Returns ip4 address of interface given by if_name.

    Args:
        if_name: name of interface to return ip4 address

    Returns:
        ipv4 addresses of interface
    """
    if AF_INET in ni.ifaddresses(if_name).keys():
        if_ip_addr = ni.ifaddresses(if_name)[AF_INET][0]['addr']
        return if_ip_addr
    return None


def get_ip6_of(if_name):
    """
    Returns ip6 address list of interface given by if_name.

    Args:
        if_name: name of interface to return ip4 address

    Returns:
        list of ipv6 addresses of interface
    """
    if AF_INET6 in ni.ifaddresses(if_name).keys():
        ''' @TODO read list of ipv6 interface list '''
        if_ip_addr = ni.ifaddresses(if_name)[AF_INET6][0]['addr']
        return if_ip_addr
    return None


def get_external_ip4():
    """
    Fetch external ipv4 address

    Returns:
        external ipv4 address
    """
    http = urllib3.PoolManager()
    response = http.request('GET', 'http://icanhazip.com')
    return response.data


if __name__ == "__main__":
    if_list = get_if_list(['lo'])
    print(if_list)
    for interface in if_list:
        if_ip4 = get_ip4_of(interface)
        print(if_ip4)
    print(get_external_ip4())
