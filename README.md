DynEinsle
=========

DynEinsle is a dynamic dns client using bind as dyndns server.

Download
========

Here you can download the actual version of dyneinsle:

.. _dyneinsle: http://debian.einsle.de/debian/pool/main/d/dyneinsle/dyneinsle_0.3_all.deb

Installation
============

The installation on debian is as simple as:

.. code:: bash

    dpkg -i dyneinsle_0.3_all.deb

Documentation
=============

Create key
----------

To create a new dynamic-dns-key you can use dnssec-keygen out of debians bind9utils package:

.. code:: bash

    dnssec-keygen -a RSASHA1 -b 4096 -T KEY -r /dev/urandom -n host xxx.dyn.einsle.de  

This creates 2 new Files, 'Kxxx.dyn.einsle.de.*.key' and 'Kxxx.dyn.einsle.de.*.private'. The .key file should be integrated into master dns zonefile, the .private is used on the client.

Integrate Bind (Server)
-----------------------

To integrate the new zone into the master bind zonefile, you must extend 2 Files.

First you should extend the zone-config:

.. code:: bash

    ...
    type master;
    update-policy {
        ...
        grant|deny identity matchtype name [rr];
        grant xxx.dyn.einsle.de subdomain xxx.dyn.einsle.de. A;
        ...
    };

Documentation about it can be found at: http://www.zytrax.com/books/dns/ch7/xfer.html#update-policy

The second is to integrate the newly created key into the zonefile:

.. code:: bash

    xxx                   A       188.174.59.210
    $TTL 3600       ; 1 hour
                          KEY     512 3 5 (
                                  <KEY-TEXT>
                                  ) ; key id = 586

Setup at Client
---------------

To update the zoneinfo on Server you can use the scritp above to download or you can use this simple script:

.. code:: bash

    #!/bin/sh
    #
    # Script zum Updaten der IP
    #
    # (c) Robert Einsle <robert@einsle.de>
    #
    
    KEY="/etc/dyn/Kxxx.dyn.einsle.de.+003+31559.private"
    NAME=xxx.dyn.einsle.de.
    
    IP=`curl --silent http://ns-dyn.einsle.de/ip.php`
    
    #echo "Updating $NAME mit ip: $IP"
    /usr/bin/nsupdate -k $KEY << EOF
    server ns-dyn.einsle.de
    update delete $NAME A
    update add $NAME 60 A $IP
    send
    EOF

Cron
----

To letz automatically update cron the service you can use this script:

.. code:: bash

    */15  *  *  *  *        /usr/local/bin/update-dns.sh > /dev/null
    