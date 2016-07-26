.. _big-ip_flavors:

BIG-IP® VE Flavor Requirements
------------------------------

BIG-IP® Virtual Edition (VE) is available in 3 image sizes: small (1SLOT), medium (LTM), and large (ALL). A breakdown of the differences is provided in the VE documentation.

 - v11.5, 11.6: `SOL14946 <https://support.f5.com/kb/en-us/solutions/public/14000/900/sol14946.html>`_
 - v12.0: `BIG-IP® Virtual Edition Setup Guide for Linux KVM <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-linux-kvm-12-0-0/2.html#referenceid>`_
 - v12.1: `BIG-IP® Virtual Edition and Linux KVM: Setup <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-linux-kvm-12-1-0.html>`_

When you launch an OpenStack `instance <http://docs.openstack.org/openstack-ops/content/instances.html>`_, you need to select a `flavor <http://docs.openstack.org/openstack-ops/content/flavors.html>`_ that's appropriate for your `image <http://docs.openstack.org/openstack-ops/content/user_facing_images.html>`_. We recommend creating the following flavors for use with BIG-IP® VE.

**F5 Flavors for BIG-IP® VE**

+------------------+------------------+-------------+---------------------------------+
|BIG-IP® version   | BIG-IP® Image    | Flavor Name | Flavor Elements                 |
+==================+==================+=============+=================================+
| 11.5, 11.6       | Small - 1SLOT    | F5-Small    | 2vCPUs, 4096M RAM, 20GB disk    |
+                  +------------------+-------------+---------------------------------+
|                  | Medium - LTM/GTM | F5-Med      | 2vCPUs, 4096M RAM, 40GB disk    |
+                  +------------------+-------------+---------------------------------+
|                  | Large - ALL      | F5-Large    | 4vCPUs, 8192M RAM, 120GB disk   |
+------------------+------------------+-------------+---------------------------------+
| 12.0, 12.1       | Small - 1SLOT    | F5-Small    | 2vCPUs, 4096M RAM, 20GB disk    |
+                  +------------------+-------------+---------------------------------+
|                  | Medium - LTM/GTM | F5-Med      | 2vCPUs, 4096M RAM, 50GB disk    |
+                  +------------------+-------------+---------------------------------+
|                  | Large - ALL      | F5-Large    | 4vCPUs, 8192M RAM, 140GB disk\*;|
|                  |                  |             | 4vCPUs, 8192M RAM, 160GB disk\**|
+------------------+------------------+-------------+---------------------------------+

    \* OS only;
    \** with Datastore
