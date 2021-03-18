:product: F5 Agent for OpenStack Neutron
:product: F5 Driver for OpenStack Neutron
:product: F5 Templates for OpenStack Heat
:type: tutorial

.. _add-nova-flavors:

How to add the F5 flavors to OpenStack Nova
===========================================

.. important::

   By default, only admin users can create Nova flavors.
   See `OpenStack Horizon - Manage flavors`_ for more information.

You can add custom F5 flavors to OpenStack Nova using the `OpenStack CLI`_.
Commands follow the format ::

   $ openstack flavor create FLAVOR_NAME --id FLAVOR_ID --ram RAM_IN_MB --disk ROOT_DISK_IN_GB --vcpus NUMBER_OF_VCPUS

The values shown here reflect the requirements for BIG-IP Virtual Edition images v12.0 and later.


f5-1slot
--------

.. code-block:: console

   $ openstack flavor create f5-1slot --id auto --ram 4096 --disk 20 --vcpus 2

f5-ltm
------

.. code-block:: console

   $ openstack flavor create f5-ltm --id auto --ram 4096 --disk 50 --vcpus 2

f5-all
------

.. code-block:: console

   $ openstack flavor create f5-all --id auto --ram 4096 --disk 140 --vcpus 4

.. tip::

   If you're using the BIG-IP `Application Acceleration Manager`_ (AAM) module, increase the disk size to 160.



.. _OpenStack Horizon - Manage flavors: https://docs.openstack.org/horizon/latest/admin/manage-flavors.html
