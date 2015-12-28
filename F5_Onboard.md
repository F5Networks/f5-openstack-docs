# F5 Onboard

## Command Reference

F5 Onboard documentation is available separately for the command reference.

## ODK Extension

The F5 Onboard project also has an extension for the ODK, which contains the following patches.

### F5 Patch: BIG-IP KVM Detection
Creates /etc/nova/release on the compute node:

[nova]
vendor = Red Hat
product = Bochs
package = RHEL 6.3.0 PC

There is no configuration for this patch.

### F5 Patch: LBaaS Configuration and Bug Fixes

*Workaround: Neutron LBaaS Setup Instructions Wrong*

These instructions are wrong: https://wiki.openstack.org/wiki/Neutron/LBaaS/HowToRun

Bug: https://bugs.launchpad.net/openstack-manuals/+bug/1257210

For neutron, we do this instead:

```
[DEFAULT]
service_plugins =
neutron.services.loadbalancer.plugin.LoadBalancerPlugin
```

```
[service_providers]
service_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
```

We comment out the signing_dir, otherwise a mysterious exception occurs on the controller in */var/log/neutron/server.log*.

```
[keystone_authtoken]
\# signing_dir = \$state_path/keystone-signing
```

*Workaround: Neutron Exception Deleting VIP*

On Nova Cloud Controller:

*/var/log/neutron/server.log*:

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource Traceback (most recent call last):

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/api/v2/resource.py", line 87, in resource

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource result = method(request=request, \*\*args)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/api/v2/base.py", line 287, in index

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource return self._items(request, True, parent_id)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/api/v2/base.py", line 236, in _items

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource obj_list = obj_getter(request.context, \*\*kwargs)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/db/loadbalancer/loadbalancer_db.py", line 476, in get_vips

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource filters=filters, fields=fields)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/db/db_base_plugin_v2.py", line 197, in _get_collection

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource items = [dict_func(c, fields) for c in query]

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File "/usr/lib/python2.7/dist-packages/neutron/db/loadbalancer/loadbalancer_db.py", line 238, in _make_vip_dict

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource fixed_ip = (vip.port.fixed_ips or [{}])[0]

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource AttributeError: 'NoneType' object has no attribute 'fixed_ips' 

There is a patch for this in the ODK extension provided by the F5 Onboard package.