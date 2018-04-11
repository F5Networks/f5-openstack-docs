:product: F5 Agent for OpenStack Neutron
:type: reference

.. _lbaas-basic-env-requirements:

Basic Environment Requirements
==============================

.. include:: /_static/reuse/applies-to-ALL.rst

This document provides the minimum basic requirements for using the |oslbaas| in OpenStack.

OpenStack Requirements
----------------------

The `OpenStack installation guides`_ cover the requirements for specific environments.

We recommend that you install and configure the following OpenStack services.
Each of these is necessary for one or more F5 OpenStack integrations.

+-------------+-------------------------+-----------------------+
| Service     | Description             | F5 Integration        |
+=============+=========================+=======================+
| `Nova`_     | compute service         | LBaaSv2, Heat         |
+-------------+-------------------------+-----------------------+
| `Neutron`_  | networking              | LBaaSv2               |
+-------------+-------------------------+-----------------------+
| `Keystone`_ | identity                | LBaaSv2, Heat         |
+-------------+-------------------------+-----------------------+
| `Glance`_   | image service           | Heat                  |
+-------------+-------------------------+-----------------------+
| `Horizon`_  | dashboard               | LBaaSv2 [#lb]_, Heat  |
+-------------+-------------------------+-----------------------+
| `Heat`_     | orchestration           | Heat                  |
+-------------+-------------------------+-----------------------+
| `Barbican`_ | key management          | LBaaSv2               |
+-------------+-------------------------+-----------------------+


BIG-IP Device Requirements
--------------------------

.. important::

   - You must have the appropriate `license`_ for the BIG-IP features you wish to use.
   - All numbers shown in the table below are per BIG-IP device.


.. table:: BIG-IP Requirements

   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | Deployment                           | NICs   | VLANs [#vlans]_ | Tunnels [#tunnels]_ | VTEPs [#vteps]_ | License        |
   +======================================+========+=================+=====================+=================+================+
   | :term:`Standalone` :term:`overcloud` | 2      | 2               | n/a                 | n/a             | any            |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | Standalone :term:`undercloud`        | 2      | 2               | 1                   | 1               | better or best |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | :term:`Pair` overcloud               | 3      | 3               | n/a                 | n/a             | any            |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | Pair undercloud                      | 3      | 3               | 1                   | 1               | better or best |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | :term:`Scalen`                       | 3      | 3               | n/a                 | n/a             | any            |
   | :term:`cluster` overcloud            |        |                 |                     |                 |                |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+
   | Scalen cluster undercloud            | 3      | 3               | 1                   | 1               | better or best |
   +--------------------------------------+--------+-----------------+---------------------+-----------------+----------------+



.. seealso::

   - :ref:`F5 OpenStack Releases and Support Matrix <releases-and-support>`
   - `BIG-IP LTM Release Notes`_

.. rubric:: Footnotes
.. [#lb] The LBaaSv2 dashboard panels are available in OpenStack Mitaka and later releases.
.. [#vlans] Two VLANS = data & management. Three VLANS = data, management, and HA. See `Configuring the basic BIG-IP network`_ for more information.
.. [#tunnels] Tunnels can be either VxLAN or GRE.
.. [#vteps] If you're using a tunnel to reach an undercloud BIG-IP, you must configure the BIG-IP virtual tunnel endpoint (VTEP) **before** launching the |agent|.


.. _BIG-IP LTM Release Notes: https://support.f5.com/csp/knowledge-center/software/BIG-IP?module=BIG-IP%20LTM&version=13.0.0
