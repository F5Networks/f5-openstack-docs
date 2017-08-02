.. _lbaas-port-binding:

Manage Software-Defined Networks with Hierarchical Port Binding
===============================================================

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


Neutron `hierarchical port binding`_ allows you to use the |oslbaas| with software-defined networking (SDN).
Once you tell the |agent-long| what top of rack (ToR) L3 switch and port (in other words, which network segment) the BIG-IP devices connect to, it can connect LBaaS services to the BIG-IP device(s) for dynamically-created VLANs in that segment.

Hierarchical port binding allows for the creation of :ref:`disconnected services <lbaas-disconnected-svcs>`.
The |agent| polls the Neutron database looking for the VLANs requested for the disconnected services.
When it discovers the VLANs, the |agent| creates the requested objects on the BIG-IP device(s).

Prerequisites
`````````````

- Your `BIG-IP license`_ must include SDN services (Better or Best).

Caveats
```````

- :code:`VLAN` is the only ML2 network type supported for use with hierarchical port binding.
- Each |agent| instance managing a BIG-IP :term:`device service cluster` must use the same ``f5_network_segment_physical_network``. [#caveat1]_
- All |agent| instances in a :ref:`service environment <lbaas-differentiated-service-env>` group must use the same binding settings.

.. _agent-setup-port-binding:

Set up the |agent-long| to use heirarchical port binding
--------------------------------------------------------

1. Edit the |agent| `configuration file`_:

   .. include:: /_static/reuse/edit-agent-config-file.rst


2. Set the heirarchical port binding settings in the `L2 Segmentation Mode Settings`_ section as appropriate for your environment.

   .. code-block:: console
      :caption: Hierarchical Port Binding Example

      #
      f5_network_segment_physical_network = edgeswitch002ports0305
      #
      f5_network_segment_polling_interval = 10
      #
      f5_pending_services_timeout = 60


Learn more
----------

.. _lbaas-disconnected-svcs:

Disconnected Services
`````````````````````

:dfn:`Disconnected services` are LBaaS objects for which the designated Neutron network isn't bound to physical network segment yet.
When the |agent| discovers the designated Neutron network, the "disconnected services" connect to it  automatically.
The |agent| polling frequency and "pending services timeout" allow for a degree of variation in the timing of the VLAN deployment and the request to create the LBaaS objects for it.

Use Case
````````

Use heirarchical port binding if you want your :term:`undercloud` physical BIG-IP device or cluster to control traffic for networks dynamically created via SDN.
As noted in the OpenStack documentation, this can be useful if you need your Neutron deployment to scale beyond the 4K-VLANs-per-physical network limit. [#osvlans]_

.. figure:: /_static/media/lbaasv2_hierarchical-port-binding.png
   :alt: F5 LBaaSv2 Hierarchical Port Binding
   :scale: 60%

   F5 LBaaSv2 Hierarchical Port Binding



.. rubric:: Footnotes
.. [#caveat1] See :ref:`Agent Redundancy and Scale Out <lbaas-agent-redundancy>`
.. [#osvlans] `OpenStack ML2 Hierarchical Port Binding specs <https://specs.openstack.org/openstack/neutron-specs/specs/kilo/ml2-hierarchical-port-binding.html#problem-description>`_.


.. _hierarchical port binding: https://specs.openstack.org/openstack/neutron-specs/specs/kilo/ml2-hierarchical-port-binding.html
.. _ML2: https://wiki.openstack.org/wiki/Neutron/ML2
.. _system configuration: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-initial-configuration-13-0-0/2.html
.. _local traffic management: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0.html
.. _device service clustering: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-admin-13-0-0.html
.. _BIG-IP license: https://f5.com/products/how-to-buy/simplified-licensing


