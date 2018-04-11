:product: F5 Agent for OpenStack Neutron
:type: reference

.. _F5 agent modes:

F5 Agent Modes of Operation
===========================

If you're setting up the |agent-long| for the first time, you may be asking yourself,

*"What are the differences between l2-adjacent mode and global routed mode? Which mode should I choose?"*.

This document clarifies the available options and provides vital information to take into account when making this decision.


.. _network considerations:

Network considerations
``````````````````````

When thinking about how to integrate your BIG-IP device into the OpenStack network, you'll probably want to take into account:

- How do the BIG-IP devices connect to the physical network?
- Do you need to isolate tenants from each other?

Your answers to these questions should lead you to the correct mode for your environment.

.. _global routed mode:

Global routed mode
------------------

:dfn:`Global routed mode` supports use of the BIG-IP device as an edge load balancer **without Neutron L3 routing and tenant isolation.**
In this mode, the BIG-IP device has an L2 connection to the external provider network.
All tenants are in the global route domain (``rd=0``) on the BIG-IP system.

.. figure:: /_static/media/f5-lbaas-global-routed-mode.png
   :scale: 70%
   :alt: Global routed mode diagram shows a BIG-IP device cluster as part of an L3-routed network external to the OpenStack cloud.

In global routed mode, the |agent| assumes that:

- all LBaaS objects are accessible via global L3 routes,
- all virtual IPs are routable from clients, and
- all pool members are routable from BIG-IP devices.

.. figure:: /_static/media/big-ip_undercloud.png
   :scale: 70%
   :alt: Undercloud deployment diagram shows two BIG-IP hardware devices in the service tier of an L3-routed network, external to the OpenStack cloud. The F5 OpenStack LBaaS components reside on the Neutron controller in the application layer in the OpenStack cloud.

\

.. important::

   All L2 and L3 network objects (including routes) must exist on your BIG-IP devices **before** you deploy the |agent| in OpenStack.


If you want to use global routed mode, continue on to :agent:`Run the F5 agent in global routed mode <global-routed-mode.html>`.

.. _l2-adjacent mode:

L2-adjacent mode
----------------

:dfn:`L2-adjacent mode` supports micro-segmentation architectures requiring L2 and L3 routing, including software-defined networks (SDN).
In L2-adjacent mode may utilize VLAN(s) to connect the BIG-IP device(s) to the OpenStack external provider network, with Neutron tenants in VLAN, VXLAN, GRE, or opflex subnets.
In this mode, each tenant has its own dedicated route domain on the BIG-IP system.

**L2-adjacent mode is the default mode of operation** for the |agent|.

In a typical L2-adjacent mode deployment, the BIG-IP devices may have an L2 and/or L3 connection to the physical external network.
They may have direct lines of communication (VXLAN or GRE tunnels) with tenants in the OpenStack cloud, or they may connect to the same VLAN subnet(s) as the Neutron tenants.

.. figure:: /_static/media/f5-lbaas-l2-3-adjacent-mode.png
   :alt: L2-adjacent BIG-IP cluster diagram shows a BIG-IP device cluster as part of an L3-routed network external to the OpenStack cloud. VXLAN or GRE tunnels connect OpenStack tenants directly to the device cluster.
   :scale: 70%

.. important::

   The |agent| L2/L3 segmentation mode settings must match the configurations of your existing external network and BIG-IP device(s).


If you want to use L2-adjacent mode, continue on to :agent:`Run the F5 agent in L2-adjacent mode <l2-adjacent-mode.html>`.

What's Next
-----------

- :ref:`Install the F5 agent and driver <lbaas-quick-start>`
- :agent:`View the  F5 agent configuration options <config-file.html>`
