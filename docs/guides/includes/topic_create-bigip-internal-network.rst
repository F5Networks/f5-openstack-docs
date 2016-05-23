.. _create-bigip-internal-network:

Create Internal Network for BIG-IP®
```````````````````````````````````

.. code-block:: shell

    $ neutron net-create bigip_internal
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
