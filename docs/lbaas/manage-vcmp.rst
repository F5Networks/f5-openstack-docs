:product: F5 Agent for OpenStack Neutron
:product: F5 Driver for Neutron LBaaSv2
:type: tutorial

.. _lbaas-manage-vcmp-clusters:

.. _lbaas-manage-vcmp-systems:

Manage BIG-IP vCMP Systems
==========================

.. sidebar:: :fonticon:`fa fa-info-circle` Version notice:

   Introduced in |agent| v9.1.0 (Mitaka) and 10.0.0 (Newton)

You can manage a BIG-IP using `Virtual Clustered Multiprocessing`_ (vCMP) with the |oslbaas|.

:fonticon:`fa fa-chevron-right` :ref:`Learn more <learn-vcmp>`

Prerequisites
-------------

- Licensed, operational `BIG-IP chassis`_ with support for vCMP.
- Licensed, operational BIG-IP vCMP guest running on a vCMP host.
- Administrative access to the vCMP host(s) and guest(s) you will manage with F5 LBaaSv2.
- :agent:`F5 Agent <index.html>` and :driver:`F5 Driver <index.html>` installed on the Neutron controller.
- Knowledge of `BIG-IP vCMP <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/vcmp-administration-appliances-12-1-1/1.html>`_ configuration and administration.

Caveats
-------
.. todo:: check whether the below is still true.

- VLAN and FLAT are the only network types supported for use with vCMP.

Configuration
-------------

Edit the |driver-settings| and |l2-seg| sections of the |agent| |config-file|.

#. Add the ``icontrol_vcmp_hostname``. Multiple values can be comma-separated.

   .. code-block:: text

      #
      icontrol_vcmp_hostname = 1.2.3.4
      #

#. Configure the ``icontrol_hostname`` parameter with the IP address(es) of the vCMP guest(s):

   .. code-block:: text

      #
      icontrol_hostname = 10.11.12.13, 14.15.16.17
      #

#. Set ``advertised_tunnel_types`` to ``vlan`` or ``flat``, as appropriate for your environment.

   .. tip::

      Leave the ``advertised_tunnel_types`` setting empty (as in the example below) if the ML2 plugin ``provider:network_type`` is FLAT or VLAN.

   .. code-block:: text

      #
      advertised_tunnel_types =
      #

.. _learn-vcmp:

Learn more
----------

`Virtual Clustered Multiprocessing`_ lets you run multiple instances of BIG-IP software on a single hardware platform.
The :term:`vCMP host` allocates a share of the hardware resources to each :term:`vCMP guest`.
Each guest has its own management IP address, self IP addresses, virtual servers, and so on.
Each guest can receive and process application traffic with no knowledge of other guests on the system.
vCMP  allows you to delegate management of BIG-IP instances, meaning users who need to manage LBaaS objects don't need to have full administrative access to the BIG-IP device.

Use Case
--------

The |agent| can manage one (1) or more vCMP hosts with one (1) or more guests per host.
You can configure vCMP hosts as a :term:`device service cluster`. [#vcmpcluster]_
If a vCMP host fails (taking its guests with it), another vCMP host in the cluster can take over managing its traffic.


.. rubric:: Footnotes
.. [#vcmpcluster] See `Device Service Clustering for vCMP Systems <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/vcmp-administration-appliances-12-1-1/4.html>`_


.. _Virtual Clustered Multiprocessing: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/vcmp-administration-appliances-12-1-1/1.html
.. _BIG-IP chassis: https://f5.com/products/deployment-methods/hardware
