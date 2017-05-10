.. _heat-deploy-iapps:

How to Deploy iApps using OpenStack Heat Templates
==================================================

You can use F5 iApps and Heat templates in tandem to deploy BIG-IP resources in OpenStack.

F5's iApps contain specific configuration deployments represented as executable TCL scripts.
Each of these scripts is called an iApps template.
There are two ways to use F5's Heat plugins to deploy an iApps templates.


Deploy an existing iApp using Heat
----------------------------------

Demonstrated in :file:`deploy_composite_iapp.yaml` and :file:`F5::Sys::iAppCompositeTemplate`,

combines Heat and iApps templates to create an iApps service on a BIG-IP.


Add an iApp template to a BIG-IP device using Heat
--------------------------------------------------

The second method is a simple dump of the iApp's full TCL file into the Heat template, as we've done in :file:`F5::Sys::iAppFullTemplate`.

Once the template has been created on the BIG-IP, it can be executed to create the iApp Service (``F5::Sys::iAppService``).

We've provided example templates for each supported F5 plugin.
Feel free to browse around the repo (`F5Networks/f5-openstack-heat/unsupported/f5_plugins <https://github.com/F5Networks/f5-openstack-heat/tree/kilo/unsupported>`_).

