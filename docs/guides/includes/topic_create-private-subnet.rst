.. _create-private-subnet:

Private subnet
``````````````

.. code-block:: shell

    $ neutron subnet-create --name private_subnet private_network 172.16.0.0/12 --dns-nameserver=10.190.0.20
    Created a new subnet:
    +-------------------+-------------------------------------------------+
    | Field             | Value                                           |
    +-------------------+-------------------------------------------------+
    | allocation_pools  | {"start": "172.16.0.255", "end": "172.16.16.0"} |
    |                   | {"start": "172.16.0.2", "end": "172.16.0.254"}  |
    | cidr              | 172.16.0.0/12                                   |
    | dns_nameservers   | 10.190.0.20                                     |
    | enable_dhcp       | True                                            |
    | gateway_ip        | 172.16.0.1                                      |
    | host_routes       |                                                 |
    | id                | 5528fd9e-76dc-427e-9791-2cad6c87ba06            |
    | ip_version        | 4                                               |
    | ipv6_address_mode |                                                 |
    | ipv6_ra_mode      |                                                 |
    | name              | private_subnet                                  |
    | network_id        | 99717ae6-5cfb-45fb-b846-f8e99599cd35            |
    | subnetpool_id     |                                                 |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec                |
    +-------------------+-------------------------------------------------+

