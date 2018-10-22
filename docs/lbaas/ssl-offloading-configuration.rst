:product: F5 Agent for OpenStack Neutron
:type: tutorial

.. _lbaas-ssl-offloading-loadbalancer:

Configure SSL Offloading On F5 Neutron LBaaS Dashboard
======================================================

.. sidebar:: :fonticon:`fa fa-info-circle` **OpenStack version:**

   |dashboard| supports OpenStack releases from **Mitaka** forward.

Overview
--------

To configure a common OpenStack Load Balancer, please refer to `OpenStack Neutron LBaaS Dashboard`_.

Note that, on that page it mentions "Neutron-lbaas-dashboard is now deprecated.". That becauses beginning from Queen, Octavia replaces Load Balancer V2. More information about Octavia, please refer to `Octavia Documentation`_.

This page describes how to configure a *TERMINATED_HTTPS* protocol Load Balancer called **SSL Offloading** Load Balancer whose service provider is F5Networks, which means F5Networks take the works of TLS handshake with clients for backing servers.

Note that, to configure **SSL Offloading** on |dashboard|, OpenStack need to use Barbican as secret backend store, please refer to `Set up SSL offloading with OpenStack Barbican <agent-cert-manager-config>`_ and `Setting up Barbican`_ for barbican setup in OpenStack.

Create TERMINATED_HTTPS Load Balancer
-------------------------------------

1. Log in to the OpenStack dashboard.

2. On the *Project* tab, open the *Network* tab, and click the *F5 Load Balancers* category.

3. At the right side(in the panel), click the *Create Load Balancer*.

4. On the popped modal, input necessary information for creating the Load Balancer:

- Refer `OpenStack Neutron LBaaS Dashboard`_ for relative concepts.

- Items marked with "*" cannot be empty.

- Switching tabs by clicking on them or *Next* at the bottom of the modal.

5. In *Listener Details*, select *TERMINATED_HTTPS* as the protocol.

   Once selected, *SSL Certificates* tab will appear under *Listener Details*.

6. Switch to *SSL Certificates* tab.

   Select certificate you want to use from *Available* table, or unselect certificate from *Allocated* table, or click *Create SSL Certificate* to add new certificate.

7. Click *Create SSL Certificate*. Input the tuple information for creating.
 
- The inputs are strictly checked timely. The *Create* will be available once all inputs are valid.

- Clicking *Create* will trigger the creation of certificate. In the backend, it will call barbican library to store a new certificate container with the inputs.

  Fields for certificate creation:

  - **Certificate Name**: [required] the name of certificate, used as certificate secret name in barbican. 

  - **Certificate**: [required] the content of server certificate, in X509 PEM format. 

  - **Private Key**: [required] the content of server private key, in X509 PEM format.

  - **Passphrase**: [optional] the content of private key passphrase, single line string, reveal it by pressing the eye icon.

  - **Certificate Chain**: [optional] the content of intermediate certificates if exists, in X509 PEM format.

8. Continue to configure Pool/Member/Monitor Details as do a normal Load Balancer. 

9. Click *Create Load Balancer* to trigger the creation of *TERMINATED_HTTPS* Load Balancer.

What Happens on BIGIP Side
--------------------------

On BIGIP side, there is a new partition created. Once switched to it, it possible to view Virtual Server/SSL Profile/Pool/Certificate Management. 

The created objects are by default named with prefix "Project_", which is configurable in *f5-openstack-agent.ini*.

Navigate to them on BIGIP console through:

* Partition -> Project_<project id>
* Local Traffic -> Virtual Servers -> Project_<listener id>
* Local Traffic -> Virtual Servers -> Profiles -> SSL -> Client -> Project_<secret container id>
* Local Traffic -> Virtual Servers -> Pools -> Project_<lbaas pool id>
* System -> Certificate Management : Traffic Certificate Management : SSL Certificate List -> Project_<secret container id>

For ease, there is a mapping of concepts between Load Balancer from OpenStack and Virtual Server from BIGIP:

+--------------------------------------+---------------------+
| OpenStack Concept                    | BIGIP Concept       |
+======================================+=====================+
| Project                              | Partition           |
+--------------------------------------+---------------------+
| Load Balancer's Listener             | Virtual server      |
+--------------------------------------+---------------------+
| Barbican Secret Container            | SSL Profile         |
+--------------------------------------+---------------------+
| Pool/Member                          | Pool/Node           |
+--------------------------------------+---------------------+
| Barbican Secret(Certificate Content) | SSL Certificate     |
+--------------------------------------+---------------------+
