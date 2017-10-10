.. _lbaas-agent-redundancy:

Redundancy and Scale Out
========================

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

Running the |agent| on different hosts helps ensure that the |agent| and |driver| processes remain alive and functional if a host goes down.
Multiple |agent| instances can manage a single BIG-IP device or :term:`cluster` if **each runs on a separate host**.

:fonticon:`fa fa-chevron-right` :ref:`Learn more <learn-rso>`

Prerequisites
-------------

- Administrator access to both the BIG-IP device(s) and the OpenStack cloud.
- All hosts running the F5 Integration for OpenStack must have the Neutron and Neutron LBaaS packages installed.
- All hosts running the F5 Integration for OpenStack must use the same Neutron database.

Caveats
-------

- You **can not run multiple** |agent| **instances on the same host** to manage the same BIG-IP device or :term:`cluster`.
- In the standard multi-agent deployment, you can't specify which |agent| instance you want to use to create a new load balancer (meaning you can't choose which BIG-IP device/cluster to create the new partition on).
- Use :ref:`differentiated service environments <lbaas-differentiated-service-env>` if you need a greater degree of control over which |agent| instance(s) handle specific LBaaS requests.

Configuration
-------------

#. Copy the Neutron and Neutron LBaaS configuration files from the Neutron controller to each host on which you want to run an |agent| instance.

   .. code-block:: console

      cp /etc/neutron/neutron.conf <hostname>:/etc/neutron/neutron.conf
      cp /etc/neutron/neutron_lbaas.conf <hostname>:/etc/neutron/neutron_lbaas.conf

#. :ref:`Install the F5 Agent for OpenStack Neutron <lbaas-quick-start>` on each host.

#. Copy your |agent| configuration file from the Neutron controller to each host.

   .. code-block:: console

      cp /etc/neutron/services/f5/f5-openstack-agent.ini <hostname>:/etc/neutron/services/f5/f5-openstack-agent.ini

   .. tip::

      * If you are managing an :term:`active-standby pair` or :term:`cluster` with `config sync`_ turned on: [#configsync]_

        - Set the :code:`ha_type` to :code:`standalone`.
        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the cluster.

      * If you are managing a :term:`cluster` that has `config sync`_ turned on for a :term:`device group` within the cluster:

        - Set the :code:`ha_type` to :term:`pair` or :term:`scalen`.
        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the device group and the endpoint for a device outside the group (:code:`pair`).

          --OR--

        - Provide the iControl endpoint for one (1) of the BIG-IP devices in the device group and the endpoint for each device in the cluster that is not automatically syncing its configurations with the group. (:code:`scalen`)

#. Start the |agent| on each host.

   .. include:: /_static/reuse/start-f5-agent.rst


.. _learn-rso:

Learn more
----------

Spreading the request load for an environment across multiple |agent| instances helps to avoid |agent| overload and loss of functionality.

If you are well versed in containerized environments, you can run each |agent| instance in a separate container on your Neutron controller.
If the service provider driver is in the container's build context, you don't need to install it in each container.

- The :file:`neutron.conf` and :file:`neutron-lbaas.conf` files must be present in each container.
- The service provider driver **does not** need to run in the container if you're building from the Neutron controller.

.. warning::

   **F5 Networks does not support container service deployments in OpenStack.**


.. seealso::

   * :agent:`Configure the F5 Agent <index.html#configure-the-f5-agent>`
   * :ref:`Manage BIG-IP Clusters with F5 LBaaSv2 <lbaas-manage-clusters>`
   * :ref:`Differentiated Service Environments <lbaas-differentiated-service-env>`


.. rubric:: Footnotes
.. [#configsync] Using configuration synchronization in clusters managed by the |oslbaas| is not recommended. See :ref:`Manage BIG-IP clusters <lbaas-manage-clusters>` for more information.

.. _config sync: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-0-0/5.html
