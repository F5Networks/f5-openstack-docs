.. raw:: html

   <!--
   Copyright 2015-2016 F5 Networks Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   -->

F5 OpenStack Documentation
##########################

.. raw:: html

    <script async defer src="https://f5-openstack-slack.herokuapp.com/slackin.js"></script>

This documentation set provides users of F5® technologies with an interest in OpenStack a jumping-off point for getting started with F5 in OpenStack. We have guides for simple OpenStack :ref:`deployment <os-deploy-guide>` and :ref:`configuration <os-config-guide>` and for :ref:`deploying BIG-IP® VE <deploy_big-ip_openstack>` from within an OpenStack cloud.

If you would like to request a new user guide or notify us of an issue with an existing one, please file an `issue <https://github.com/F5Networks/f5-openstack-docs/issues>`_ in GitHub.

User Guides and Resources
*************************

.. toctree::
    :maxdepth: 1

    project_index
    releases_and_versioning
    openstack-deploy-guide
    openstack-config-guide
    howto_deploy-ve-openstack
    guides/map_developers


Releases and Support
--------------------

The user guides provided here support OpenStack |openstack|. See the :ref:`F5 Releases and Support Matrix <releases-and-support>` for more information.

For Developers
--------------

Interested in contributing to an F5 OpenStack project? Check out the :ref:`Developer Area`.


F5 in OpenStack
***************

F5 currently has a presence in the `OpenStack projects <http://www.openstack.org/software/project-navigator>`_ listed below. Please see our :ref:`Project index` for more information.


Neutron LBaaS
-------------

`Neutron <http://www.openstack.org/software/releases/kilo/components/neutron>`_ is the OpenStack Networking component. The Load-Balancer-as-a-Service (LBaaS) plugin adds load balancing functionality to Neutron. There are two versions -- LBaaSv1 and LBaaSv2 -- for both of which F5 provides tools that enable users to provision BIG-IP® services in OpenStack.

v1
~~~~

Neutron LBaaSv1 is compatible with OpenStack Juno - Liberty; it was deprecated with the Liberty release.

.. seealso::

    * `f5-openstack-lbaasv1 on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv1>`_
    * :ref:`F5 LBaaSv1 Plugin Docs Home <lbaasv1:home>`


v2
~~~~

Neutron LBaaSv2 replaced LBaaSv1 in the Liberty release; it is compatible with Liberty and later releases. For LBaaSv2, F5 split its solution into two separate projects: :ref:`f5-openstack-agent <agent:home>` and :ref:`f5-openstack-lbaasv2-driver <lbaasv2:home>`.

.. seealso::

    * `f5-openstack-agent on GitHub <https://github.com/F5Networks/f5-openstack-agent>`_
    * `f5-openstack-lbaasv2-driver on GitHub <https://github.com/F5Networks/f5-openstack-lbaasv2-driver>`_
    * :ref:`F5 Agent Docs Home <agent:home>`
    * :ref:`F5 LBaaSv2 Docs Home <lbaasv2:home>`
    * :ref:`F5 LBaaSv2 User Guide <lbaasv2:F5® OpenStack LBaaSv2 User Guide>`


Heat
----

`Heat <http://www.openstack.org/software/releases/kilo/components/heat>`_ is OpenStack's orchestration service. F5 has developed a set of Heat :ref:`plugins <heatplugins:home>` and :ref:`templates <heat:home>` that make it easy to orchestrate cloud applications in OpenStack using F5 technologies.

.. seealso::

    * `f5-openstack-heat-plugins on GitHub <https://github.com/F5Networks/f5-openstack-heat-plugins>`_
    * `f5-openstack-heat on GitHub <https://github.com/F5Networks/f5-openstack-heat>`_
    * :ref:`F5 Heat Plugins Docs Home <heatplugins:home>`
    * :ref:`F5 Heat Docs Home <heat:home>`
    * :ref:`F5 Heat User Guide <heat:heat-user-guide>`




