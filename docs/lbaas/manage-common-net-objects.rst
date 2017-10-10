.. index::
   single: F5 Agent; Common networks

.. _common networks:

.. sidebar:: :fonticon:`fa fa-exclamation-triangle` Compatibility notice:

   **Common networks** is not available in OpenStack Liberty deployments.

Manage shared network resources from any tenant
===============================================

You can use the |agent| to manage shared, or "common", network objects across Neutron tenants.
When using common networks, all network objects live in the :code:`/Common` partition on the BIG-IP system.
The :code:`/Common` partition has its own route domain, which provides Layer 2 isolation between :code:`/Common` and the tenants.
When using common networks, no isolation exists between the tenants themselves.

.. warning::

   Although the F5 common networks functionality is similar to OpenStack Neutron's shared networks, F5 does not support the use of Neutron RBAC.

:ref:`Turn on common networks <common networks setup>` if you want to:

- orchestrate a set of shared network objects from any Neutron tenant, and/or
- share network resources across multiple Neutron tenants.

You can use common networks in :ref:`L2-adjacent mode` or :ref:`global routed mode`.

As demonstrated in the diagram below, each Neutron tenant normally has a separate network, route domain, and partition on the BIG-IP system.
In this type of setup, no tenant can control network or LTM objects in any other tenant's partition.
If you attempted, for example, to modify Tenant B's network objects from Tenant A, the requested task would fail.
Tenant A's Neutron loadbalancer would display a provisioning status error because it was unable to complete the task.

.. figure:: /_static/media/tenant-networks.png
   :scale: 60

When using common networks, the following network objects live in the BIG-IP :code:`/Common` partition:

-  Networks (VLANs, tunnels, disconnected network PPP)
-  Route Domains
-  Routes
-  Self IP’s
-  SNAT Pools
-  SNAT Translation Addresses

The following BIG-IP Local Traffic Manager (LTM) objects are tenant-specific:

-  Virtual Addresses
-  Virtual Servers
-  Health Monitors
-  Pools
-  Pool Members

Because all network objects are in the :code:`/Common` partition, network changes made on Tenant A do affect Tenants B and C.
For example, if you delete a route or SNAT pool in Tenant A, it disappears from Tenants B and C as well.

.. figure:: /_static/media/common-networks.png
   :scale: 60

.. _common networks setup:

Set-up
------

.. warning::

   When :code:`f5_common_networks = True`, it overrides all other common network settings.

   - :code:`f5_common_external_networks`
   - :code:`common_networks`
   - :code:`common_network_ids`


Whether you're installing the |agent| for the first time or updating an existing Agent, turning on common networks has the same effect.
After the |agent| restarts, it reads information about the network from the Neutron database and populates objects in the BIG-IP :code:`/Common` partition accordingly.

.. _fresh-install common networks:

Fresh installation
``````````````````

If this is your first time setting up the |agent| in OpenStack:

.. include:: /_static/reuse/install-agent-driver_edit-config.rst

#. Set the desired |agent| configuration parameter(s).

   ::

      f5_common_networks = True

#. Restart the |agent| service.

   .. include:: /_static/reuse/restart-f5-agent.rst

.. _update-existing common networks:

Update an existing F5 agent
```````````````````````````

To update the configuration for an |agent| that's already running:

#. Stop the |agent| service.

   .. include:: /_static/reuse/stop-the-agent.rst

#. Use the built-in |agent| cleanup utility to clear each BIG-IP partition associated with a Neutron loadbalancer.

   - Pass in the name of the partition as the :code:`--partition` argument.
   - Provide the correct path and filename for your |agent| configuration file. [#filename]_

     .. code-block:: console

        python ./f5-openstack-agent/utils/clean_partition.py \\
        --config-file /etc/neutron/services/f5/f5-openstack-agent.ini \\
        -–partition Test_openstack-lb1

#. Complete steps 3-5 in the :ref:`Fresh installation <fresh-install common networks>` section.

   - Edit the |agent| |config-file|.
   - Set :code:`f5_common_networks = True`.
   - Restart the |agent|.

What's next
-----------

- Learn more about the |agent| :ref:`modes of operation <F5 agent modes>`.

.. rubric:: Footnotes
.. [#filename] The name of your |agent| configuration file may differ from the example if you're using :ref:`differentiated service environments <lbaas-differentiated-service-env>`.
