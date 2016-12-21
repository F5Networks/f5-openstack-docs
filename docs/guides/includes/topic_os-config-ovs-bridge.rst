.. _os-config-ovs-bridge:

Configure the OVS bridge
````````````````````````

Setting up an OVS bridge allows Neutron network traffic to reach the physical, or external, network.

1. Create/modify :file:`/etc/sysconfig/network-scripts/ifcfg-br-ex`.

    Add the entries shown below, using the appropriate values for your network. This moves the IP address and netmask that were assigned to the device ``enp2s0`` to the bridge ``br-ex``.

    .. code-block:: shell

        $ sudo vi /etc/sysconfig/network-scripts/ifcfg-br-ex
        DEVICE=br-ex
        DEVICETYPE=ovs
        TYPE=OVSBridge
        BOOTPROTO=static
        IPADDR=10.190.4.193
        NETMASK=255.255.248.0 \\ shown in the ifconfig readout
        GATEWAY=10.190.0.1 \\ you may need to get this information from your network admin if you don't know it
        DNS1=10.190.0.20 \\ you may need to get this information from your network admin if you don't know it

2. Edit the config file for the device -- :file:`/etc/sysconfig/network-scripts/ifcfg-enp2s0`.

    Add the lines shown below, using the appropriate values your network. This attaches the device to the OVS bridge as a port.

    .. code-block:: shell

        $ sudo vi /etc/sysconfig/network-scripts/ifcfg-enp2s0
        ...
        DEVICE="enp2s0"
        HWADDR="b4:99:ba:a9:55:f0" \\ shown in the ifconfig readout as 'ether'
        TYPE="OVSPort"
        DEVICETYPE="ovs"
        OVS_BRIDGE="br-ex"
        ONBOOT="yes"


    .. important::

        You will need to remove the ``BOOTPROTO`` entry from the top of the config file, if it exists.


3. Configure Neutron to use the OVS bridge.

    .. important::

        This sets the ``provider:physical_network`` type for the external network. If you don't complete this step, the F5® OpenStack LBaaS plugins will not work.


    .. code-block:: shell

        $ openstack-config --set /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini ovs bridge_mappings extnet:br-ex


4. Configure the ``provider:physical network`` network types used by the `Neutron ML2 plugin <https://wiki.openstack.org/wiki/Neutron/ML2>`_.

    Run the command below to make the ``vxlan``, ``flat``, and ``vlan`` options available for the ``provider:physical network`` setting.

    .. code-block:: shell

        $ openstack-config --set /etc/neutron/plugin.ini ml2 type_drivers vxlan,flat,vlan



.. seealso::

    * `RHEL OpenStack Networking Guide: Configure Bridge Mappings <https://access.redhat.com/documentation/en/red-hat-enterprise-linux-openstack-platform/7/paged/networking-guide/chapter-14-configure-bridge-mappings>`_
    * `OpenStack Networking Guide: Provider networks with Open vSwitch <http://docs.openstack.org/kilo/networking-guide/scenario_provider_ovs.html>`_

