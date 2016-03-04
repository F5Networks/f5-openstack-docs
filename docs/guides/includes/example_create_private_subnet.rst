.. code-block:: text

    # neutron subnet-create --name bigip_internal_subnet bigip_internal 10.30.0.0/24
    Created a new subnet:
    +-------------------+----------------------------------------------+
    | Field             | Value                                        |
    +-------------------+----------------------------------------------+
    | allocation_pools  | {"start": "10.30.0.2", "end": "10.30.0.254"} |
    | cidr              | 10.30.0.0/24                                 |
    | dns_nameservers   |                                              |
    | enable_dhcp       | True                                         |
    | gateway_ip        | 10.30.0.1                                    |
    | host_routes       |                                              |
    | id                | f4a01d74-730e-428a-8722-f2fe94346f87         |
    | ip_version        | 4                                            |
    | ipv6_address_mode |                                              |
    | ipv6_ra_mode      |                                              |
    | name              | bigip_internal_subnet                        |
    | network_id        | e707fe41-3a36-4e15-b521-53496e36e2e0         |
    | subnetpool_id     |                                              |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec             |
    +-------------------+----------------------------------------------+
