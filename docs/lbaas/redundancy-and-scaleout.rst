.. _lbaas-agent-redundancy:

Manage a BIG-IP device with multiple F5 Agents on different hosts
=================================================================

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

Overview
--------

Using multiple instances of the |agent| to manage the same BIG-IP device or cluster provides redundancy and scaleout, helping to ensure that the |agent| and |driver| processes remain alive and functional if a host goes down.

:ref:`Learn more <learn-rso>` :fonticon:`fa fa-chevron-right`

Prerequisites
`````````````

- Administrator access to both the BIG-IP device(s) and the OpenStack cloud.
- All hosts running the |oslbaas| must have the Neutron and Neutron LBaaS packages installed.
- All hosts running the |oslbaas| must use the same Neutron database.

Caveats
```````

.. danger::

   **Do not** use multiple |agent| instances that are running on the same host to manage the same BIG-IP device or :term:`cluster`.
   Doing so will cause errors and may lead to a loss of service.

The standard multi-agent deployment doesn't allow you to specify which |agent| you want to use to create a new load balancer (meaning it's also not possible to specify on which BIG-IP device/cluster you want to create objects).
**If you need a greater degree of control** over which |agent| handles specific LBaaS requests, use :ref:`differentiated service environments <lbaas-differentiated-service-env>` instead.

Set up the F5 Agent on multiple hosts
-------------------------------------

#. Copy the Neutron and Neutron LBaaS configuration files from the Neutron controller to each host on which you want to run an |agent| instance.

   .. code-block:: console

      cp /etc/neutron/neutron.conf <hostname>:/etc/neutron/neutron.conf
      cp /etc/neutron/neutron_lbaas.conf <hostname>:/etc/neutron/neutron_lbaas.conf

#. :ref:`Install the F5 Agent for OpenStack Neutron <lbaas-quick-start>` on each host.

#. Set up the |agent| `configuration file`_ to suit the needs of your environment.

#. Copy your |agent| configuration file from the Neutron controller to each host.

   .. code-block:: console

      cp /etc/neutron/services/f5/f5-openstack-agent.ini <hostname>:/etc/neutron/services/f5/f5-openstack-agent.ini

   .. warning::

      **F5 does not recommend** using `Configuration synchronization`_ (also referred to as "config sync") with the |agent|.
      The |agent| expects to manage each device directly. [#configsync]_

      * If you're using config sync on a device pair or cluster:

        - Set the :code:`ha_type` to :code:`standalone`.
        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the pair or cluster.

      * If you're using config sync for a :term:`device group` within a :term:`device service cluster`:

        - Set the :code:`ha_type` to :term:`pair` or :term:`scalen`.
        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the device group **and** the endpoint for a BIG-IP device outside the group (:code:`pair`).

          --OR--

        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the device group and the endpoint for each device in the cluster that doesn't automatically sync configurations with the group. (:code:`scalen`)

#. Start the |agent| on each host.

   .. include:: /_static/reuse/start-f5-agent.rst


.. _learn-rso:

Learn more
----------

Spreading the request load for an environment across multiple |agent| instances helps to avoid |agent| overload and loss of functionality.
In order to manage a BIG-IP device, pair, or cluster with multiple |agent| s, each |agent| **must** run on a separate host.

In general terms: "host" could mean a virtual machine or a Nova compute node.
The key takeaway is that the ``host`` name for each |agent| must be unique.

If you are well-versed in containerized environments, you can run each |agent| instance in a separate container on your Neutron controller.
If using a container deployment:

- The :file:`neutron.conf` and :file:`neutron-lbaas.conf` files must be present in each container.
- The service provider driver **does not** need to run in the container if you're building it from the Neutron controller (in other words, if the service provider driver is in the container's build context).

.. warning::

   **F5 Networks does not support container service deployments in OpenStack.**



.. seealso::

   * `Configure the F5 Agent for OpenStack Neutron`_
   * :ref:`Manage BIG-IP Clusters with F5 LBaaSv2 <lbaas-manage-clusters>`
   * :ref:`Differentiated Service Environments <lbaas-differentiated-service-env>`


.. rubric:: Footnotes
.. [#configsync] See :ref:`Manage BIG-IP clusters <lbaas-manage-clusters>` for more information.

.. _configuration synchronization: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-0-0/5.html
