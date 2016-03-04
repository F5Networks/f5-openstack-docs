.. _os_ve_base_networking-internal:

1. Create an internal (private) network.

.. code-block:: text

    # neutron net-create <network_name>

2. Create a private subnet.

.. code-block:: text

    # neutron subnet-create --name <subnet_name> <network_name> <CIDR>

3. Attach the subnet to the router.

.. code-block:: text

    #neutron router-interface-add <router_name> <subnet_name>

