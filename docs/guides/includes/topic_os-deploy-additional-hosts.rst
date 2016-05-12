.. _os-deploy-additional-hosts:

Deploying Additional Hosts
``````````````````````````

You can add more hosts at any time after deploying an all-in-one environment by taking the steps below.

1. In the :ref:`answers file <os-deploy-with-answers_file>`:

- Update the network card names for ``CONFIG_NOVA_COMPUTE_PRIVIF`` and ``CONFIG_NOVA_NETWORK_PRIVIF``.
- Update the IP addresses for the ``COMPUTE_HOSTS`` and ``NETWORK_HOSTS``.
- Add the IP address of the host on which you've already run Packstack to the ``EXCLUDE_SERVERS`` entry.

.. topic:: Example

    .. code-block:: text

        # Comma-separated list of servers to be excluded from the
        # installation. This is helpful if you are running Packstack a second
        # time with the same answer file and do not want Packstack to
        # overwrite these server's configurations. Leave empty if you do not
        # need to exclude any servers.
        EXCLUDE_SERVERS=10.190.4.193
        ...
        # Private interface for flat DHCP on the Compute servers.
        CONFIG_NOVA_COMPUTE_PRIVIF=enp2s0
        ...
        # Private interface for flat DHCP on the Compute network server.
        CONFIG_NOVA_NETWORK_PRIVIF=enp2s0
        ...
        # List of IP addresses of the servers on which to install the Compute
        # service.
        CONFIG_COMPUTE_HOSTS=10.190.4.195

        # List of IP addresses of the server on which to install the network
        # service such as Compute networking (nova network) or OpenStack
        # Networking (neutron).
        CONFIG_NETWORK_HOSTS=10.190.4.195


2. :ref:`Run packstack <os-deploy-run-packstack>` again. Packstack will then install OpenStack on the additional hosts.


.. tip::

    Run ``ip addr show`` on the host(s) you want to add to find the interface names and IP addresses.

    .. code-block:: shell

        $ ip addr show
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
               valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host
               valid_lft forever preferred_lft forever
        2: ens2f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether 78:e3:b5:0b:61:a4 brd ff:ff:ff:ff:ff:ff
        3: ens2f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether 78:e3:b5:0b:61:a6 brd ff:ff:ff:ff:ff:ff
        4: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master ovs-system state UP qlen 1000
            link/ether b4:99:ba:a9:55:f0 brd ff:ff:ff:ff:ff:ff
            inet6 fe80::b699:baff:fea9:55f0/64 scope link
               valid_lft forever preferred_lft forever
        5: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether b4:99:ba:a9:55:f1 brd ff:ff:ff:ff:ff:ff
