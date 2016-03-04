.. _os_ve_deploy_config-mgmt-network:

1. Create a network to be used for the BIG-IP management interface.

    .. code-block:: text

        # neutron net-create <network_name>

    Example:

    .. code-block:: text

        $ neutron net-create bigip_mgmt
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | 3084a065-d981-4020-aa6d-35b2ef63f13d |
        | mtu                       | 0                                    |
        | name                      | bigip_mgmt                           |
        | provider:network_type     | vxlan                                |
        | provider:physical_network |                                      |
        | provider:segmentation_id  | 21                                   |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 9af267dd389249cc8c8e922f8bfbd0aa     |
        +---------------------------+--------------------------------------+

2. Create a new subnet.

    .. code-block:: text

        # neutron subnet-create --name <subnet_name> <network_name> <CIDR>

    Example:

    .. code-block:: text

        $ neutron subnet-create --name bigip_mgmt_subnet bigip_mgmt 10.10.0.0/24
        Created a new subnet:
        +-------------------+----------------------------------------------+
        | Field             | Value                                        |
        +-------------------+----------------------------------------------+
        | allocation_pools  | {"start": "10.10.0.2", "end": "10.10.0.254"} |
        | cidr              | 10.10.0.0/24                                 |
        | dns_nameservers   |                                              |
        | enable_dhcp       | True                                         |
        | gateway_ip        | 10.10.0.1                                    |
        | host_routes       |                                              |
        | id                | aa0e1012-3f8f-440d-a9b0-00260be57b0f         |
        | ip_version        | 4                                            |
        | ipv6_address_mode |                                              |
        | ipv6_ra_mode      |                                              |
        | name              | bigip_mgmt_subnet                            |
        | network_id        | 3084a065-d981-4020-aa6d-35b2ef63f13d         |
        | subnetpool_id     |                                              |
        | tenant_id         | 9af267dd389249cc8c8e922f8bfbd0aa             |
        +-------------------+----------------------------------------------+

3. Attach the subnet to the router.

    .. code-block:: text

        # neutron router-interface-add <router_name> <subnet_name>

    Example:

    .. code-block:: text

        $ neutron router-interface-add router1 bigip_mgmt_subnet
        Added interface 6118bdcc-c2e6-49d9-ab61-e1dd8772d265 to router router1.