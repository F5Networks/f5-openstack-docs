:product: F5 Agent for OpenStack Neutron
:product: F5 Driver for OpenStack Neutron
:product: F5 Templates for OpenStack Heat
:type: reference

.. _releases-and-support:

Releases and Versioning
=======================

.. seealso::

   Please see the :ref:`Partners <f5ospartners>` page for information about our OpenStack distribution platform partnerships and certifications.

Documentation
-------------

This documentation set applies to the following versions of each F5 Integration for OpenStack component:

.. table:: Docs and Component Versioning
   :header-alignment: center center
   :column-alignment: left right

   ================================ ===========================
   Component                        Version
   ================================ ===========================
   f5-openstack-agent               |agent-versions|
   -------------------------------- ---------------------------
   f5-openstack-heat                |heat-versions|
   -------------------------------- ---------------------------
   f5-openstack-heat-plugins        |plugins-versions|
   -------------------------------- ---------------------------
   f5-openstack-lbaasv2-driver      |driver-versions|
   -------------------------------- ---------------------------
   f5-openstack-lbaasv1 [#eots]_    7.x, 8.x, 9.x
   ================================ ===========================

.. rubric:: Footnotes
.. [#eots] F5 ceased to repair defects and perform maintenance on the F5 OpenStack LBaaS version 1 integration as of the Openstack Ocata release (April 2017). See the :ref:`Neutron LBaaSv1 section <neutronlbaasv1support>` below for more information.

F5 in OpenStack compatibility
-----------------------------

The tables below show the versions used in earlier development testing. The F5 Integration for OpenStack Heat may work with versions not shown here; F5 has not verified functionality in those versions.
Besides the versions listed here, please note that the main supported version now for lbaas is Pike. F5 encourages customers to use Pike if they are installing new environment.
Please contact the PD team first for more details if you have any questions about the related versions.

.. table:: OpenStack, F5 Integration, & BIG-IP version compatibility
   :widths: 4 2 2 4 2

   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   | F5 Component                      | Version(s)            | OpenStack Version(s)                       | BIG-IP version(s)        |
   +===================================+=======================+============================================+==========================+
   | |agent-long|                      | v9.8.x                | Pike,Queens                                | v12.x, v13.x             |
   +                                   +-----------------------+--------------------------------------------+                          |
   | ``f5-openstack-agent``            | v9.9.x                | Pike,Queens                                |                          |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   |                                                                                                                                   |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   | |driver-long|                     | v12.x                 | Pike                                       | v12.x, v13.x             |
   +                                   +-----------------------+--------------------------------------------+                          |
   | ``f5-openstack-lbaasv2-driver``   | v13.x                 | Queens                                     |                          |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   |                                                                                                                                   |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   | |heat-t|                          | v9.x                  | Mitaka                                     | v12.x, v13.x             |
   +                                   +-----------------------+--------------------------------------------+                          |
   | ``f5-openstack-heat``             | v10.x                 | Newton                                     |                          |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   |                                                                                                                                   |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+
   | F5 Plugins for OpenStack Heat     | v9.x                  | Mitaka                                     | v12.x, v13.x             |
   +                                   +-----------------------+--------------------------------------------+                          |
   | ``f5-openstack-heat-plugins``     | v10.x                 | Newton                                     |                          |
   +-----------------------------------+-----------------------+--------------------------------------------+--------------------------+


.. table:: Linux OS Compatibility
   :header-alignment: center center center
   :column-alignment: right right right

   ================================ =============== ====================
   F5 Component version(s)          RHEL version(s) Ubuntu version(s)
   ================================ =============== ====================
   8.x, 9.x, 10.x, 11.x, 12.x       6, 7            12, 14
   ================================ =============== ====================

End of Technical Support
------------------------

The following products have reached End of Technical Support (EOTS).

Refer to the `F5 Support Policy for GitHub Software <https://support.f5.com/csp/article/K80012344>`_ for more information.

Deprecated releases
```````````````````

F5 has deprecated the releases listed in the table below.

=================== ====================
F5 component        OpenStack version
version
=================== ====================
v7.x                Kilo
------------------- --------------------
v8.x                Liberty
------------------- --------------------
v9.x                Mitaka
------------------- --------------------
v10.x               Newton
------------------- --------------------
v11.x               Ocata
=================== ====================


.. _neutronlbaasv1support:

Neutron LBaaSv1
```````````````

.. important::

   **End of Technical Support for F5 OpenStack LBaaS version 1**

   The F5 OpenStack LBaaS version 1 integration reached End of Technical Support (EOTS) effective with the Openstack Ocata release in April 2017.

   This announcement is in compliance with the OpenStack community deprecation of the OpenStack Neutron LBaaS version 1 plugin.
   F5 encourages customers to move to OpenStack LBaaS version 2.

   For additional information, please refer to the `F5 End of Life policy <https://support.f5.com/csp/article/K3225>`_.

   *The table below is for informational purposes only.*


   .. table:: OpenStack LBaaSv1 & F5 BIG-IP compatibility
      :header-alignment: center center center
      :column-alignment: right right right

      ================================ =================== ========================
      F5 LBaaSv1 Connector version(s)  OpenStack version   BIG-IP version(s)
      ================================ =================== ========================
      7.x                              Kilo                11.5.2+, 11.6.x, 12.0.x
      -------------------------------- ------------------- ------------------------
      8.x                              Liberty             11.5.2+, 11.6.x, 12.0.x
      -------------------------------- ------------------- ------------------------
      9.x                              Mitaka              11.5.2+, 11.6.x, 12.0.x
      ================================ =================== ========================

