.. _os-set-up-router-gateway:

Set up the router gateway
`````````````````````````

.. _create-router:

Create the router
~~~~~~~~~~~~~~~~~

.. code-block:: shell

    $ neutron router-create router1
    Created a new router:
    +-----------------------+--------------------------------------+
    | Field                 | Value                                |
    +-----------------------+--------------------------------------+
    | admin_state_up        | True                                 |
    | distributed           | False                                |
    | external_gateway_info |                                      |
    | ha                    | False                                |
    | id                    | 9625ca6a-694b-404c-bdc3-787a92664e00 |
    | name                  | router1                              |
    | routes                |                                      |
    | status                | ACTIVE                               |
    | tenant_id             | 1a35d6558b59423e83f4500f1ebc1cec     |
    +-----------------------+--------------------------------------+

.. _attach-router-to-gateway:

Attach the router to the gateway
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell

    $ neutron router-gateway-set router1 external_network
    Set gateway for router router1

