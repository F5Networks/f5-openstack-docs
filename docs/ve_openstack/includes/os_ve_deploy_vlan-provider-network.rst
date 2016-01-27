.. _os_ve_deploy_vlan-provider-network:

VLAN provider network
=====================

1. Create the data network.

   .. code-block:: text

        $ neutron net-create datanet --provider:network_type vlan --provider:physical_network physnet-data --provider:segmentation_id 4
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | 0e44de42-5f0d-4f44-b9ac-224d3ee5324f |
        | mtu                       | 0                                    |
        | name                      | datanet                              |
        | provider:network_type     | flat                                 |
        | provider:physical_network | physnet-data                         |
        | provider:segmentation_id  |                                      |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 9af267dd389249cc8c8e922f8bfbd0aa     |
        +---------------------------+--------------------------------------+

2. Create the subnet.
    Notice that a higher range of the subnet is used here. The idea is that IP addresses used for tunneling endpoints on the compute nodes can use a lower range of the subnet and service VMs like BIG-IP can use a higher range of the subnet. This separation might be necessary if the compute nodes are using static IPs or a different DHCP server.

   .. code-block:: text

        neutron subnet-create --allocation-pool start=10.30.30.200,end=10.30.30.250 --name datanet_subnet datanet 10.30.30.0/24
        Created a new subnet:
        +-------------------+--------------------------------------------------+
        | Field             | Value                                            |
        +-------------------+--------------------------------------------------+
        | allocation_pools  | {"start": "10.30.30.200", "end": "10.30.30.250"} |
        | cidr              | 10.30.30.0/24                                    |
        | dns_nameservers   |                                                  |
        | enable_dhcp       | True                                             |
        | gateway_ip        | 10.30.30.1                                       |
        | host_routes       |                                                  |
        | id                | efa1aa08-08b2-4c56-9aff-147ad2ae6a27             |
        | ip_version        | 4                                                |
        | ipv6_address_mode |                                                  |
        | ipv6_ra_mode      |                                                  |
        | name              | datanet_subnet                                   |
        | network_id        | 0e44de42-5f0d-4f44-b9ac-224d3ee5324f             |
        | subnetpool_id     |                                                  |
        | tenant_id         | 9af267dd389249cc8c8e922f8bfbd0aa                 |
        +-------------------+--------------------------------------------------+

