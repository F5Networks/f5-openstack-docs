.. index::
   single: F5 Agent; Differentiated service environments

.. _lbaas-differentiated-service-env:

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

Run multiple F5 Agents in different environments
================================================

You can manage the same BIG-IP device or cluster with multiple instances of the |agent-long| when the instances run in differentiated service environments.
A :dfn:`differentiated service environment` is a uniquely-named environment that has:

- a dedicated |driver|,
- a dedicated messaging queue, and
- a dedicated |agent|.

In a multiple-agent setup, each |agent| manages a distinct environment that corresponds to a specific BIG-IP partition.

.. important::

   - The |env-generator|, a tool built in to the |driver-long|, creates new service environments for you and configures Neutron to use the new service provider drivers.

   - Differentiated service environments are not compatible with `Virtual Clustered Multiprocessing`_ (vCMP) systems.
     BIG-IP devices cannot share data or resources across differentiated service environments; this precludes the use of vCMP because vCMP guests share global VLAN IDs

:fonticon:`fa fa-chevron-right` :ref:`Learn more <learn-diff-svcs>`

Set up a new service environment
--------------------------------

#. Generate a new custom environment on the Neutron controller.

   .. code-block:: console
      :caption: Example: Add a custom environment called "dev1"

      add_f5agent_environment dev1

   .. tip::

      The environment name field must be eight (8) characters or less.

#. Check the Neutron LBaaS configuration file to verify that the new service provider driver is active.

   .. code-block:: console
      :emphasize-lines: 5

      less /etc/neutron/neutron_lbaas.conf
      ...
      [service_providers]
      service_provider = LOADBALANCERV2:F5Networks:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver:default
      service_provider = LOADBALANCERV2:dev1:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver
      ...

.. _environment prefix:

Set up |agent| to use the new environment
-----------------------------------------

In the |agent| |config-file|:

#. Replace the default :code:`environment_prefix` with the name of the new service environment.

   .. code-block:: console

      vi /etc/neutron/services/f5/f5-openstack-agent.ini
      #
      # environment_prefix = 'dev1'
      #

#. Add/update the iControl endpoints and login credentials for the BIG-IP devices you want to include in the service group.

   .. code-block:: console

      #
      icontrol_hostname = 1.2.3.4, 5.6.7.8
      #
      ...
      #
      icontrol_username = myusername
      ...
      #
      icontrol_password = mypassword
      #

#. Save the file with a new name.

   .. code-block:: console
      :caption: Example

      :w f5-openstack-agent_dev1.ini

Set up the new environment on additional hosts
``````````````````````````````````````````````

.. rubric:: [OPTIONAL]

Take the step below if you want to run the |agent| in differentiated service environments on multiple hosts. [#multihost]_

#. Copy the |agent|, Neutron, and Neutron LBaaS configuration files from the Neutron controller to each additional host.

   .. code-block:: console

      cp /etc/neutron/services/f5/f5-openstack-agent_dev1.ini <hostname>:/etc/neutron/services/f5/f5-openstack-agent_dev1.ini
      cp /etc/neutron/neutron.conf <hostname>:/etc/neutron/neutron.conf
      cp /etc/neutron/neutron_lbaas.conf <hostname>:/etc/neutron/neutron_lbaas.conf

Restart the services
--------------------

#. Restart Neutron.

   .. include:: /_static/reuse/restart-neutron.rst

#. Restart the |agent|.

   .. include:: /_static/reuse/restart-f5-agent.rst

   .. important::

      Restart the |agent| on each host to which you copied the updated configuration file.

Create a load balancer in the new service environment
-----------------------------------------------------

#. When you create a new load balancer, pass in the name of the new service environment using the :code:`--provider` flag.

   .. code-block:: console

      (neutron) lbaas-loadbalancer-create --name lb_dev1 --provider dev1 b3fa44a0-3187-4a49-853a-24819bc24d3e
      Created a new loadbalancer:
      +---------------------+--------------------------------------+
      | Field               | Value                                |
      +---------------------+--------------------------------------+
      | admin_state_up      | True                                 |
      | description         |                                      |
      | id                  | fcd874ce-6dad-4aef-9e69-98d1590738cd |
      | listeners           |                                      |
      | name                | lb_dev1                              |
      | operating_status    | OFFLINE                              |
      | provider            | dev1                                 |
      | provisioning_status | PENDING_CREATE                       |
      | tenant_id           | 1b2b505dafbc487fb805c6c9de9459a7     |
      | vip_address         | 10.1.2.7                             |
      | vip_port_id         | 079eb9e5-dc63-4dbf-bc15-f38f5fdeee92 |
      | vip_subnet_id       | b3fa44a0-3187-4a49-853a-24819bc24d3e |
      +---------------------+--------------------------------------+

   .. note::

      Specifying the service provider driver determines which LBaaS driver messaging queue receives the task and, ultimately, which BIG-IP device/cluster gets the requested load balancer.

.. _learn-diff-svcs:

Learn more
----------

When the |agent-long| uses the default service environment prefix -- :code:`Project` -- the |driver-long| assigns LBaaS tasks to each |agent| instance from the global messaging queue.

When you create a new service environment (for example, "dev", "prod", "test", etc.), you're really creating a new LBaaS service provider driver and uniquely-named messaging queue.
The F5 environment generator creates the driver and adds it to the service providers list in the Neutron LBaaS config file.
When you issue a :code:`neutron lbaas-loadbalancer-create` command with the :code:`--provider` flag, that |driver| instance receives the task in its dedicated messaging queue; it then assigns the task to an |agent| instance in its environment group.
By default, |agent| instances in an environment group receive tasks in a round-robin fashion; you can set up :ref:`capacity-based scale out <lbaas-capacity-based-scaleout>` for a greater degree of control over how the |driver-long| chooses which |agent| instances receive tasks.

Use Case
````````

Use differentiated service environments if:

A. You want to run multiple |agent| instances **on the same host** to manage the same BIG-IP device/cluster.
   Each unique service environment corresponds to a distinct BIG-IP partition, so the |agent| processes don't overlap and cause errors.

B. You want a finer degree of control over which BIG-IP device the |agent| creates LBaaS objects on.
   In the default set-up, the |driver-long| assigns tasks from the global messaging queue to the first available |agent| instance it finds.
   This means that, when using the default environment, you can't control which BIG-IP device gets any given object.
   Custom service environments allow you to specify which |agent| instance/group -- and, therefore, which BIG-IP device/cluster -- should handle a given LBaaS task.

.. rubric:: Footnotes
.. [#multihost] Running |agent| instances on one (1) or more additional hosts provides redundancy and a degree of protection against individual host failure. See :ref:`F5 Agent for OpenStack Neutron Redundancy and Scale-out <lbaas-agent-redundancy>` for more information.

.. _Virtual Clustered Multiprocessing: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/vcmp-administration-appliances-12-1-1/1.html
