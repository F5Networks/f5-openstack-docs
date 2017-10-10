.. _heat-home:

F5 OpenStack Heat Integration
=============================

F5's `OpenStack Heat`_ Integration consists of the :heat:`F5 Heat template library <index.html>` and :plugins:`F5 Heat Plugins for OpenStack <index.html>`.

.. _heat-prereqs:

General Prerequisites
---------------------

The F5 OpenStack Heat Integration's documentation set assumes that you:

- already have an operational |os-deployment| with |neutron| and |heat| installed; [#partners]_
- are familiar with `OpenStack Horizon`_ and the `OpenStack CLI`_ ; and
- are familiar with F5 BIG-IP `Local Traffic Manager`_ (LTM) concepts and the BIG-IP configuration utility (aka, the BIG-IP admin web interface).
- have a BIG-IP `Virtual Edition`_ (VE) **qcow.zip** image file (any size) licensed appropriately for your needs. [#buybigip]_

Caveats
```````

- You must host your BIG-IP VE image in a location accessible via 'http'.
  The F5 Heat templates can not retrieve files via 'https'.
  File uploads via OpenStack Horizon are not supported.
- BIG-IP VE images come in `different sizes`_.
  Choose the correct :ref:`F5 flavor <big-ip_flavors>` for your image.

Heat Plugins
------------

The :plugins:`F5 Heat Plugins for OpenStack <index.html>` enable BIG-IP objects for use in OpenStack.
The Heat plugins use the `F5 Python SDK`_ to communicate with BIG-IP via the iControl REST API.

:fonticon:`fa fa-chevron-right` `Install the F5 Heat Plugins </products/openstack/heat-plugins/latest/index.html#installation>`_

Heat Templates
--------------

You can use the :heat:`F5-Supported Heat templates <f5-supported/index.html>` to provision resources and BIG-IP services in an OpenStack cloud.
F5's Heat templates follow the `OpenStack Heat Orchestration Template`_ (HOT) specification.
You can use the templates in conjunction with `F5 iApps <https://devcentral.f5.com/wiki/iApp.HomePage.ashx>`_ to deploy BIG-IP VE instances and Local Traffic Manager services.

.. warning::

   The F5 Heat template library contains supported and unsupported templates.
   The unsupported templates provided in the :github:`f5-openstack-heat` GitHub repo are 'use-at-your-own-risk'.

   Templates in the unsupported directory are not supported by F5, **regardless of your account's support agreement status**.

:fonticon:`fa fa-chevron-right` Browse the :heat:`F5-Supported Heat templates <f5-supported/index.html>`

.. include:: /_static/reuse/see-also-heat.rst

.. rubric:: Footnotes
.. [#partners] Unsure how to get started with OpenStack? Consult one of F5's :ref:`OpenStack Platform Partners <f5ospartners>`.
.. [#buybigip] `How to Buy <https://f5.com/products/how-to-buy>`_


.. _Local Traffic Manager: https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ltm-basics-13-0-0.html
.. _Virtual Edition: https://f5.com/products/deployment-methods/virtual-editions
.. _different sizes: https://support.f5.com/csp/article/K14946
.. _OpenStack Heat Orchestration Template: https://docs.openstack.org/heat/latest/template_guide/hot_spec.html
