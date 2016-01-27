.. _os_ve_deploy_ha:

High Availability
=================

    .. code-block:: text

        $ neutron net-create bigip_ha
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | 1b04300b-9fa6-44aa-9889-c462db5342ad |
        | mtu                       | 0                                    |
        | name                      | bigip_ha                             |
        | provider:network_type     | vxlan                                |
        | provider:physical_network |                                      |
        | provider:segmentation_id  | 11                                   |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 9af267dd389249cc8c8e922f8bfbd0aa     |
        +---------------------------+--------------------------------------+

        $ neutron subnet-create --name bigip_ha_subnet bigip_ha 10.40.0.0/24
        Created a new subnet:
        +-------------------+----------------------------------------------+
        | Field             | Value                                        |
        +-------------------+----------------------------------------------+
        | allocation_pools  | {"start": "10.40.0.2", "end": "10.40.0.254"} |
        | cidr              | 10.40.0.0/24                                 |
        | dns_nameservers   |                                              |
        | enable_dhcp       | True                                         |
        | gateway_ip        | 10.40.0.1                                    |
        | host_routes       |                                              |
        | id                | b9db808e-5f2e-4b48-bb9c-2d8aa3fa0d6b         |
        | ip_version        | 4                                            |
        | ipv6_address_mode |                                              |
        | ipv6_ra_mode      |                                              |
        | name              | bigip_ha_subnet                              |
        | network_id        | 1b04300b-9fa6-44aa-9889-c462db5342ad         |
        | subnetpool_id     |                                              |
        | tenant_id         | 9af267dd389249cc8c8e922f8bfbd0aa             |
        +-------------------+----------------------------------------------+

        $ neutron router-interface-add router1 bigip_ha_subnet
        Added interface e066cade-93b5-4900-b936-5134ad221439 to router router1.

