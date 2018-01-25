.. _lbaas-capacity-based-scaleout:

.. sidebar:: Applies to:

   ====================    ===========================
   F5 LBaaS version(s)     OpenStack version(s)
   ====================    ===========================
   v8.1+                   Liberty
   --------------------    ---------------------------
   v9.1+                   Mitaka
   --------------------    ---------------------------
   v10.0+                  Newton
   ====================    ===========================

Capacity-Based Scale Out
========================

When using :ref:`differentiated service environments <lbaas-differentiated-service-env>`, you can configure capacity metrics for the |agent-long| to provide scale out across multiple BIG-IP device groups.

:fonticon:`fa fa-chevron-right` :ref:`Learn more <learn-cbso>`

Prerequisites
-------------
- Administrator access to both the BIG-IP devices and the OpenStack cloud.
- :agent:`F5 Agent <#f5-agent-for-openstack-neutron>` installed on all hosts.
- One (1) F5 OpenStack service provider driver instance installed on the Neutron controller for each of your :ref:`custom service environments <lbaas-differentiated-service-env>`.

Caveats
-------

- All hosts running the |oslbaas| must use the same Neutron database.
- F5 does not support the use of multiple |agent| instances on the same host, in the same service environment, to manage a single BIG-IP device or :term:`cluster`.
  When using multiple |agent| instances to manage a single BIG-IP device/cluster, each Agent must run in a :ref:`different service environment <lbaas-differentiated-service-env>`.

Configuration
-------------

Edit the following items in the |agent| |config-file|.

#. Set the desired :code:`environment_group_number`.

   .. code-block:: text

      ###############################################################################
      #  Environment Settings
      ###############################################################################
      ...
      #
      environment_group_number = 1
      #
      ...

#. Provide the iControl endpoint and login credentials for one (1) of the BIG-IP devices in the device group.

   .. code-block:: text

      #
      icontrol_hostname = 1.2.3.4
      #
      ...
      #
      icontrol_username = myusername
      ...
      #
      icontrol_password = mypassword
      #

#. Define the capacity score metrics.

   .. table:: Capacity score settings

      ========================= ==========================================================
      throughput                total throughput in bps of the TMOS devices
      ------------------------- ----------------------------------------------------------
      inbound_throughput        throughput in bps inbound to TMOS devices
      ------------------------- ----------------------------------------------------------
      outbound_throughput       throughput in bps outbound from TMOS devices
      ------------------------- ----------------------------------------------------------
      active_connections        number of concurrent active actions on a TMOS device
      ------------------------- ----------------------------------------------------------
      tenant_count              number of tenants associated with a TMOS device
      ------------------------- ----------------------------------------------------------
      node_count                number of nodes provisioned on a TMOS device
      ------------------------- ----------------------------------------------------------
      route_domain_count        number of route domains on a TMOS device
      ------------------------- ----------------------------------------------------------
      vlan_count                number of VLANs on a TMOS device
      ------------------------- ----------------------------------------------------------
      tunnel_count              number of GRE and VxLAN overlay tunnels on a TMOS device
      ------------------------- ----------------------------------------------------------
      ssltps                    the current measured SSL TPS count on a TMOS device
      ------------------------- ----------------------------------------------------------
      clientssl_profile_count   the number of clientside SSL profiles defined
      ========================= ==========================================================

   \

   .. code-block:: text

      ###############################################################################
      #  Environment Settings
      ###############################################################################
      ...
      #
      capacity_policy = throughput:1000000000, active_connections: 250000, route_domain_count: 512, tunnel_count: 2048
      #


.. _learn-cbso:

Learn more
----------

The |agent| :code:`environment_group_number` and :code:`environment_capacity_score` |configs| allow the |driver-long| to assign requests to the group that has the lowest capacity score.
The :code:`environment_group_number` provides a convenient way for the F5 driver to identify |agent| instances that are available to handle requests for any of the devices in a given group.

You can configure a variety of capacity metrics via the :code:`capacity_policy` configuration parameter.
These metrics contribute to the overall :code:`environment_capacity_score` for the environment group.
Each |agent| instance calculates the capacity score for its group and reports the score back to the Neutron database.

To find the capacity score, the |agent| divides the collected metric by the max specified for that metric in the :code:`capacity_policy` `Agent configuration parameter`_.
An acceptable reported :code:`environment_capacity_score` is between zero (0) and one (1).
**If an |agent| instance in the group reports an :code:`environment_capacity_score` of one (1) or greater, the device is at capacity.**

.. figure:: /_static/media/lbaasv2_capacity-based-scaleout.png
   :scale: 60%
   :alt: Capacity-Based Scale Out diagram

   Capacity-based Scale Out

As demonstrated in the figure, when the |driver| receives a new LBaaS request, it consults the Neutron database.
It uses the :code:`environment_group_number` and the group's last reported :code:`environment_capacity_score` to assign the task to the group with the lowest utilization.
The |driver| then selects an |agent| instance from the group (at random) to handle the request.

If any |agent| instance has previously handled requests for the specified tenant, that |agent| instance receives the task.
If that |agent| instance is a member of a group for which the last reported :code:`environment_capacity_score` is above capacity, the |driver| assigns the request to an |agent| instance **in a different group** where capacity is under the limit.

.. danger::

   If all |agent| instances in all environment groups are at capacity, **LBaaS service requests will fail**.
   LBaaS objects created in an environment that has no capacity left will show an error status.

Use Case
--------

Capacity-based scale out provides redundancy and high availability across the |agent| instances responsible for managing a specific :ref:`service environment <lbaas-differentiated-service-env>`.
The capacity score each |agent| instance reports back to the Neutron database helps ensure that the |driver| assigns tasks to the |agent| instance currently handling the fewest requests.

.. seealso::

   * |agent| |config-file|
   * :ref:`Differentiated Service Environments <lbaas-differentiated-service-env>`
   * :ref:`Agent Redundancy and Scale Out <lbaas-agent-redundancy>`
