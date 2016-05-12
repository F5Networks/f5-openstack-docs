.. _project-index:

Project Index
#############

F5 Networks® produces a number of open source plugins and tools which make it easier to use F5® products, such as BIG-IP®, in conjunction with OpenStack clouds. All of our OpenStack projects are developed in GitHub at `github.com/F5Networks <https://github.com/F5Networks>`_.

LBaaSv1
*******

F5's :ref:`LBaaSv1 plugin <lbaasv1:home>` is supported for use with OpenStack Juno - Liberty. LBaaSv1 was deprecated in the Liberty release.

The LBaaSv1 plugin is an :ref:`all-in-one solution <lbaasv1:f5-lbaasv1-plugin-architecture-overview>`, comprising the F5 agent, driver, and common (a predecessor to the :ref:`f5-sdk <f5sdk:F5 Python SDK Documentation>`) libraries.

.. seealso::

    * `F5 LBaaSv1 Docs Home <http://f5-openstack-lbaasv1.readthedocs.io>`_
    * `f5-openstack-lbaasv1 on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv1>`_

LBaaSv2
*******

F5's LBaaSv2 solution is supported for use with OpenStack Liberty forward. [#]_ Unlike the F5 LBaaSv1 solution, for LBaaSv2 the agent and driver are developed as **separate** projects.

f5-openstack-lbaasv2-driver
---------------------------

The F5 OpenStack service provider driver -- also referred to as the F5 LBaaSv2 driver -- directs Neutron load balancing calls from the RPC messaging queue to the F5 agent.

.. seealso::

    * :ref:`F5 LBaaSv2 Docs Home <lbaasv2:home>`
    * :ref:`F5 LBaaSv2 User Guide <lbaasv2:F5® OpenStack LBaaSv2 User Guide>`
    * `f5-openstack-lbaasv2-driver on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv2-driver>`_

f5-openstack-agent
------------------

The F5 agent provides OpenStack users with access to the robust set of `BIG-IP® LTM® <https://f5.com/products/modules/local-traffic-manager>`_ services. It uses the `f5-sdk <f5sdk:F5 Python SDK Documentation>` to translate messaging calls from OpenStack to iControl® REST calls that are understood by BIG-IP devices.

In the future, the agent may also provide the means for using such OpenStack services as `FWaaS <https://wiki.openstack.org/wiki/Neutron/FWaaS>`_ and `VPNaaS <https://wiki.openstack.org/wiki/Neutron/VPNaaS>`_ in conjunction with BIG-IP devices.

.. seealso::

    * :ref:`F5 Agent Docs Home <agent:home>`
    * :ref:`F5 Agent Quick Start <agent:Quick Start>`
    * `f5-openstack-agent on GitHub <https://github.com/F5Networks/f5-openstack-agent>`_


.. rubric:: Footnotes
.. [#] See the :ref:`Releases and Support Matrix <releases-and-support>`


Heat
****

Plugins
-------

The :ref:`F5 Heat plugins <heatplugins:home>` enable BIG-IP objects for use in OpenStack. Like the F5 LBaaSv2 agent, the plugins use the :ref:`f5-sdk <f5sdk:F5 Python SDK Documentation>` to communicate with BIG-IP via the REST API.


Templates
---------

The :ref:`F5 Heat templates <heat:home>` can be used to provision resources and BIG-IP services in OpenStack clouds. F5's templates use the OpenStack HOT template format; they can be used in conjunction with `F5 iApps® <https://devcentral.f5.com/wiki/iApp.HomePage.ashx>`_, a user-customizable framework for deploying applications.

The F5 Heat templates come in two flavors: :ref:`supported <heat:f5-supported_home>` and :ref:`unsupported <heat:unsupported_home>`. All F5 Heat templates can be downloaded from the F5 Heat :ref:`docs site <heat:home>`.

.. warning::

    F5 provides limited support for :ref:`supported <heat:f5-supported_home>` templates, while :ref:`unsupported <heat:unsupported_home>` templates are considered to be 'use-at-your-own-risk'.
    




