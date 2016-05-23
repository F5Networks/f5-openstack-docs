.. _os-config-getting-started:

Getting Started
---------------

To configure Neutron to work with an existing external network, you'll need to identify the device that's attached to the management network and record a few key values:

-   IPADDR
-   HWADDR
-   NETMASK
-   GATEWAY
-   DNS1

To find these values, run ``ip addr show`` and/or ``ifconfig``. In our example, the device connected to the management network is ``enp2s0``; yours may be something simpler, such as ``eth0``. The IP address is listed as ``inet``.

.. code-block:: shell

    $ ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ens2f0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN qlen 1000
        link/ether 78:e3:b5:0b:61:a4 brd ff:ff:ff:ff:ff:ff
    3: ens2f1: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN qlen 1000
        link/ether 78:e3:b5:0b:61:a6 brd ff:ff:ff:ff:ff:ff
    4: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether b4:99:ba:a9:55:f0 brd ff:ff:ff:ff:ff:ff
        inet 10.190.4.193/21 brd 10.190.7.255 scope global dynamic enp2s0
           valid_lft 19506sec preferred_lft 19506sec
        inet6 fe80::b699:baff:fea9:55f0/64 scope link
           valid_lft forever preferred_lft forever
    5: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
        link/ether b4:99:ba:a9:55:f1 brd ff:ff:ff:ff:ff:ff
    6: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether 5e:31:76:30:05:cb brd ff:ff:ff:ff:ff:ff
    7: br-ex: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
        link/ether 3a:c1:b2:f4:30:48 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::38c1:b2ff:fef4:3048/64 scope link
           valid_lft forever preferred_lft forever
    8: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether 2e:99:9e:a2:cc:43 brd ff:ff:ff:ff:ff:ff
    9: br-tun: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether b2:91:a4:55:a0:4a brd ff:ff:ff:ff:ff:ff


.. code-block:: shell

    $ ifconfig
    br-ex: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet6 fe80::38c1:b2ff:fef4:3048  prefixlen 64  scopeid 0x20<link>
            ether 3a:c1:b2:f4:30:48  txqueuelen 0  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 8  bytes 648 (648.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    enp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.190.4.193  netmask 255.255.248.0  broadcast 10.190.7.255
            inet6 fe80::b699:baff:fea9:55f0 prefixlen 64  scopeid 0x20<link>
            ether b4:99:ba:a9:55:f0  txqueuelen 1000  (Ethernet)
            RX packets 1183741  bytes 541128626 (516.0 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 130388  bytes 13634811 (13.0 MiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
            device interrupt 16  memory 0xf7ee0000-f7f00000

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 0  (Local Loopback)
            RX packets 4013798  bytes 371688922 (354.4 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 4013798  bytes 371688922 (354.4 MiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


