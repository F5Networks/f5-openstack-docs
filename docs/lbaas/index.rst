.. _openstack-lbaas-home:

F5 Integration for OpenStack Neutron LBaaS
==========================================

The |oslbaas| orchestrates BIG-IP Application Delivery Controllers (ADCs) with OpenStack Networking (Neutron) services.
The Integration consists of the `F5 Agent for OpenStack Neutron`_ and `F5 Driver for OpenStack LBaaSv2`_, which work together to configure F5 BIG-IP Local Traffic Manager (LTM) objects via the `OpenStack Networking API`_.

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

The |driver-link|, or |driver|, is F5's OpenStack Neutron LBaaSv2 service provider driver.
It picks up Neutron LBaaS calls from the RPC messaging queue and assigns them to the |agent-long|.

.. figure:: /_static/media/f5-lbaas-architecture.png
   :align: center
   :scale: 100%
   :alt: Diagram showing the architecture of the F5 Integration for OpenStack Neutron LBaaS. A user issues a neutron lbaas command; the F5 LBaaSv2 driver assigns the task from the Neutron RPC messaging queue to the F5 Agent for OpenStack Neutron. The BIG-IP Controller periodically reports its status to the Neutron database.

   F5 Integration for OpenStack Neutron LBaaS Architecture


|agent-long|
------------

The |agent-link|, or |agent|, translates from "OpenStack" to "F5".
It receives tasks from the Neutron RPC messaging queue, converts them to `iControl REST`_ API calls (using the `F5 Python SDK`_), and sends the calls to the BIG-IP device(s).

.. figure:: /_static/media/f5-lbaas-agent-to-BIG-IP.png
   :align: center
   :scale: 100%
   :alt: Diagram showing the operation of the F5 Agent for OpenStack Neutron. A user issues a neutron lbaas command; the F5 LBaaSv2 driver assigns the task to the F5 Agent for OpenStack Neutron; the BIG-IP Controller sends the command to the BIG-IP device as an iControl REST API call to add or edit the requested object.

   F5 Agent for OpenStack Neutron traffic flow

Key OpenStack Concepts
----------------------

.. _lbaas-agent-tenant-affinity:

Agent-Tenant Affinity
`````````````````````

When the Neutron LBaaS plugin loads the |driver|, it creates a global messaging queue.
The |agent-long| sends all callbacks and status updates to this global queue.
The |driver| picks up LBaaS requests from the global messaging queue in a round-robin fashion, then assigns the tasks to an available |agent| instance based on "agent-tenant affinity".


:dfn:`Agent-tenant affinity` is a relationship between an |agent| instance and an OpenStack "tenant", or project.
In brief, once an |agent| handles an LBaaS request for a particular OpenStack tenant, the |agent| has "agent-tenant affinity" with that tenant. That instance will handle all future LBaaS requests for that tenant (with a few caveats, noted below).

How "agent-tenant affinity" applies in LBaaS task assignment:

.. table:: Agent-tenant affinity for a new load balancer

   == ============================================================================
   1. You request a new load balancer (:code:`neutron lbaas-loadbalancer-create`).
   -- ----------------------------------------------------------------------------
   2. The F5 LBaaSv2 driver checks the Neutron database to find out if an |agent|
      instance already has affinity with the tenant the load balancer request is
      for.
   -- ----------------------------------------------------------------------------
   3. If the F5 LBaaSv2 driver finds an |agent| instance that has affinity with
      the load balancer's tenant, it assigns the request to that instance.
   -- ----------------------------------------------------------------------------
   4. If the F5 LBaaSv2 driver doesn't find an |agent| instance that has affinity
      with the load balancer's :code:`tenant_id`, it selects an active |agent|
      instance at random.

      **The selected instance binds to the requested load balancer.**
      It will handle all future LBaaS requests for that load balancer.
   == ============================================================================

.. table:: Agent-tenant affinity for an existing load balancer

   == ============================================================================
   1. You update an existing load balancer
      (:code:`neutron lbaas-loadbalancer-update`).
   -- ----------------------------------------------------------------------------
   2. The F5 LBaaSv2 driver checks the Neutron database to find out if an |agent|
      instance is already bound to the load balancer.
   -- ----------------------------------------------------------------------------
   3. If the F5 LBaaSv2 driver doesn't find a bound |agent| instance for the
      load balancer, it looks for an instance that has affinity with the
      load balancer's tenant, then assigns the request to that instance.
   -- ----------------------------------------------------------------------------
   4. If the F5 LBaaSv2 driver doesn't find an |agent| instance that has affinity
      with the load balancer's :code:`tenant_id`, it selects an active |agent|
      instance at random.

      **The selected instance binds to the requested load balancer.**
      It will handle all future LBaaS requests for that load balancer.
   == ============================================================================



.. important::

   If the |agent| bound to a load balancer is inactive, the F5 LBaaSv2 driver looks for other active agents with the same :ref:`environment prefix`.
   The F5 LBaaSv2 driver assigns the task to the first available agent it finds.
   The inactive |agent| remains bound to the load balancer, with the expectation that it will eventually come back online and be able to handle future requests.

   **If you delete an** |agent|, you should also delete all of its bound load balancers.

   To find all load balancers associated with a specific |agent| : ::

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
