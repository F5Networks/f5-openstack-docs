.. _network-setup-overview:

Overview
````````

At minimum, you'll need to create an external network that corresponds to your existing physical network; a public subnet; a private (internal) network; and a private subnet. We recommend creating two private networks; these can be used with one of our most common BIG-IP® cloud deployments (:ref:`standalone, 3-NIC <heat:how-to_launch-standalone-bigip-3nic>`).

Creating an external network in Neutron enables network connectivity via your physical network (aka, the ``provider-network``). If this is not configured correctly, traffic from your cloud will not be able to leave your cloud. When you configure the external network, identify the type of the ``provider-network` (vlan or flat) and the ``provider-network`` name (in this case, ``extnet``, as set up in :ref:`Configure the OVS bridge <os-config-ovs-bridge>`).

.. seealso::

    :ref:`Provider Network <provider-network>`


Creating a public subnet allows you to define a range of floating IP addresses you can assign to instances -- like :ref:`BIG-IP® VE <launch-bigip-ve-horizon>` -- and tenants.

.. tip::

    If you're using DHCP, be sure the subnet range is outside the external DHCP range.

Private networks and subnets can be used to allocate resources in your cloud to various projects/users.
