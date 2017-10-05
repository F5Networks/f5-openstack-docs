.. _big-ip_flavors:

Nova Flavors for BIG-IP Virtual Edition images
----------------------------------------------

BIG-IP Virtual Edition (VE) images come in `different sizes`_.
Use the table below to determine the correct "f5 flavor" for your image.

.. important::

   OpenStack Newton does not have any default Nova flavors.
   The `Nova flavors`_ shown in the table apply to OpenStack Mitaka and earlier.

.. table:: F5 Nova flavors

   =================== =================== ============    ============== ===============================
   BIG-IP version      BIG-IP VE Image     F5 flavor       Nova Flavor    Flavor Elements
   =================== =================== ============    ============== ===============================
   11.5, 11.6          LTM_1SLOT           f5-1slot        m1.medium      4096M RAM, 20GB disk, 2vCPUs
   ------------------- ------------------- ------------    -------------- -------------------------------
   \                   LTM                 f5-ltm          m1.medium      4096M RAM, 40GB disk, 2vCPUs
   ------------------- ------------------- ------------    -------------- -------------------------------
   \                   ALL                 f5-all          m1.large       8192M RAM, 145GB disk, 4vCPUs
   ------------------- ------------------- ------------    -------------- -------------------------------
   12.0, 12.1, 13.0    LTM_1SLOT           f5-1slot        m1.medium      4096M RAM, 20GB disk, 2vCPUs
   ------------------- ------------------- ------------    -------------- -------------------------------
   \                   LTM                 f5-ltm          m1.large       4096M RAM, 50GB disk, 2vCPUs
   ------------------- ------------------- ------------    -------------- -------------------------------
   \                   ALL                 f5-all          m1.xlarge      8192M RAM, 160GB disk,
                                                                          4vCPUs  [#largenote]_
   =================== =================== ============    ============== ===============================

\

.. seealso::

   * :ref:`How to add the F5 Nova flavors to OpenStack <add-nova-flavors>`

   * `OpenStack Admin Guide: Manage flavors <https://docs.openstack.org/horizon/latest/admin/manage-flavors.html>`_

.. [#largenote] 160GB is the largest possible disk size for a BIG-IP VE image as of v13.0.0. See the `BIG-IP VE Linux KVM Setup Guide`_ for more information.

.. _different sizes: https://support.f5.com/csp/article/K14946
.. _BIG-IP VE Linux KVM Setup Guide: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-ve-setup-linux-kvm-13-0-0/2.html
.. _Nova flavors: https://docs.openstack.org/horizon/latest/admin/manage-flavors.html
