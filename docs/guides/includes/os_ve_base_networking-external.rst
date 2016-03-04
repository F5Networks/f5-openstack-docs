.. _os_ve_base_networking-external:


.. note::

    You should have already created the external (physical) network when setting up your OpenStack environment.


1. Create an external subnet.

.. code-block:: text

    # neutron subnet-create --name <subnet_name> <external_network> <CIDR>

2. Attach the subnet to the router.

.. code-block:: text

    # neutron router-interface-add <router_name> <subnet_name>


