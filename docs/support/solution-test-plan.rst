.. _solution test plan:

Solution Test Plan
==================

Introduction
------------

This document outlines the process for validating an Openstack deployment utilizing F5 products to provide Neutron LBaaSv2 (load balancing) services.
It includes use cases that encompass the set of standard F5 OpenStack solution deployments, for testing purposes.

F5 OpenStack Integrated Solutions
`````````````````````````````````

F5 produces integration solutions that orchestrate BIG-IP Application Delivery Controllers (ADC) with OpenStack Networking (Neutron) services.
The F5 OpenStack LBaaSv2 integration provides under-the-cloud multi-tenant infrastructure L4-L7 services for Neutron tenants.

In addition to community OpenStack participation, F5 maintains partnerships with several OpenStack platform vendors.
Each vendor defines a certification process, including test requirements, that expand on or focus tests available in community OpenStack.
This document presumes use of a certified deployment to the extent vendor tests have been, or will be, run to prove the validity of the deployment.

Community OpenStack and platform vendor tests exercise the generic LBaaSv2 integration.
F5 OpenStack tests exercise F5-specific capabilities across multiple network topologies.
They are complementary to community and platform vendor tests.

All F5 OpenStack tests are available in the same open source repository as the product code.
You may execute these tests via tempest and tox -- consistent with the OpenStack community -- to self-validate a deployment.

Use cases derive from real-world scenarios representing repeatable deployments of the most commonly-used F5 OpenStack features.
Use case tests validate the combination of OpenStack, F5 BIG-IP ADC, and F5 OpenStack products.

Prerequisites
-------------

OpenStack
`````````

* Operational OpenStack |openstack| cloud deployed in accordance with minimal documented requirements:

  * Deployment configuration will vary to match test architectures described within each use case;
  * 1 host machine for a Controller node;
  * 1 host machine for a Compute node.

* `BIG-IP Nova flavor </cloud/openstack/v1/support/openstack_big-ip_flavors.html>`_.

TMOS
````

* `Supported TMOS version </cloud/openstack/v1/support/releases_and_versioning.html>`_.
* If using Virtual Edition:

  * LTM_1SLOT KVM qcow2 image built using the supported `BIG-IP onboarding Heat template </products/templates/openstack-heat/latest/f5-bigip-ve_image-patch-upload.html>`_ ;
  * Instance deployed using the supported `BIG-IP VE Standalone, 3-NIC Heat template </products/templates/openstack-heat/latest/f5-bigip-ve_standalone-3nic.html>`_.

* Operational BIG-IP device or device service cluster with `Better or Best license <https://f5.com/products/how-to-buy/simplified-licensing>`_ (including LTM and SDN Services).
* Initial configuration orchestrated to match the deployment architecture, per the `F5 LBaaSv2 documentation </cloud/openstack/v1/lbaas/index.html>`_.

F5 OpenStack LBaaSv2
````````````````````

* :agent:`F5 Agent <index.html>`, F5 driver package, and :driver:`F5 LBaaSv2 Driver <index.html>` installed on all hosts you want to use to provision BIG-IP services. [#f5driver]_
* Agent configured according to the needs of the use case test architecture.

.. [#f5driver] The F5 driver package is available for download at |f5_lbaasv2_driver_shim_url|.

Test Plan
---------

Community OpenStack tests (not required, but recommended) are available to exercise the following key components:

* OpenStack Neutron for network topology deployment;
* OpenStack Nova for test web application deployment;
* OpenStack Neutron for LBaaSv2 service deployment:

  * `Instructions <http://docs.openstack.org/developer/tempest/overview.html>`_ for executing Tempest tests;
  * Tests compatible with F5 OpenStack LBaaSv2 are in the community |community_tempest_lbaasv2_tests| repository.

F5 OpenStack tests exercise the following key components:

* |driver-long| (|f5_lbaasv2_driver_readme|);
* |agent-long| (|f5_agent_readme|).

Each use case requires execution of tests over one or more standard network deployments, detailed below.

Network Architectures
`````````````````````

NA1: Global Routed Mode
~~~~~~~~~~~~~~~~~~~~~~~

Edge deployment architecture using only OpenStack networking provider networks, with |agent| deployed in :ref:`global routed mode`.

.. figure:: /_static/media/f5-lbaas-test-architecture-grm.png
   :align: center
   :alt: Global Routed Mode

NA2: L2 Adjacent Mode
~~~~~~~~~~~~~~~~~~~~~

Micro-segmentation architecture using tenant networks, with F5 agents deployed in `L2 Adjacent Mode </products/openstack/agent/latest/l2-adjacent-mode.html>`_.
Execute tests for VLAN and then VxLAN network types.

.. figure:: /_static/media/f5-lbaas-test-architecture-l2adj.png
   :align: center
   :alt: L2 Adjacent Mode

F5 OpenStack tests supplement the community tests and exercise F5 LBaaS-specific features.

Use Cases
`````````

UC1: Community LBaaSv2
~~~~~~~~~~~~~~~~~~~~~~

This use case focuses on basic integration of BIG-IP LTM to provide services through the OpenStack LBaaSv2 API.
LBaaSv2 features tested include load balancers, listeners, pools, members, and monitors.
LTM features tested include virtual servers, client TLS decryption, http profiles, multiple pools, cookie persistence, and monitored pool members.
OpenStack networking APIs provide pool member state and virtual server statistics.

.. table:: Use Case 1 Requirements

   +---------------+-------------------------------+
   | Category      | Requirements                  |
   +---------------+-------------------------------+
   | Architectures | 1, 2                          |
   +---------------+-------------------------------+
   | Tests         | neutron-lbaas                 |
   |               |                               |
   |               | f5-openstack-lbaasv2-driver   |
   +---------------+-------------------------------+

