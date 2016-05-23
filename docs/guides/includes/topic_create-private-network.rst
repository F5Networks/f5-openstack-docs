.. _create-private-network:

Private network
```````````````

.. code-block:: shell

    $ neutron net-create private_network
    Created a new network:
    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | admin_state_up            | True                                 |
    | id                        | 222840d7-4f9f-411d-a7de-6343ce71fee9 |
    | mtu                       | 0                                    |
    | name                      | private_network                      |
    | provider:network_type     | vxlan                                |
    | provider:physical_network |                                      |
    | provider:segmentation_id  | 77                                   |
    | router:external           | False                                |
    | shared                    | False                                |
    | status                    | ACTIVE                               |
    | subnets                   |                                      |
    | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
    +---------------------------+--------------------------------------+
