.. _concept-provider-networks:

Provider Networks
-----------------

In OpenStack Neutron, the provider network maps to your existing physical network. There are two types of provider networks: flat and VLAN.

In a flat, or untagged, provider network, all instances reside on the same network. In a VLAN, or tagged, provider network, instances can reside in multiple distinct networks. You can use tagging to map the tenant or provider networks both to existing physical networks and to BIG-IP®.

.. _provider-networks-bigip:

Provider Networks and BIG-IP®
`````````````````````````````

BIG-IP® can work with either type of provider network. Users with VLAN provider networks can use the :ref:`F5® LBaaS plugins <lbaasv1:f5-lbaasv1-plugin-architecture-overview>` in :ref:`global routed mode <lbaasv1:global-routed-mode>` or :ref:`L2-adjacent mode <lbaasv1:l2-adjacent-mode>` to provision services from BIG-IP®. Users with a flat provider network must use the F5® LBaaS plugins in global routed mode with a BIG-IP® deployed within OpenStack (referred to as :dfn:`overcloud`). If BIG-IP® is deployed externally (referred to as :dfn:`undercloud`), the F5® agent must be configured to use L2/L3-adjacent mode.

.. seealso::

    * `OpenStack Networking Guide <http://docs.openstack.org/kilo/networking-guide/>`_
    * :ref:`F5® LBaaSv1 Plugin Documentation <lbaasv1:home>`
    * :ref:`F5® LBaaSv2 Plugin Documentation <lbaasv2:home>`


.. Rackspace Blog's Neutron Networking: Simple Flat Network <https://developer.rackspace.com/blog/neutron-networking-simple-flat-network/>`_
    Rackspace Blog's Neutron Networking: VLAN Provider Networks <https://developer.rackspace.com/blog/neutron-networking-vlan-provider-networks/>`_

