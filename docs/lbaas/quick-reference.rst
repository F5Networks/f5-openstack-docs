.. _lbaas-quick-start:

F5 LBaaSv2 Quick Reference
==========================

.. sidebar:: Applies to:

   ====================    ===========================
   F5 LBaaS version(s)     OpenStack version(s)
   ====================    ===========================
   v10.0+                  Newton
   ====================    ===========================

   To install previous versions, see the :agent:`F5 Agent <index.html>` documentation.

This reference sheet provides the basic information you need to get the |oslbaas| up and running using the latest release: v |version_latest|.

Tasks
-----

#. Download and install the F5 service provider package; the |agent|; and the |driver-long|.

   - Debian

     .. parsed-literal::

        curl -O -L |f5_lbaasv2_driver_shim_url|
        tar xvf f5.tgz -C /usr/lib/python2.7/dist-packages/neutron_lbaas/drivers/
        curl -L -O |f5_agent_deb_url|
        curl -L -O |f5_sdk_deb_url|
        curl -L -O |f5_icontrol_deb_url|
        curl –L –O |f5_lbaasv2_driver_deb_url|
        dpkg –i |f5_icontrol_deb_package|
        dpkg –i |f5_sdk_deb_package|
        dpkg –i |f5_agent_deb_package|
        dpkg –i |f5_lbaasv2_driver_deb_package|

   - RPM

     .. parsed-literal::

        curl -O -L |f5_lbaasv2_driver_shim_url|
        tar xvf f5.tgz -C /usr/lib/python2.7/site-packages/neutron_lbaas/drivers/
        curl -L -O |f5_sdk_rpm_url|
        curl -L -O |f5_icontrol_rpm_url|
        curl -L -O |f5_agent_rpm_url|
        curl –L –O |f5_lbaasv2_driver_rpm_url|
        sudo rpm -ivh |f5_icontrol_rpm_package| |f5_sdk_rpm_package| |f5_agent_rpm_package| |f5_lbaasv2_driver_rpm_package|

   - Pip

     Download the F5 driver package (f5.tgz) and install it in the correct path for your OS (see above examples).
     Then, run the commands shown below to install the |agent| and |driver| packages.

     .. parsed-literal::

        pip install |f5_agent_pip_url|
        pip install |f5_driver_pip_url|


#. `Set up Neutron to use the F5 service provider driver`_.

   .. important::

      The Neutron configuration steps may differ from the instructions provided, depending on your OpenStack platform.
      Please see our partners' documentation for more information.

      - `HPE Helion OpenStack`_
      - `Mirantis OpenStack`_
      - `RedHat OpenStack Platform`_

#. Set up the |agent|.

   Sample configuration files:

   * `Global Routed Mode example <products/openstack/agent/_static/config_examples/f5-openstack-agent.grm.ini>`_
   * `GRE example </products/openstack/agent/_static/config_examples/f5-openstack-agent.gre.ini>`_ [#licensing]_
   * `VLAN example </products/openstack/agent/_static/config_examples/f5-openstack-agent.vlan.ini>`_
   * `VXLAN example </products/openstack/agent/_static/config_examples/f5-openstack-agent.vxlan.ini>`_ [#licensing]_


#. Start the |agent|.

   .. rubric:: CentOS
   .. code-block:: console

      systemctl enable f5-openstack-agent
      systemctl start f5-openstack-agent
      sudo systemctl stop f5-openstack-agent.service

   .. rubric:: Ubuntu
   .. code-block:: console

      service f5-oslbaasv2-agent start
      service f5-oslbaasv2-agent stop


What's Next
-----------

- :ref:`Set up a basic load balancer using the Neutron CLI <lbaas-basic-loadbalancer>`.
- Discover how the |agent| :ref:`maps Neutron commands to BIG-IP objects <neutron-bigip-command-mapping>`.

.. rubric:: Footnotes
.. [#licensing] You need a `license`_ that includes SDN services if you plan to use VXLAN/GRE tunnels in your deployment.

.. _license: https://f5.com/products/how-to-buy/simplified-licensing
.. _OpenStack Networking Concepts: http://docs.openstack.org/liberty/networking-guide/
.. _Set up Neutron to use the F5 service provider driver: /products/openstack/lbaasv2-driver/latest/index.html#neutron-setup
