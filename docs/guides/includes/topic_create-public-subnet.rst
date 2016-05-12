.. _create-public-subnet:

Public subnet
`````````````

.. code-block:: shell

    $ neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=10.190.6.250,end=10.190.6.254 --gateway=10.190.0.1 external_network 10.190.0.0/21
    Created a new subnet:
    +-------------------+--------------------------------------------------+
    | Field             | Value                                            |
    +-------------------+--------------------------------------------------+
    | allocation_pools  | {"start": "10.190.6.250", "end": "10.190.6.254"} |
    | cidr              | 10.190.0.0/21                                    |
    | dns_nameservers   |                                                  |
    | enable_dhcp       | False                                            |
    | gateway_ip        | 10.190.0.1                                       |
    | host_routes       |                                                  |
    | id                | 91baa5e9-c061-4d29-9584-c171c0c25686             |
    | ip_version        | 4                                                |
    | ipv6_address_mode |                                                  |
    | ipv6_ra_mode      |                                                  |
    | name              | public_subnet                                    |
    | network_id        | fe6b0a53-8d80-4607-96f6-89e31af0b6e6             |
    | subnetpool_id     |                                                  |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec                 |
    +-------------------+--------------------------------------------------+
