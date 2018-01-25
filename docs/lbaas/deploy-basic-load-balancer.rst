.. _f5-openstack-lbaasv2-coding-example:

.. _lbaas-basic-loadbalancer:

.. include:: /_static/reuse/applies-to-ALL.rst

Deploy a basic load balancer
============================

The series of code samples provided here demonstrate how to configure a basic loadbalancer via the OpenStack Neutron CLI with the |oslbaas|.
The `OpenStack CLI`_ documentation has a full list of all :code:`neutron lbaas` commands.

.. important::

   The LBaaSv2 CLI commands begin with :code:`lbaas-`.
   Commands beginning with :code:`lb-` are part of the `deprecated OpenStack LBaaS v1 project`_.

   Example: :code:`Project_9572afc14db14c8a806d8c8219446e7b`

Create a Neutron LBaaS load balancer
------------------------------------

.. tip::

   Neutron LBaaS load balancer == BIG-IP :term:`partition`

   The name assigned to the new BIG-IP partition follows the naming convention :code:`<environment-prefix>_<openstack-tenant-ID>`.
   The default environment prefix is :code:`Project_`.
   You can change the environment prefix in the |agent| |config-file|.

Specify the name you want to assign to the load balancer and the existing OpenStack subnet you want to assign to it.

.. code-block:: console

   $ neutron lbaas-loadbalancer-create --name lb1 private-subnet


Add a BIG-IP virtual server
---------------------------

.. tip::

   Neutron LBaaS listener == BIG-IP virtual server

Specify the name you want to assign to the virtual server; the name of the load balancer (BIG-IP partition) you want to create the virtual server for; and the protocol type and port you'd like to use.

.. code-block:: console

   $ neutron lbaas-listener-create --name vs1 --loadbalancer lb1 --protocol HTTP --protocol-port 8080

.. _create-secure-vs:

Add a secure BIG-IP virtual server
----------------------------------

.. important::

   OpenStack uses the Transport Layer Security (TLS) protocol to secure network traffic.
   You must configure `Barbican`_ and `Keystone`_ before you can create a secure BIG-IP virtual server.

#. Set up `Keystone`_ and `Barbican`_, if you haven't already. [#ostlslb]_

#. Complete the `Certificate Manager settings`_ section of the |agent| configuration file.

#. Create a listener using the :code:`TERMINATED_HTTPS` protocol; specify the location of the `Barbican container <http://docs.openstack.org/developer/barbican/api/quickstart/containers.html>`_ where the certificate you want to use for authentication lives.

   The |agent| will add this certificate to the BIG-IP device(s) and use it to create a new `BIG-IP SSL profile`_.

   .. code-block:: console

      $ neutron lbaas-listener-create --name vs2 --protocol TERMINATED_HTTPS --protocol-port 8443 --loadbalancer lb1 --default-tls-container-ref  http://localhost:9311/v1/containers/db50dbb3-70c2-44ea-844c-202e06203488

Create a pool
-------------

When you create a pool, specify the name you want to assign to the pool; the load balancing method you want to use; the name of the virtual server (listener) you want to attach the pool to; and the protocol type the pool should use.

.. code-block:: console

   $ neutron lbaas-pool-create --name pool1 --lb-algorithm ROUND_ROBIN --listener vs1 --protocol HTTP
   $ neutron lbaas-pool-create --name pool2 --lb-algorithm ROUND_ROBIN --listener vs2 --protocol HTTPS


Create a pool member
--------------------

When creating a pool member, specify the existing OpenStack subnet you want to assign to it; the IP address the member should process traffic on; the protocol port; and the name or UUID of the pool you want to attach the member to.

.. code-block:: console

   $ neutron lbaas-member-create --subnet private-subnet --address 172.16.101.89 --protocol-port 80 pool1


Create a health monitor
-----------------------

When creating a health monitor, specify the delay; monitor type; number of retries; timeout period; and the name of the pool you want to monitor.

.. code-block:: console

   $ neutron lbaas-healthmonitor-create --delay 3 --type HTTP --max-retries 3 --timeout 3 --pool pool1


What's Next
-----------

Use the BIG-IP configuration utility to verify that all of your Neutron LBaaS objects appear on the BIG-IP device(s).

#. Log in to the BIG-IP configuration utility at the management IP address (e.g., :code:`https://1.2.3.4/tmui/login.jsp`).
#. Use the :guilabel:`Partition` drop-down menu to select the correct partition for your load balancer.
#. Go to :menuselection:`Local traffic --> Virtual Servers` to view your new virtual server.
#. Click on the virtual server name to view the pool, pool member, and health monitor.

.. rubric:: Footnotes
.. [#ostlslb] See OpenStack's `How to create a TLS load balancer <https://wiki.openstack.org/wiki/Network/LBaaS/docs/how-to-create-tls-loadbalancer>`_ for more information and configuration instructions.


