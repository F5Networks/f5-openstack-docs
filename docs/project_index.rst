.. _project-index:


Project Index
#############

F5 Networks® currently has a presence in the `OpenStack projects <http://www.openstack.org/software/project-navigator>`_ listed below.


Neutron
=======

`Neutron <http://www.openstack.org/software/releases/kilo/components/neutron>`_ is the OpenStack Networking component. The `Load-Balancer-as-a-Service <http://docs.openstack.org/mitaka/networking-guide/config-lbaas.html>`_ (LBaaS) plugin adds load balancing functionality to Neutron. There are two versions -- LBaaSv1 and LBaaSv2.

LBaaSv1
-------

.. important::

    **End of Software Development for F5 OpenStack LBaaS version 1**

    F5 announces the End of Software Development (EoSD) for the F5 OpenStack LBaaS version 1 integration, effective October 1, 2016. This announcement is in compliance with the OpenStack community deprecation of the OpenStack Neutron LBaaS version 1 plugin. Customers are encouraged to move to OpenStack LBaaS version 2.

    F5 will continue to repair defects and perform maintenance on the F5 OpenStack LBaaS version 1 integration until the Openstack Ocata release in April 2017.

    For additional information, please refer to the :ref:`F5 OpenStack Releases and Support Matrix`.


.. seealso::

    * `f5-openstack-lbaasv1 on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv1>`_
    * :ref:`F5 LBaaSv1 Plugin Docs Home <lbaasv1:home>`

LBaaSv2
-------

F5's LBaaSv2 solution is supported for use with OpenStack Liberty forward. [#]_ F5's LBaaSv2 solution comprises two separate projects: the F5 service provider driver and F5 agent.

All documentation relevant to LBaaSv2 is sourced from the `f5-openstack-lbaasv2-driver <https://github.com/f5networks/f5-openstack-lbaasv2-driver>`_ project in GitHub.

f5-openstack-lbaasv2-driver
```````````````````````````

The F5 OpenStack service provider driver -- also referred to as the F5 LBaaSv2 driver -- directs Neutron load balancing calls from the RPC messaging queue to the F5 agent. The two work in conjunction to retrieve LBaaS messaging calls from the OpenStack RPC queue and translate them into iControl® REST calls that are understood by BIG-IP devices.

.. seealso::

    * :ref:`F5 LBaaSv2 Docs Home <lbaasv2:home>`
    * :ref:`F5 LBaaSv2 User Guide <lbaasv2:F5 OpenStack LBaaSv2 User Guide>`
    * `f5-openstack-lbaasv2-driver on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv2-driver>`_

f5-openstack-agent
``````````````````

The F5 agent provides OpenStack users with access to the robust set of `BIG-IP® LTM® <https://f5.com/products/modules/local-traffic-manager>`_ services, by means of the :ref:`f5-sdk <f5sdk:F5 Python SDK Documentation>`. The agent receives tasks from the F5 service provider driver and configures the requested LBaaS objects on the BIG-IP.

In the future, the agent may also provide the means for using OpenStack services other than LBaaS in conjunction with BIG-IP devices.

.. seealso::

    * :ref:`F5 Agent Docs Home <agent:home>`
    * :ref:`F5 Agent Quick Start <agent:Quick Start>`
    * `f5-openstack-agent on GitHub <https://github.com/F5Networks/f5-openstack-agent>`_


Heat
----

`Heat <http://www.openstack.org/software/releases/kilo/components/heat>`_ is OpenStack's orchestration service. F5 has developed a set of Heat :ref:`plugins <heatplugins:home>` and :ref:`templates <heat:home>` that make it easy to orchestrate cloud applications in OpenStack using F5 technologies.

Plugins
```````

The :ref:`F5 Heat plugins <heatplugins:home>` enable BIG-IP objects for use in OpenStack. Like F5 LBaaSv2, the Heat plugins use the :ref:`f5-sdk <f5sdk:F5 Python SDK Documentation>` to communicate with BIG-IP via the REST API.

.. seealso::

    * `f5-openstack-heat-plugins on GitHub <https://github.com/F5Networks/f5-openstack-heat-plugins>`_
    * :ref:`F5 Heat Plugins Docs Home <heatplugins:home>`


Templates
`````````

The F5 Heat templates can be used to provision resources and BIG-IP services in OpenStack clouds. F5's templates use the OpenStack HOT template format; they can be used in conjunction with `F5 iApps® <https://devcentral.f5.com/wiki/iApp.HomePage.ashx>`_, a user-customizable framework for deploying applications.

The F5 Heat templates come in two flavors: :ref:`supported <heat:f5-supported_home>` and :ref:`unsupported <heat:unsupported_home>`. All F5 Heat templates can be downloaded from the F5 Heat :ref:`docs site <heat:home>` or GitHub repo.

.. warning::

    F5 provides limited support for :ref:`supported <heat:f5-supported_home>` templates, while :ref:`unsupported <heat:unsupported_home>` templates are considered to be 'use-at-your-own-risk'.


.. seealso::

    * `f5-openstack-heat on GitHub <https://github.com/F5Networks/f5-openstack-heat>`_
    * :ref:`F5 Heat Docs Home <heat:home>`
    * :ref:`F5 Heat User Guide <heat:heat-user-guide>`


.. rubric:: Footnotes
.. [#] See the :ref:`Releases and Support Matrix <releases-and-support>`