.. code-block:: text

    # neutron subnet-create --name bigip_external_subnet bigip_external 10.20.0.0/24
    Created a new subnet:
    +-------------------+----------------------------------------------+
    | Field             | Value                                        |
    +-------------------+----------------------------------------------+
    | allocation_pools  | {"start": "10.20.0.2", "end": "10.20.0.254"} |
    | cidr              | 10.20.0.0/24                                 |
    | dns_nameservers   |                                              |
    | enable_dhcp       | True                                         |
    | gateway_ip        | 10.20.0.1                                    |
    | host_routes       |                                              |
    | id                | ac966870-2165-4576-9f70-dcf4193e7c39         |
    | ip_version        | 4                                            |
    | ipv6_address_mode |                                              |
    | ipv6_ra_mode      |                                              |
    | name              | bigip_external_subnet                        |
    | network_id        | 05f61e74-37e0-4c30-a664-762dfef1a221         |
    | subnetpool_id     |                                              |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec             |
    +-------------------+----------------------------------------------+
