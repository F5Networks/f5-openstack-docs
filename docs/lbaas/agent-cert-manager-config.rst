.. _certificate-manager:

Set up SSL offloading with OpenStack Barbican
=============================================

.. include:: /_static/reuse/applies-to-ALL.rst

`OpenStack Barbican`_ is OpenStack's certificate management service.
It provides a secure location where users can store `secrets`_  such as SSH keys, private keys, certificates, and user passwords.
The |agent-long| can use Barbican certificates to perform BIG-IP :term:`SSL offloading`.

Prerequisites
-------------

- Administrator access to both BIG-IP device(s) and OpenStack cloud.
- `OpenStack Barbican`_ certificate manager configured and operational.
- Existing `BIG-IP SSL profile`_ (*optional*).


Configure SSL offloading using OpenStack Barbican Secrets
---------------------------------------------------------

Edit the `Certificate Manager Settings </products/openstack/latest/agent/index.html#cert-manager-settings>`_ section of the |agent| configuration file.

#. Enable the F5 Barbican certificate manager.

   .. code-block:: text

      cert_manager = f5_openstack_agent.lbaasv2.drivers.bigip.barbican_cert.BarbicanCertManager

#. Provide the Keystone authentication data for your environment.

   .. table:: Keystone authentication data

      ======================= ====================================================
      auth_version            Keystone version (``v2`` or ``v3``)
      ----------------------- ----------------------------------------------------
      os_auth_url             Keystone authentication URL
      ----------------------- ----------------------------------------------------
      os_username             OpenStack username
      ----------------------- ----------------------------------------------------
      os_password             OpenStack password
      ----------------------- ----------------------------------------------------
      os_tenant_name          OpenStack tenant name (v2 only)
      ----------------------- ----------------------------------------------------
      os_user_domain_name     OpenStack domain in which the user account resides
                              (v3 only)
      ----------------------- ----------------------------------------------------
      os_project_name         OpenStack project name (v3 only; this is the same
                              data as os_tenant_name in v2)
      ----------------------- ----------------------------------------------------
      os_project_domain_name  OpenStack domain in which the project resides
      ======================= ====================================================

   \

   .. code-block:: text
      :emphasize-lines: 7-11, 15-21

      #
      cert_manager = f5_openstack_agent.lbaasv2.drivers.bigip.barbican_cert.BarbicanCertManager
      #
      ...
      # Keystone v2 authentication:
      #
      # auth_version = v2
      # os_auth_url = http://localhost:5000/v2.0
      # os_username = admin
      # os_password = changeme
      # os_tenant_name = admin
      #
      # Keystone v3 authentication:
      #
      auth_version = v3
      os_auth_url = http://localhost:5000/v3
      os_username = myusername
      os_password = mypassword
      os_user_domain_name = default
      os_project_name = myproject
      os_project_domain_name = default
      #

#. Set the parent BIG-IP SSL profile.

   .. code-block:: text

      #
      f5_parent_ssl_profile = clientssl
      #

   .. tip::

      The profile |agent| creates on the BIG-IP device inherit settings from the parent you define.
      The profile must already existing on the BIG-IP device; if it does not, |agent| uses :code:`clientssl` as the default
      parent profile.

Learn more
----------

Once you've added `secrets`_ to a Barbican container, you can reference the container's URI in :code:`neutron lbaas` commands.

.. figure:: /_static/media/LBaaS_cert-mgr_with-legend.jpg
   :scale: 60%
   :alt: SSL Offloading with OpenStack Barbican, Neutron LBaaSv2, and BIG-IP

   SSL Offloading with OpenStack Barbican, Neutron LBaaSv2, and BIG-IP

Use Case
--------

When you configure `Client SSL`_ or `Server SSL`_ profiles and assign them to a virtual server, the BIG-IP device handles the SSL processing.
This conserves resources on the destination servers and lets you enforce custom BIG-IP SSL processing rules.
When the |agent| adds a Barbican certificate to a BIG-IP device, it can either inherit settings from an existing `BIG-IP SSL profile`_ or create a new SSL profile on the device.

You can use `Client SSL`_ (the most common use case) to decrypt client requests before sending them on to the destination server and encrypt server responses before sending them back to the client.


.. seealso::

   - :ref:`Create a secure BIG-IP virtual server <create-secure-vs>`


.. _secrets: http://developer.openstack.org/api-guide/key-manager/secrets.html
.. _Client SSL: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ssl-administration-13-0-0/5.html
.. _Server SSL: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ssl-administration-13-0-0/5.html
.. _BIG-IP SSL profile: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-profiles-reference-12-1-0/6.html
