.. _os_ve_base_networking-internal:

Create a New Internal Network and Subnet
========================================

    .. code-block:: text

        # neutron net-create bigip_internal
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | e707fe41-3a36-4e15-b521-53496e36e2e0 |
        | mtu                       | 0                                    |
        | name                      | bigip_internal                       |
        | provider:network_type     | vxlan                                |
        | provider:physical_network |                                      |
        | provider:segmentation_id  | 63                                   |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
        +---------------------------+--------------------------------------+

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

        # neutron router-interface-add router1 bigip_internal_subnet
        Added interface 20a6a00c-6708-4f73-a94f-76d86d518c4c to router router1.
