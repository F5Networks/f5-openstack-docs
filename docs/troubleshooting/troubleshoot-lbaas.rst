.. _lbaas-troubleshooting:

F5 Integration for OpenStack Neutron LBaaS - Troubleshooting
============================================================

.. important::

   If you can't find objects you created using the |oslbaas| on your BIG-IP device, check your :term:`partition`.
   By default, the |agent-long| creates all objects in a partition named with the environment prefix (default is :code:`Project_`) and the OpenStack tenant ID.

   Example: ``Project_9572afc14db14c8a806d8c8219446e7b``

.. _lbaas-set-log-level:

Set the Logging Level to DEBUG
------------------------------

To troubleshoot general problems, set the Neutron and |agent| ``debug`` setting to ``True``.
This creates extensive logs in  :file:`/var/log/neutron/neutron-server.log` and :file:`/var/log/neutron/f5-openstack-agent.log`, respectively.

#. Set the DEBUG log level output for Neutron:

   .. code-block:: text

      sudo vi /etc/neutron/neutron.conf
      [DEFAULT]
      ...
      # Print debugging output (set logging level to DEBUG instead of default WARNING level).
      debug = True

#. Set the DEBUG log level output for |agent|.

   .. code-block:: text

      sudo vi /etc/neutron/services/f5/f5-openstack-agent.ini
      #
      [DEFAULT]
      # Show debugging output in log (sets DEBUG log level output).
      debug = True
      ...


What to do if the |agent-long| isn't running
--------------------------------------------

Check the agent list in the `OpenStack Horizon`_ dashboard, or run :code:`neutron agent-list` on the Neutron controller (or any other host where you installed |agent|).

If ``f5-openstack-agent``, or ``f5-oslbaasv2-agent``, doesn't appear in the agent list the |agent| isn't running.

.. rubric:: Here are a few things you can try:

- Check the logs for error messages.

  .. code-block:: console

     grep "ERROR" /var/log/neutron/f5-openstack-agent.log

- Check the status of the :code:`f5-openstack-agent` service.

  .. code-block:: console

     sudo systemctl status f5-openstack-agent.service \\ CENTOS
     sudo service f5-oslbaasv2-agent status           \\ UBUNTU

- Make sure you can connect to the BIG-IP

  .. code-block:: console

     ssh admin@<big-ip_mgmt_ip>

  and verify that the following entries in the |agent| `configuration file`_ are correct:

  - iControl hostname (can be a DNS-recognized hostname or the BIG-IP device's management IP address)
  - username (account must have permission to manage LTM objects in the OpenStack tenant's partition; see )
  - password

- When using `Global Routed Mode`_:

  Comment out (#) the ``vtep`` lines (shown below) in the |agent| `configuration file`_.

  .. code-block:: text

     #
     #f5_vtep_folder = 'Common'
     #f5_vtep_selfip_name = 'vtep'
     #

- When using L2/L3 segmentation mode:

  Verify that the :code:`advertised_tunnel_types` setting in the |agent| `configuration file`_ matches the Neutron network's :code:`provider:network_type`.
  If the settings don't match, check your network configurations and make corrections as needed.

  .. code-block:: text
     :emphasize-lines: 9

     neutron net-show <network_name>
     +---------------------------+--------------------------------------+
     | Field                     | Value                                |
     +---------------------------+--------------------------------------+
     | admin_state_up            | True                                 |
     | id                        | 05f61e74-37e0-4c30-a664-762dfef1a221 |
     | mtu                       | 0                                    |
     | name                      | bigip_external                       |
     | provider:network_type     | vxlan                                |
     | provider:physical_network |                                      |
     | provider:segmentation_id  | 84                                   |
     | router:external           | False                                |
     | shared                    | False                                |
     | status                    | ACTIVE                               |
     | subnets                   |                                      |
     | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
     +---------------------------+--------------------------------------+


|agent-long| does not handle LBaaS requests correctly
-----------------------------------------------------

Verify that you only have one agent running per environment, per host
`````````````````````````````````````````````````````````````````````

If you see more than one entry for :code:`f5-openstack-agent` or :code:`f5-oslbaasv2-agent`, and you haven't configured your host to :ref:`use multiple agents <lbaas-differentiated-service-env>`, deactivate one of them.

The commands below may help you to identify which agent to deactivate.

.. code-block:: console

   neutron agent-list                                     \\ list all running agents
   neutron agent-show <agent_id>                          \\ show the details for a specific agent
   neutron lbaas-loadbalancer-list-on-agent <agent_id>    \\ list the loadbalancers on the agent.
   neutron lbaas-loadbalancer-show <loadbalancer_id>      \\ show the details for a specific load balancer

Make sure you're not running LBaaSv1 and LBaaSv2 at the same time
`````````````````````````````````````````````````````````````````

#. Remove the entry for the lbaasv1 plugin from the Neutron configuration file (:file:`/etc/neutron/neutron.conf`), if it exists.

   .. code-block:: console

      service_plugins = router,neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2 \\ CORRECT

      service_plugins = router,lbaas,lbaasv2    \\ INCORRECT


#. Remove or comment out (#) the entry for the F5 LBaaSv1 service provider driver in the Neutron LBaaS configuration file (:file:`/etc/neutron/neutron_lbaas.conf`).

   .. code-block:: console
      :emphasize-lines: 2, 9

      [service_providers]
      service_provider = LOADBALANCERV2:F5Networks:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver:default
      # Must be in form:
      # service_provider = <service_type>:<name>:<driver>[:default]
      # List of allowed service types includes LOADBALANCER
      # Combination of <service type> and <name> must be unique; <driver> must also be unique
      # This is multiline option
      # service_provider = LOADBALANCER:name:lbaas_plugin_driver_path:default
      # service_provider = LOADBALANCER:F5:f5.oslbaasv1driver.drivers.plugin_driver.F5PluginDriver:default
      # service_provider = LOADBALANCER:Haproxy:neutron_lbaas.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
      # service_provider = LOADBALANCER:radware:neutron_lbaas.services.loadbalancer.drivers.radware.driver.LoadBalancerDriver:default
      # service_provider = LOADBALANCER:NetScaler:neutron_lbaas.services.loadbalancer.drivers.netscaler.netscaler_driver.NetScalerPluginDriver
      # service_provider = LOADBALANCER:Embrane:neutron_lbaas.services.loadbalancer.drivers.embrane.driver.EmbraneLbaas:default
      # service_provider = LOADBALANCER:A10Networks:neutron_lbaas.services.loadbalancer.drivers.a10networks.driver_v1.ThunderDriver:default
      # service_provider = LOADBALANCER:VMWareEdge:neutron_lbaas.services.loadbalancer.drivers.vmware.edge_driver.EdgeLoadbalancerDriver:default


VxLAN traffic doesn't reach BIG-IP device
-----------------------------------------

#. Check the BIG-IP :code:`vtep` port lockdown settings.
   The default setting for `port lockdown behavior`_ does not include VxLAN traffic.
   Set the :code:`vtep` to 'Allow All' to ensure that the BIG-IP device allows VxLAN traffic from the OpenStack cloud.

#. Check the VxLAN port binding.

   If you're using the default Open vSwitch (ovs) core plugin, run the command :command:`ovs-vsctl show` to view a list of configured bridges and associated ports.
   As shown in the example below, there should be a :code:`remote_ip` address for a VxLAN tunnel that corresponds to the self IP identified in the |agent| `configuration file`_.

   .. code-block:: console
      :caption: The ovs bridge has a ``remote_ip`` address that corresponds to the BIG-IP ``vtep`` self IP address.
      :emphasize-lines: 18

      # ON NEUTRON CONTROLLER
      [user@host-19 ~(keystone_user)]$ sudo ovs-vsctl show
      f08cd9da-cf33-4bc6-bdd2-960caed1136c
      Bridge br-ex
         ...
      Bridge br-tun
         fail_mode: secure
         Port "vxlan-c9001901"
             Interface "vxlan-c9001901"
                 type: vxlan
                 options: {df_default="true", in_key=flow, local_ip="201.0.20.1", out_key=flow, remote_ip="201.0.25.1"}
         Port br-tun
             Interface br-tun
                 type: internal
         Port "vxlan-0a020264"
             Interface "vxlan-0a020264"
                 type: vxlan
                 options: {df_default="true", in_key=flow, local_ip="201.0.20.1", out_key=flow, remote_ip="10.2.2.100"}
         ...

   .. admonition:: TMSH

      .. code-block:: console
         :emphasize-lines: 3

         admin@(localhost)(cfg-sync Standalone)(Active)(/Common)(tmos.net)# list self vtep
         net self vtep {
            address 10.2.2.100/16
            allow-service all
            traffic-group traffic-group-local-only
            vlan external
         }


.. _port lockdown behavior: https://support.f5.com/kb/en-us/solutions/public/17000/300/sol17333.html
