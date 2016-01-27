.. _os_ve_deploy_mirroring:

Mirroring
=========

.. code-block:: text

        $ neutron net-create bigip_mirror
        Created a new network:
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | admin_state_up            | True                                 |
        | id                        | 1baaac15-0397-45d8-9e92-abc64aa56896 |
        | mtu                       | 0                                    |
        | name                      | bigip_mirror                         |
        | provider:network_type     | vxlan                                |
        | provider:physical_network |                                      |
        | provider:segmentation_id  | 81                                   |
        | router:external           | False                                |
        | shared                    | False                                |
        | status                    | ACTIVE                               |
        | subnets                   |                                      |
        | tenant_id                 | 9af267dd389249cc8c8e922f8bfbd0aa     |
        +---------------------------+--------------------------------------+

        $ neutron subnet-create --name bigip_mirror_subnet bigip_mirror 10.50.0.0/24
        Created a new subnet:
        +-------------------+----------------------------------------------+
        | Field             | Value                                        |
        +-------------------+----------------------------------------------+
        | allocation_pools  | {"start": "10.50.0.2", "end": "10.50.0.254"} |
        | cidr              | 10.50.0.0/24                                 |
        | dns_nameservers   |                                              |
        | enable_dhcp       | True                                         |
        | gateway_ip        | 10.50.0.1                                    |
        | host_routes       |                                              |
        | id                | 24fa9b50-130a-4f21-83be-989281d1d4dd         |
        | ip_version        | 4                                            |
        | ipv6_address_mode |                                              |
        | ipv6_ra_mode      |                                              |
        | name              | bigip_mirror_subnet                          |
        | network_id        | 1baaac15-0397-45d8-9e92-abc64aa56896         |
        | subnetpool_id     |                                              |
        | tenant_id         | 9af267dd389249cc8c8e922f8bfbd0aa             |
        +-------------------+----------------------------------------------+


        $ neutron router-interface-add router1 bigip_mirror_subnet
        Added interface b9a992dd-299b-42c5-a1be-568d4f243cc0 to router router1.

