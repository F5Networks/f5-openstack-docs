:product: F5 Agent for OpenStack Neutron
:type: tutorial

.. _lbaas-ssl-offloading-loadbalancer:

Configure SSL Offloading On F5 Neutron LBaaS Dashboard
======================================================

.. sidebar:: :fonticon:`fa fa-info-circle` **OpenStack version:**

   **Mitaka** and later.

Overview
--------

To configure a standard OpenStack load balancer, please refer to `OpenStack Neutron LBaaS Dashboard`_.

Note that, on that page it mentions "Neutron-lbaas-dashboard is now deprecated.". Starting with the Queen release, Octavia replaces load balancer v2. For more information about Octavia, see `Octavia Documentation`_.

This page describes how to configure a *TERMINATED_HTTPS* protocol load balancer called **SSL Offloading** load balancer whose service provider is F5 Networks. F5 Networks does the work of the TLS handshake with clients for the back-end servers.

Note that, to configure **SSL Offloading** on |dashboard|, OpenStack needs to use Barbican as secret backend store. For details about Barbican setup, see `Set up SSL offloading with OpenStack Barbican <agent-cert-manager-config>`_ and `Setting up Barbican`_.

Create TERMINATED_HTTPS Load Balancer
-------------------------------------

1. Log in to the OpenStack dashboard.

2. On the *Project* tab, open the *Network* tab, and click the *F5 Load Balancers* category.

3. On the right(in the panel), click *Create Load Balancer*.

4. On the window that opens, enter necessary information for creating the load balancer:

- For details of relative concepts, see `OpenStack Neutron LBaaS Dashboard`_.

- Items marked with "*" cannot be empty.

- Switch tabs by clicking on them or *Next* at the bottom of the window.

5. In *Listener Details*, select *TERMINATED_HTTPS* as the protocol.

   Once selected, *SSL Certificates* tab will appear under *Listener Details*.

6. Switch to *SSL Certificates* tab.

   Select the certificate you want to use from the *Available* table, or deselect the certificate from the *Allocated* table, or click *Create SSL Certificate* to add a new certificate.

7. Click *Create SSL Certificate*. Input the tuple information for creating.
 
- The inputs are validated when you enter them. The *Create* button is available when all inputs are valid.

- Clicking *Create* will trigger the creation of certificate. In the backend, it will call barbican library to store a new certificate container with the inputs.

  Fields for certificate creation:

  - **Certificate Name**: [required] the name of certificate, used as certificate secret name in barbican. 

  - **Certificate**: [required] the content of server certificate, in X509 PEM format. 

  - **Private Key**: [required] the content of server private key, in X509 PEM format.

  - **Passphrase**: [optional] the content of private key passphrase, single line string, reveal it by pressing the eye icon.

  - **Certificate Chain**: [optional] the content of intermediate certificates if exists, in X509 PEM format.

8. Continue entering pool/member/monitor details as you would a standard load balancer.

9. Click *Create Load Balancer* to trigger the creation of *TERMINATED_HTTPS* load balancer.

What Happens on BIG-IP
----------------------

On BIG-IP, there is a new partition created. After you switch to it, it is possible to view Virtual Server/SSL Profile/Pool/Certificate Management. 

The created objects are by default named with prefix "Project_", which is configurable in *f5-openstack-agent.ini*.

Navigate to them on BIG-IP console through:

* Partition -> Project_<project id>
* Local Traffic -> Virtual Servers -> Project_<listener id>
* Local Traffic -> Virtual Servers -> Profiles -> SSL -> Client -> Project_<secret container id>
* Local Traffic -> Virtual Servers -> Pools -> Project_<lbaas pool id>
* System -> Certificate Management : Traffic Certificate Management : SSL Certificate List -> Project_<secret container id>

For ease, there is a mapping of concepts between load balancer from OpenStack and Virtual Server from BIG-IP:

+--------------------------------------+---------------------+
| OpenStack Concept                    | BIG-IP Concept      |
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
