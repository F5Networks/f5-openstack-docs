.. _os_ve_base_networking-external:

1. Create the external (physical) network.

    .. code-block:: text

        # neutron net-create <network_name>


    Example:

    .. code-block:: text

        # neutron net-create bigip_external
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | 05f61e74-37e0-4c30-a664-762dfef1a221 |
        | mtu                       | 0                                    |
        | name                      | bigip_external                       |
        | provider:network_type     | vxlan                                |
        | provider:physical_network |                                      |
        | provider:segmentation_id  | 84                                   |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
        +---------------------------+--------------------------------------+


2. Create the external subnet.

    .. code-block:: text

        # neutron subnet-create --name <subnet_name> <external_network> <CIDR>

    Example:

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


3. Attach the subnet to the router.

    .. code-block:: text

        #neutron router-interface-add <router_name> <subnet_name>

    Example:

    .. code-block:: text

        # neutron router-interface-add router1 bigip_external_subnet
        Added interface 2593c3be-fbc5-453c-901f-1d1d33b09951 to router router1.

