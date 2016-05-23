.. _os-tip-view-configured-networks:

Viewing Configured Networks
```````````````````````````

.. tip::

    To check what networks are configured, run ``openstack network list``.

    .. code-block:: shell

        $ openstack network list
        +--------------------------------------+------------------+--------------------------------------+
        | ID                                   | Name             | Subnets                              |
        +--------------------------------------+------------------+--------------------------------------+
        | 222840d7-4f9f-411d-a7de-6343ce71fee9 | private_network  | 3203971c-1c58-4e29-98e9-136e4a3aff86 |
        | 8fe1a243-4970-4c5a-84c0-6fef5612c844 | external_network | 49e2802a-ed2d-4eb8-a43d-2dac053433f5 |
        +--------------------------------------+------------------+--------------------------------------+


    Run ``openstack network show <network_id>`` to view the details for a specific network.

    .. code-block:: shell

        $ openstack network show 8fe1a243-4970-4c5a-84c0-6fef5612c844
        +---------------------------+--------------------------------------+
        | Field                     | Value                                |
        +---------------------------+--------------------------------------+
        | id                        | 8fe1a243-4970-4c5a-84c0-6fef5612c844 |
        | mtu                       | 0                                    |
        | name                      | external_network                     |
        | project_id                | 1a35d6558b59423e83f4500f1ebc1cec     |
        | provider:network_type     | flat                                 |
        | provider:physical_network | extnet                               |
        | provider:segmentation_id  | None                                 |
        | router_type               | External                             |
        | shared                    | True                                 |
        | state                     | UP                                   |
        | status                    | ACTIVE                               |
        | subnets                   | 49e2802a-ed2d-4eb8-a43d-2dac053433f5 |
        +---------------------------+--------------------------------------+

