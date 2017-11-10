.. index::
   :pair: task, lbaas
   :pair: task, F5 agent


How to set up the F5 Agent for Hierarchical Port Binding
========================================================

Overview
--------

This guide demonstrates how to set up the |oslbaas| to use standard :ref:`Hierarchical Port Binding <hpb>` (HPB) or to integrate the |agent| with a `Cisco ACI OpFlex network`_.

Before you begin
````````````````
This document assumes that you already:

- have a functional OpenStack cloud;
- set up all networking components;
- licensed and configured your BIG-IP device(s) for software-defined networking (SDN) (requires a Better or Best license);
- :ref:`installed the F5 Agent and Driver <lbaas-quick-start>`;
- :ref:`set up security groups for BIG-IP in OpenStack <security groups>`.

.. important::

   - If you're managing a BIG-IP device/cluster with multiple instances of the |agent| :ref:`running on different hosts <lbaas-agent-redundancy>`, each instance must use the same ``f5_network_segment_physical_network``.
   - If you're using :ref:`differentiated service environments <lbaas-differentiated-service-env>`, every |agent| in a service group must use the same HPB settings.

Tasks
`````

==================================================================   ==================================================
Task                                                                 Description
==================================================================   ==================================================
:ref:`Set up the F5 Agent for standard HPB <agent-setup-hpb>`        Complete this section if you are using an SDN
                                                                     controller **other than** Cisco APIC.
------------------------------------------------------------------   --------------------------------------------------
:ref:`Set up the F5 Agent for HPB with Cisco APIC & OpFlex`          Complete this section if you are using the |agent|
                                                                     with Cisco APIC, `ACI`_ & `OpenStack OpFlex`_.
------------------------------------------------------------------   --------------------------------------------------
:ref:`Verify your setup <agent-verify-hpb>`.                         Create neutron lbaas objects in a specific
                                                                     network segment to verify your setup.
==================================================================   ==================================================

.. _HPB settings:

HPB settings
------------

========================================================================   ==================================================================
Configuration Parameter                                                    Description
========================================================================   ==================================================================
``agent_id``                                                               Manually configures the F5 Agent's "host" name.

                                                                           For Cisco `ACI`_: corresponds to the ``apic_switch`` parameter in
                                                                           the :file:`ml2_conf_cisco_apic.ini` file; ensures correct mapping
                                                                           for the ACI leaf port.
------------------------------------------------------------------------   ------------------------------------------------------------------
``f5_external_physical_mappings = default:1.1:True``                       *Default setting*; tells the |agent| that BIG-IP 1.1 is a
                                                                           tagged interface connected to the external network
                                                                           (``physnet1`` in the Cisco example).
------------------------------------------------------------------------   ------------------------------------------------------------------
``f5_network_segment_physical_network``                                    Activates HPB; tells Neutron what network segment you're going to
                                                                           create tenant networks in (``physnet1`` in the Cisco example).

                                                                           This should match a mapping used in the ``ml2_type_vlan`` section
                                                                           of the `ML2 driver configuration file`_ (:file:`ML2_conf.ini`).
------------------------------------------------------------------------   ------------------------------------------------------------------
``f5_global_routed_mode = False``                                          *Default setting*; disables the |agent| |grm|.
------------------------------------------------------------------------   ------------------------------------------------------------------
``common_network_ids = <neutron_uuid>:<BIG-IP_network_name>``              Tells the |agent| that a VLAN set up directly on the BIG-IP
                                                                           device corresponds to a specific Neutron network.

                                                                           For example:
                                                                           ``cbbbe1f4-8000-4e8e-92e5-d758962fb26d:external``.
========================================================================   ==================================================================


.. _agent-setup-hpb:

Set up standard HPB
-------------------

#. Edit the |agent| |config-file|:

   .. include:: /_static/reuse/edit-agent-config-file.rst


#. Set the :ref:`HPB settings` as appropriate for your environment.

   .. code-block:: bash
      :caption: Hierarchical Port Binding Example

      ###############################################################################
      #  L2 Segmentation Mode Settings
      ###############################################################################
      #
      f5_external_physical_mappings = default:1.1:True
      #
      ...
      f5_network_segment_physical_network = <name_of_neutron_network>
      #
      f5_network_segment_polling_interval = 10
      #
      f5_pending_services_timeout = 60
      #
      ###############################################################################
      #  L3 Segmentation Mode Settings
      ###############################################################################
      #
      f5_global_routed_mode = False
      #

.. index::
   :triple: lbaas, cisco aci, F5 agent
   :triple: lbaas, opflex, F5 agent

.. _Set up the F5 Agent for HPB with Cisco APIC & OpFlex:

Set up HPB with Cisco APIC/ACI & OpFlex on RedHat OSP
-----------------------------------------------------

.. note::

   The information provided here supplements the `Cisco ACI with OpenStack OpFlex Deployment Guide for Red Hat`_.
   It assumes you have already completed the deployment and network configuration steps in the Cisco Deployment Guide.

   See the :ref:`Cisco APIC/ACI with OpFlex Use Case <understanding cisco aci opflex>` for more information about this deployment.

#. `Configure the OpFlex ML2 Plugin to use Hierarchical Port Binding`_ :fonticon:`fa fa-external`

#. Edit the |agent| |config-file|:

   .. include:: /_static/reuse/edit-agent-config-file.rst

#. Set the :ref:`HPB settings` as appropriate for your environment.

.. important::

   - The Cisco OpFlex plugin identifies the |agent| using the ``agent_ID`` configuration parameter.
   - The |agent| ``f5_network_segment_physical_network`` configuration parameter corresponds to the Neutron external network segment where you want to create LBaaS objects.
     In the example provided here (and in the Cisco deployment guide), ``physnet1`` is the name of this segment.

.. code-block:: bash
   :caption: Example F5 Agent configurations for Cisco ACI

   ###############################################################################
   #  Static Agent Configuration Setting
   ###############################################################################
   #
   agent_id = "f5-lbaasv2"
   #
   ...
   ###############################################################################
   #  L2 Segmentation Mode Settings
   ###############################################################################
   #
   f5_external_physical_mappings = default:1.1:True
   #
   ...
   f5_network_segment_physical_network = physnet1
   #
   f5_network_segment_polling_interval = 10
   #
   f5_pending_services_timeout = 60
   #
   ###############################################################################
   #  L3 Segmentation Mode Settings
   ###############################################################################
   #
   f5_global_routed_mode = False
   #

:fonticon:`fa fa-download` :download:`Download the full example </_static/config_examples/f5-openstack-agent_opflex.ini>`


.. _agent-verify-hpb:

Verify your deployment
----------------------

#. Create LBaaS objects in Neutron

   #. Create a new Neutron load balancer for a subnet in the ``f5_network_segment_physical_network`` set up for the |agent|.
   #. Create one (1) listener on a different subnet.
   #. Create one (1) pool
   #. Create two (2) pool members.

   .. code-block:: console

      neutron lbaas-loadbalancer-create --name lb1 --vip-address <ip_address> <subnet_uuid>
      neutron lbaas-listener-create --name vs1 --loadbalancer lb1 --protocol HTTP --protocol-port 80
      neutron lbaas-pool-create --name pool1 --protocol HTTP --lb-algorithm ROUND_ROBIN --listener vs1
      neutron lbaas-member-create --address <ip_address> --protocol-port 80 --subnet <subnet_uuid> --name member1 pool1

#. Use the BIG-IP configuration utility to verify creation of the partition, virtual server, pool, and pool members.

   - :menuselection:`Local Traffic -> Virtual Servers -> Virtual Server List`
   - :menuselection:`Local Traffic -> Pools -> Pool List`
   - Click the ``2`` in the :guilabel:`Members` column to view the pool members.

You should now be able to send HTTP traffic to the listener (the BIG-IP virtual server) and load balance the traffic between the two pool members.


.. _Cisco ACI OpFlex network: https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/1-x/openstack/b_ACI_with_OpenStack_OpFlex_Architectural_Overview/b_ACI_with_OpenStack_OpFlex_Architectural_Overview_chapter_010.html
.. _ACI: http://www.cisco.com/c/en/us/solutions/data-center-virtualization/application-centric-infrastructure/index.html
.. _OpenStack OpFlex: http://openstack-opflex.ciscolive.com/pod1
.. _Cisco ACI with OpenStack OpFlex Deployment Guide for Red Hat: http://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/1-x/openstack/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat_appendix_0101.html#id_46535
.. _Configure the OpFlex ML2 Plugin to use Hierarchical Port Binding: https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/1-x/openstack/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat_appendix_0101.html#id_46535
.. _Example of the ml2_conf_cisco_apic.ini file: https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/1-x/openstack/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat/b_ACI_with_OpenStack_OpFlex_Deployment_Guide_for_Red_Hat_appendix_0101.html#id_46545
.. _ML2 driver configuration file: https://wiki.openstack.org/wiki/Ml2_conf.ini_File
