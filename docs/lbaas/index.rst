.. index::
   single: openstack; concept
   triple: lbaas; agent; driver

.. _openstack-lbaas-home:

F5 Integration for OpenStack Neutron LBaaS
==========================================

The |oslbaas| orchestrates BIG-IP Application Delivery Controllers (ADCs) with OpenStack Networking (Neutron) services.
The Integration consists of the :agent:`F5 Agent for OpenStack Neutron <index.html>` and :driver:`F5 Driver for OpenStack LBaaSv2 <index.html>`, which work together to configure F5 BIG-IP Local Traffic Manager (LTM) objects via the `OpenStack Networking API`_.

.. _os-lbaas-prereqs:

General Prerequisites
---------------------

This documentation set assumes that you:

- already have an operational |os-deployment| with |neutron| and |heat| installed; [#partners]_
- are familiar with `OpenStack Horizon`_ and the `OpenStack CLI`_; and
- are familiar with BIG-IP LTM concepts, the BIG-IP configuration utility, and ``tmsh`` commands.

.. seealso::

   See the :ref:`F5 OpenStack Solution Test Plan <solution test plan>` for information about minimum supported deployments.


|driver-long|
-------------

The :driver:`F5 Driver for OpenStack LBaaSv2 <index.html>`, or |driver|, is F5's OpenStack Neutron LBaaSv2 service provider driver.
It picks up Neutron LBaaS calls from the RPC messaging queue and assigns them to the |agent-long|.

.. figure:: /_static/media/f5-lbaas-architecture.png
   :align: center
   :scale: 100%
   :alt: Diagram showing the architecture of the F5 Integration for OpenStack Neutron LBaaS. A user issues a neutron lbaas command; the F5 LBaaSv2 driver assigns the task from the Neutron RPC messaging queue to the F5 Agent for OpenStack Neutron. The F5 Agent periodically reports its status to the Neutron database.

|agent-long|
------------

The :agent:`F5 Agent <index.html>`, or |agent|, translates from "OpenStack" to "F5".
It receives tasks from the Neutron RPC messaging queue, converts them to `iControl REST`_ API calls (using the `F5 Python SDK`_), and sends the calls to the BIG-IP device(s).

.. figure:: /_static/media/f5-lbaas-agent-to-BIG-IP.png
   :align: center
   :scale: 100%
   :alt: Diagram showing the operation of the F5 Agent for OpenStack Neutron. A user issues a neutron lbaas command; the F5 LBaaSv2 driver assigns the task to the F5 Agent for OpenStack Neutron; the F5 Agent sends the command to the BIG-IP device as an iControl REST API call to add or edit the requested object.

\

.. important::

   The |agent| translates information from the OpenStack Neutron database into BIG-IP system configurations.
   It cannot, however, read existing BIG-IP configurations or non-Neutron network configurations.
   Use the |agent| |config-file| to tell the Agent about the network architecture and the BIG-IP system configurations.


Key OpenStack Concepts
----------------------

.. todo:: add provider networks section; need to note the supported network types (vlan, vxlan, gre, opflex) somewhere; could be in the agent repo instead

.. _lbaas-agent-tenant-affinity:

Agent-Tenant Affinity
`````````````````````

When the Neutron LBaaS plugin loads the |driver|, it creates a global messaging queue.
The |agent-long| sends all callbacks and status updates to this global queue.
The |driver| picks up LBaaS requests from the global messaging queue in a round-robin fashion, then assigns the tasks to an available |agent| instance based on "agent-tenant affinity".


:dfn:`Agent-tenant affinity` is a relationship between an |agent| instance and an OpenStack "tenant", or project.
In brief, once an |agent| handles an LBaaS request for a particular OpenStack tenant, the |agent| has "agent-tenant affinity" with that tenant. That instance will handle all future LBaaS requests for that tenant (with a few caveats, noted below).

How "agent-tenant affinity" applies in LBaaS task assignment:

.. table:: Agent-tenant affinity for a new loadbalancer

   == ============================================================================
   1. You request a new loadbalancer (:code:`neutron lbaas-loadbalancer-create`).
   -- ----------------------------------------------------------------------------
   2. The F5 LBaaSv2 driver checks the Neutron database to find out if an |agent|
      instance already has affinity with the tenant the loadbalancer request is
      for.
   -- ----------------------------------------------------------------------------
   3. If the F5 LBaaSv2 driver finds an |agent| instance that has affinity with
      the loadbalancer's tenant, it assigns the request to that instance.
   -- ----------------------------------------------------------------------------
   4. If the F5 LBaaSv2 driver doesn't find an |agent| instance that has affinity
      with the loadbalancer's :code:`tenant_id`, it selects an active |agent|
      instance at random.

      **The selected instance binds to the requested loadbalancer.**
      It will handle all future LBaaS requests for that loadbalancer.
   == ============================================================================

.. table:: Agent-tenant affinity for an existing loadbalancer

   == ============================================================================
   1. You update an existing loadbalancer
      (:code:`neutron lbaas-loadbalancer-update`).
   -- ----------------------------------------------------------------------------
   2. The F5 LBaaSv2 driver checks the Neutron database to find out if an |agent|
      instance is already bound to the loadbalancer.
   -- ----------------------------------------------------------------------------
   3. If the F5 LBaaSv2 driver doesn't find a bound |agent| instance for the
      loadbalancer, it looks for an instance that has affinity with the
      loadbalancer's tenant, then assigns the request to that instance.
   -- ----------------------------------------------------------------------------
   4. If the F5 LBaaSv2 driver doesn't find an |agent| instance that has affinity
      with the loadbalancer's :code:`tenant_id`, it selects an active |agent|
      instance at random.

      **The selected instance binds to the requested loadbalancer.**
      It will handle all future LBaaS requests for that loadbalancer.
   == ============================================================================

\

.. important::

   If the |agent| bound to a Neutron loadbalancer is inactive, the F5 LBaaSv2 driver looks for other active agents with the same :ref:`environment prefix`.
   The F5 LBaaSv2 driver assigns the task to the first available agent it finds.
   The inactive |agent| remains bound to the loadbalancer, with the expectation that it will eventually come back online and be able to handle future requests.

   **If you delete an** |agent|, you should also delete all of its bound loadbalancers.

   To find all loadbalancers associated with a specific |agent| : ::

      neutron lbaas-loadbalancer-list-on-agent <agent-id>


Partnerships and certifications
-------------------------------

The |oslbaas| provides under-the-cloud multi-tenant infrastructure L4-L7 services for Neutron tenants.
In addition to community OpenStack participation, F5 maintains :ref:`partnerships <f5ospartners>` with several OpenStack platform vendors.
Each partner has a defined certification process that includes requirements for testing the |oslbaas| for vendor and community OpenStack compatibility.
See the :ref:`Solution test plan` for more information.

.. include:: /_static/reuse/see-also-lbaas.rst


.. rubric:: Footnotes
.. [#partners] Unsure how to get started with OpenStack? Consult one of F5's :ref:`OpenStack Platform Partners <f5ospartners>`.

.. _OpenStack Networking API: https://developer.openstack.org/api-ref/networking/v2/
