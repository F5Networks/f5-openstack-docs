Introduction
````````````

The quickest and easiest way to deploy OpenStack is with the `Packstack <https://wiki.openstack.org/wiki/Packstack>`_ ``--allinone`` option. This sets up a single machine as the controller, compute, and network node.

Be aware that this configuration, while fairly simple to execute, is fairly limited. By default, the all-in-one configuration doesn't have `Heat <https://wiki.openstack.org/wiki/Heat>`_ and `Neutron LBaaS <https://wiki.openstack.org/wiki/Neutron/LBaaS>`_ enabled. For this reason, **we don't recommend** going with the default ``--allinone`` deployment. Instead, we recommend customizing your all-in-one deployment with an answers file.

