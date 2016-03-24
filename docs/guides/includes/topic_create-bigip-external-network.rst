.. _create-bigip-external-network:

Create External Network for BIG-IP®
```````````````````````````````````

.. code-block:: shell

    $ neutron net-create bigip_external
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
