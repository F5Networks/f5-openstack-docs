:product: F5 Agent for OpenStack Neutron
:product: F5 Driver for OpenStack Neutron
:product: F5 Templates for OpenStack Heat
:type: tutorial

.. _setup-access-security:

Set up access and security groups for BIG-IP devices
====================================================

To use BIG-IP device(s) in an OpenStack cloud, you'll need to `configure access and security groups`_.

.. _ssh keys:

SSH Keys
--------

.. hint::

   Follow the links below to view the appropriate topics in the OpenStack documentation.

Before deploying BIG-IP Virtual Edition "over-the-cloud" as an `OpenStack Nova`_ instance, add or import an SSH key-pair.
The key pair allows you to access the management console for the BIG-IP VE instance.

- `Manage SSH keys using OpenStack Horizon`_. :fonticon:`fa fa-external`
- `Manage SSH keys using the OpenStack CLI`_. :fonticon:`fa fa-external`

.. _security groups:

Security Groups
---------------

You'll need to create a security group and rules that allow traffic to pass through BIG-IP devices from `OpenStack Neutron`_ networks.
Specifically, the security rules should allow the ICMP protocol and standard ports used by BIG-IP devices: 22, 80, and 443.

- Create security groups with OpenStack Heat using templates from the `F5 Unsupported HOT library`_.
- Create security groups in OpenStack Horizon. :fonticon:`fa fa-external`
- `Create security groups using the OpenStack CLI`_. :fonticon:`fa fa-external`
- `Create security group rules using the OpenStack CLI`_. :fonticon:`fa fa-external`

.. code-block:: console
   :caption: Example - create a security group and rules using the OpenStack CLI

   openstack security group create --project <my_project> --description "security group for BIG-IP devices" bigip
   openstack security group rule create --protocol icmp --ingress bigip
   openstack security group rule create --protocol tcp --dst-port 22 --ingress bigip
   openstack security group rule create --protocol tcp --dst-port 80 --ingress bigip
   openstack security group rule create --protocol tcp --dst-port 443 --ingress bigip

If you're using VXLAN and/or GRE, create the following rule(s):

.. code-block:: console

   neutron security group rule create --protocol udp --dst-port 4789 --ingress bigip
   neutron security group rule create --protocol gre --ingress bigip

