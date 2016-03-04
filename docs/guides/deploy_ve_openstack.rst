.. title:: Deploying BIG-IP VE in OpenStack

Deploying BIG-IP VE in OpenStack
================================

Overview
--------

.. include:: includes/ve_overview.rst

Before You Start
~~~~~~~~~~~~~~~~

.. include:: includes/ve_before-you-start.rst

Network Architecture
~~~~~~~~~~~~~~~~~~~~

.. include:: includes/single-tenancy_overview.rst

.. include:: includes/multi-tenancy_overview.rst

Initial Setup
-------------

.. include:: includes/deploy_ve_init_setup.rst

Integrate BIG-IP VE with the OpenStack Network Infrastructure
-------------------------------------------------------------

Create VLANs
~~~~~~~~~~~~

.. include:: includes/os_ve_creating_vlans.rst

External
````````

.. include:: includes/os_ve_base_networking-external.rst

Internal
````````

.. include:: includes/os_ve_base_networking-internal.rst

Management
``````````

.. include:: includes/os_ve_deploy_config-mgmt-network.rst

SR-IOV
``````

.. include:: includes/os_ve_sr-iov.rst

Device Service Clustering
`````````````````````````

.. include:: includes/ve_clustering_overview.rst

Create Custom Flavors
---------------------

For information regarding BIG-IP VE image sizes and minimum requirements, see :ref:`BIG-IP VE Flavor Requirements <big-ip_flavors>`.

.. include:: includes/os_ve_create-flavor-instructions.rst

Deploy BIG-IP VE
----------------

.. include:: includes/os_ve_deploy-big-ip.rst

.. _import-ve-image:

Import the VE Image
~~~~~~~~~~~~~~~~~~~

.. include:: includes/os_import_ve_image.rst

.. _launch_big-ip_instance:

Launch the BIG-IP Instance
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: includes/os_ve_launch_instance.rst

Assign a Floating IP
~~~~~~~~~~~~~~~~~~~~

.. include:: includes/os_ve_assign-floating-ip.rst

Next Steps
----------

.. include:: includes/os_ve_deploy_big-ip_next-steps.rst

.. _further_reading:

Further Reading
---------------

.. include:: includes/os_ve_deploy_big-ip_further-reading.rst

