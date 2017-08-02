.. _neutron-bigip-command-mapping:

.. include:: /_static/reuse/applies-to-ALL.rst

Neutron to BIG-IP Command Mapping
=================================

When you issue :code:`neutron lbaas` commands on your OpenStack Neutron controller, the |agent-long| configures objects on your BIG-IP device(s).
This document describes how OpenStack Neutron LBaaS objects correspond to BIG-IP objects and what actions the |agent| takes for each :code:`neutron lbaas-loadbalancer` CLI command.

F5 LBaaSv2 uses the `f5-sdk <http://f5-sdk.readthedocs.io/en/latest/>`_ to communicate with BIG-IP via the F5 iControl REST API. The table below shows the corresponding iControl endpoint and BIG-IP object for each neutron lbaas- ‘create’ command.

.. table:: Neutron Command to iControl REST API endpoint Mapping

   ==============================================  ==================================================================================================
   Neutron command                                 iControl REST API endpoint
   ==============================================  ==================================================================================================
   :command:`neutron lbaas-loadbalancer-create`    :code:`https://<icontrol_endpoint>:443/mgmt/tm/sys/folder/~Project_<os_tenant_id>`
   ----------------------------------------------  --------------------------------------------------------------------------------------------------
   :command:`neutron lbaas-listener-create`        :code:`https://<icontrol_endpoint>:443/mgmt/tm/ltm/virtual/`
   ----------------------------------------------  --------------------------------------------------------------------------------------------------
   :command:`neutron lbaas-pool-create`            :code:`https://<icontrol_endpoint>:443/mgmt/tm/ltm/pool/`
   ----------------------------------------------  --------------------------------------------------------------------------------------------------
   :command:`neutron lbaas-member-create`          :code:`https://<icontrol_endpoint>:443/mgmt/tm/ltm/pool/~Project_<os_tenant_id>~pool1/members/`
   ----------------------------------------------  --------------------------------------------------------------------------------------------------
   :command:`neutron lbaas-healthmonitor-create`   :code:`https://<icontrol_endpoint>:443/mgmt/tm/ltm/monitor/http/`
   ==============================================  ==================================================================================================

\

The sections below cover the settings |agent| applies to a standalone, :term:`overcloud` BIG-IP device.
The actual settings applied for a given command can vary depending on your existing BIG-IP device configurations and network architecture.

.. tip::

   To view the actual API calls the |agent| sends to the BIG-IP device(s), :ref:`set the F5 agent's DEBUG level <lbaas-set-log-level>` to 'True' and view the logs (:file:`/var/log/neutron/f5-openstack-agent.log`).


Start the |agent-long|
----------------------

:command:`systemctl start f5-openstack agent`
  When you first start the |agent-long|:

- it reads the :code:`vtep` `self IP`_ defined in the |agent| config file;
- the |agent| discovers the BIG-IP :code:`vtep` IP address and advertises it to Neutron as its ``tunneling_ip``;
- the |driver-long| adds a new port for the :code:`vtep` to the OVS switch;
- the |agent| adds profiles for all tunnel types to the BIG-IP device(s).

Create a Neutron LBaaS Load Balancer
------------------------------------

:command:`neutron lbaas-loadbalancer-create`
  The |agent| creates the following:

- new BIG-IP partition
- BIG-IP forwarding database (FDB) records for all peers in the network
- new BIG-IP route domain
- new BIG-IP self IP on the specified subnet (this is the IP address at which the BIG-IP device can receive traffic for this load balancer)
- new tunnel (uses the :code:`vtep` as the local address and the BIG-IP vxlan profile created when the |agent| started) [#tablefn4]_
- new SNAT pool list/SNAT translation list [#tablefn5]_

In addition, the |driver| adds a Neutron port for each SNAT address.

- If BIG-IP SNAT mode is off and you have :code:`f5_snat_addresses_per_subnet` set to ``0``, the BIG-IP acts as a gateway and handles all return traffic from members.
- If BIG-IP SNAT mode is on and you have :code:`f5_snat_addresses_per_subnet` set to ``0``, the BIG-IP device uses `SNAT automap`_.

Create a Neutron LBaaS Listener
-------------------------------

:command:`neutron lbaas-listener-create`
  The |agent| creates a new BIG-IP virtual server in the specified partition.

- uses the `Fast L4`_ protocol
- uses the IP address Neutron assigned to the load balancer
- uses the route domain created for the load balancer
- if you're using tunnels, traffic is only handled in the tunnel assigned to the load balancer
- for secure listeners using the :code:`TERMINATED_HTTPS` protocol: [#tablefn6]_

  - fetches the certificate/key container from Barbican.
  - adds the key and certificate to the BIG-IP device(s).
  - creates a custom SSL profile using ``clientssl`` as the parent profile.
  - adds the new SSL profile to the virtual server.

Create a Neutron LBaaS Pool
---------------------------

:command:`neutron lbaas-pool-create`
  The |agent| adds a new pool to the specified virtual server.


Create a Neutron LBaaS Member
-----------------------------

:command:`neutron lbaas-member-create`
  The |agent| adds a new member to the requested pool using the specified IP address and port.

- If there is a Neutron port associated with the specified IP address and subnet, the |agent| creates a forwarding database (FDB) entry for the member on the BIG-IP device(s). [#tablefn7]_
- When you add a member to a pool for the first time, the BIG-IP pool status changes.
- When you create a member with a specific IP address for the first time, the |agent| also creates a new `BIG-IP node`_ for that IP address.

Create a Neutron LBaaS Health Monitor
-------------------------------------

:command:`neutron lbaas-healthmonitor-create`
  The |agent| creates a new BIG-IP health monitor for the specified pool.

- Creating a health monitor for a pool for the first time makes the BIG-IP pool status change.
- Health monitors directly affect the status and availability of BIG-IP pools and pool members.
  Any additions or changes may change the status of the specified pool.

.. rubric:: Footnotes
.. [#tablefn4] If using `global routed mode`_, |agent| doesn't create a tunnel. Instead, all traffic goes to the load balancer's self IP address.
.. [#tablefn5] You can set the number of SNAT addresses to create via the ``f5_snat_addresses_per_subnet`` setting in the `L3 Segmentation Mode Settings`_ section of the |agent| configuration file.
.. [#tablefn6] See :ref:`Set up the F5 Agent for OpenStack Barbican <certificate-manager>`.
.. [#tablefn7] The |agent| will not create a FDB entry if the pool member IP address and subnet don't have a corresponding Neutron port. In such cases, warning messages print to the :code:`f5-openstack-agent` and :code:`neutron-server` logs.

.. _self IP: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/6.html
.. _SNAT automap: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/tmos-routing-administration-13-0-0/8.html
.. _Fast L4: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-profiles-reference-13-0-0/5.html
.. _BIG-IP node: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0/3.html


