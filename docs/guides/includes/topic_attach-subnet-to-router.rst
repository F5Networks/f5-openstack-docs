.. _attach-router:

Attach the Networks and Subnets to the Router
`````````````````````````````````````````````

Attach the networks subnets to an existing router.

.. code-block:: shell

    $ sudo neutron router-interface-add <router_name> <network_name>
    $ sudo neutron router-interface-add <router_name> <subnet_name>

