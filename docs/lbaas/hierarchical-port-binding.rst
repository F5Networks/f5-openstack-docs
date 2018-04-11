:product: F5 Agent for OpenStack Neutron
:type: tutorial

.. _lbaas-port-binding:

.. _hpb:

Hierarchical Port Binding
=========================

.. sidebar:: :fonticon:`fa fa-info-circle` Version notice:

   Introduced in |agent| v9.3.0 (Mitaka) and 10.0.0 (Newton)

Overview
--------

Neutron `Hierarchical Port Binding`_ (HPB) allows users to dynamically allocate network segments for nodes connected to a switch fabric.

HPB relies on the `Neutron ML2`_ drivers to identify network types and manage network resources.
The |oslbaas| supports HPB on "vlan" and "opflex" networks. [#opflex]_

When using HPB, the |agent| needs to know which external provider network the BIG-IP device(s) connects to.
This information allows the |agent| to discover Neutron provider attributes in that network and create corresponding network and LTM objects on the BIG-IP device(s).


Use Case - standard
-------------------

A "standard" HPB deployment uses the built-in OpenStack ML2 drivers.
It doesn't depend on any one SDN controller or ML2 driver plugin to function.
In this deployment, the |agent| can create services on networks with ``type: vlan``

In this use case, you can create LBaaS objects on an :term:`undercloud` physical BIG-IP device/cluster for VLANs that are dynamically created in a specific network segment.
As noted in the OpenStack documentation, this can be useful if you need your Neutron deployment to scale beyond the 4K-VLANs-per-physical network limit. [#osvlans]_

.. figure:: /_static/media/lbaasv2_hierarchical-port-binding.png
   :alt: F5 LBaaSv2 Hierarchical Port Binding
   :scale: 60%

   F5 LBaaSv2 Hierarchical Port Binding

\

.. seealso::

   :ref:`Set up the F5 Agent for standard HPB <agent-setup-hpb>`


.. index::
   :pair: cisco aci, F5 agent
   :pair: cisco apic, F5 agent
   :pair: openstack opflex, F5 agent

.. _understanding cisco aci opflex:

Use Case - Cisco APIC/ACI, OpenStack OpFlex, and Red Hat OSP
------------------------------------------------------------

This HPB deployment is specific to the `Cisco ACI with OpenStack OpFlex Deployment Guide for Red Hat`_.
It requires the use of the Cisco Application Policy Infrastructure Controller (APIC) and Application Centric Infrastructure (ACI) fabric; `Red Hat OpenStack Platform`_ ; and the `OpenStack OpFlex`_ ML2 plugin driver.
In this deployment, the |agent| can create services on networks with ``type: vlan`` **or** ``type: opflex``.

.. note::

   This use case describes a reference architecture developed in partnership with Cisco and Red Hat.

Network topology
````````````````

For this use case, the test topology consists of:

- a small ACI Spine/Leaf network fabric;
- 1 APIC cluster used to manage the fabric;
- 1 OpenStack Neutron controller;
- 2 OpenStack compute nodes;
- 1 2-NIC BIG-IP device.

.. seealso::

   `Cisco Network Topology diagram <https://www.cisco.com/c/dam/en/us/td/i/500001-600000/500001-510000/501001-502000/501175.jpg>`_.


.. table:: Physical Connectivity

   =========================  =================================================
   Interface                  Network connection
   =========================  =================================================
   BIG-IP mgmt interface      OpenStack management/api network
   BIG-IP NIC 1 (e.g., 1.1)   **External network not managed by Neutron**
   BIG-IP NIC 2 (e.g., 1.2)   Leaf switch ports in ACI fabric
   OpenStack compute nodes    Leaf switch ports in ACI fabric
   =========================  =================================================

Segmented VLANs from a specified VLAN pool (1600-1799) will carry traffic between the Neutron networks and the BIG-IP device.
The BIG-IP device connects directly to an external network to simplify VIP allocation.

BIG-IP device setup
```````````````````

- Two (2) VLANS configured in the ``Common`` partition: "external" and "internal".
- "Internal" connects to a switch port in the ACI fabric.
- "External" connects to the external network (which Neutron doesn't know about).
- Each network has a self IP with the following properties:

  - Netmask: 255.255.255.0
  - Traffic Group: ``traffic-group-local-only``
  - Partition: ``Common``

.. note::

   You do not need to manually configure the VLANs in the VLAN pool on the BIG-IP device; HPB and the |agent| will create them automatically.

ACI setup
`````````

- Follow the `Cisco ACI with OpenStack OpFlex Deployment Guide for Red Hat`_ to set up ACI, OpenStack, and the OpFlex ML2 plugin.
- Create a VLAN pool in your desired range (1600-1799, in this example).
- Create a physical domain for the BIG-IP device.
- Associate the physical domain with the VLAN pool and AEP you created for the OpenStack plugin.

Neutron setup
`````````````

- Two (2) subnets -- Net100 and Net101
- Dummy network; this is a flat network created using the CIDR for the external network connected to BIG-IP interface 1.1.
- L3-Out network representing traffic back out to the external network core.

Adding the "dummy" network to Neutron lets Neutron and the BIG-IP device reserve IPs from the network for allocation to LBaaS objects.

Testing
```````

- Deploy a Neutron loadbalancer on subnet "Net100".
- Create a listener (virtual server) on the loadbalancer.
- Add a pool and two (2) members to the pool in subnet "Net101".
- Send traffic to the loadbalancer and verify that it is load balanced across the BIG-IP pool member endpoints.


.. seealso::

   :ref:`Set up the F5 Agent for HPB with Cisco APIC & OpFlex`

.. rubric:: Footnotes
.. [#opflex] The `Cisco OpFlex <http://openstack-opflex.ciscolive.com/pod1>`_ ML2 plugin allows integration of the |agent| with Cisco ACI Fabric.
.. [#osvlans] `OpenStack ML2 Hierarchical Port Binding specs <https://specs.openstack.org/openstack/neutron-specs/specs/kilo/ml2-hierarchical-port-binding.html#problem-description>`_.



.. _hierarchical port binding: https://specs.openstack.org/openstack/neutron-specs/specs/kilo/ml2-hierarchical-port-binding.html
.. _ML2: https://wiki.openstack.org/wiki/Neutron/ML2
.. _system configuration: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-initial-configuration-13-0-0/2.html
.. _local traffic management: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0.html
.. _device service clustering: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-admin-13-0-0.html
.. _BIG-IP license: https://f5.com/products/how-to-buy/simplified-licensing
.. _Cisco ACI: https://www.cisco.com/c/en/us/solutions/data-center-virtualization/application-centric-infrastructure/index.html#~overview?dtid=osscdc000283
.. _Neutron ML2: https://wiki.openstack.org/wiki/Neutron/ML2
.. _Cisco ACI with OpenStack OpFlex Deployment Guide for Red Hat: http://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/1-x/openstack/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat_appendix_0101.html#id_46535
.. _Red Hat OpenStack Platform: https://www.redhat.com/en/technologies/linux-platforms/openstack-platform
.. _OpenStack OpFlex: http://openstack-opflex.ciscolive.com/pod1