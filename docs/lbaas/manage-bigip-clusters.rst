.. _lbaas-manage-clusters:

Manage BIG-IP Clusters
======================

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

You can use the |oslbaas| to manage BIG-IP :term:`device service clusters` with :term:`high availability`, :term:`mirroring`, and :term:`failover` services in your OpenStack cloud.

Clustering provides a greater degree of redundancy than a standalone device offers.
It helps to avoid service interruptions that could otherwise occur if a device should go down.

:fonticon:`fa fa-chevron-right` :ref:`Learn more <learn-clusters>`

Prerequisites
-------------

- Administrator access to both BIG-IP devices and OpenStack cloud.
- Licensed, operational BIG-IP :term:`device service cluster`.

  .. tip::

     If you do not already have a BIG-IP cluster deployed in your network, you can use the `F5 BIG-IP: Active-Standby Pair <products/templates/openstack-heat/f5_supported/f5-bigip-ve_active-standby-pair.html>`_ Heat template to create an :term:`overcloud` `sync-failover device group <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-system-device-service-clustering-administration-13-0-0/4.html>`_.

Caveats
-------

- The |agent-long| can manage clusters of two (2) to four (4) BIG-IP devices.
  Active-standby, or "pair", mode applies to two-device clusters; scalen applies to clusters of more than two (2) devices.
- The administrator login must be the same on all BIG-IP devices in the cluster.
- F5 strongly advises against using `configuration synchronization`_ in clusters managed by the |agent|.

Configuration
-------------

Edit the `device settings </products/openstack/latest/agent/ha-mode.html>`_ and `Device Driver/iControl driver settings`_ sections of the |agent| `configuration file`_.

#. Set the HA mode to :term:`pair` **or** :term:`scalen`.

   .. code-block:: text

      vi /etc/neutron/services/f5/f5-openstack-agent.ini
      ...
      # HA mode
      #
      f5_ha_type = pair    \\ 2-device cluster
      f5_ha_type = scalen  \\ 2-4 device cluster
      #
      #

#. Add the iControl endpoint (IP address) for each BIG-IP device in the cluster and the admin login credentials.
   Values must be comma-separated.

   .. code-block:: text

      #
      icontrol_hostname = 1.2.3.4,5.6.7.8
      #
      icontrol_username = myusername
      #
      icontrol_password = mypassword
      #

.. _learn-clusters:

Learn more
----------

The |oslbaas| can manage BIG-IP `Sync-Failover device groups`_ when you set `High Availability mode </products/openstack/latest/agent/ha-mode.html>`_ to :term:`pair` or :term:`scalen` .

.. figure:: /_static/media/f5-lbaas-scalen-cluster.png
   :alt: BIG-IP scalen cluster diagram
   :scale: 60%

   BIG-IP scalen cluster

The |agent| expects to find a specific number of iControl endpoints (the ``icontrol_hostname`` `configuration parameter </products/openstack/latest/agent/index.html#configuration-parameters>`_) based on the ``f5_ha_type``, as noted below.

.. table:: |oslbaas| high availability (HA) options

   ================= ========================================
   HA type           Number of iControl endpoints expected
   ================= ========================================
   standalone        1
   ----------------- ----------------------------------------
   pair              2
   ----------------- ----------------------------------------
   scalen            > 2
   ================= ========================================

F5 LBaaSv2 and BIG-IP Auto-sync
```````````````````````````````

.. important::

   The |agent-long| applies LBaaS configuration changes to each BIG-IP :term:`device` in a cluster at the same time, in real time.
   For this reason, **do not** use `configuration synchronization`_ (config sync) in clusters managed by the |oslbaas|.

For example, if you create a load balancer for a device group using config sync, the create command will succeed on the first device in the group and fail on the others.
The failure occurs because config sync has already created the requested partition on each device in the cluster.

If you need to sync a BIG-IP device group, do so manually **after** making changes to Neutron LBaaS objects.

.. danger::

   If you must use config sync mode, set the ``f5_ha_type`` to ``standalone`` and enter the iControl endpoint for one (1) of the BIG-IP devices in the group.

   If you choose to do so, **you must manually replace the iControl endpoint** in the |agent| `configuration file`_ with the iControl endpoint of another device in the group if the configured device should fail.

   While it is possible to use config sync for a device group *after* creating a new load balancer, it is not recommended.

   **F5 has not tested or verified this functionality**.

.. seealso::

   * :ref:`Manage BIG-IP vCMP clusters <lbaas-manage-vcmp-clusters>`


.. _BIG-IP device service clustering: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-administration-12-1-1.html
.. _Sync-Failover device groups: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-administration-12-1-1/4.html
.. _configuration synchronization: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-device-service-clustering-administration-12-1-1/5.html
