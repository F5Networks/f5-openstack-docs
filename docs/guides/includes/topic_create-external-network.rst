.. _create-external-network:

External (public) network
`````````````````````````

.. code-block:: shell

    $ neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared
    Created a new network:
    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | admin_state_up            | True                                 |
    | id                        | 8fe1a243-4970-4c5a-84c0-6fef5612c844 |
    | mtu                       | 0                                    |
    | name                      | external_network                     |
    | provider:network_type     | flat                                 |
    | provider:physical_network | extnet                               |
    | provider:segmentation_id  |                                      |
    | router:external           | True                                 |
    | shared                    | True                                 |
    | status                    | ACTIVE                               |
    | subnets                   |                                      |
    | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
    +---------------------------+--------------------------------------+
