---
layout: docs_page
title: F5 Packstack Workarounds
url: {{ page.title | slugify }}
categories: openstack, testing, tools, packstack
resource: true
---
<div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span>
    </button>
    <strong>Heads up!</strong> This doc is under development.
</div>

# Automated Workarounds

**These workarounds are automatically executed by the appropriate ODK commands and do not require any action on your part. These workarounds are described here for informational purposes.**

### PackStack Patch

This patch fixes these problems:
https://ask.openstack.org/en/question/35705/attempt-of-rdo-aio-install-icehouse-on-centos-7/
https://openstack.redhat.com/Workarounds#Could_not_enable_mysqld

This workaround is implemented by the following script (which is executed when you ran /usr/libexec/odk/openstack/packstack/install.sh on the controller):
`/usr/libexec/odk/openstack/packstack/patch-packstack.sh`

### Allow Security Access to OpenStack API

https://bugs.launchpad.net/packstack/+bug/1288447

If you are using a OpenStack client that accesses certain OpenStack API ports (e.g. 9292 or 9696) from IP addresses that Packstack has not been told about, then there needs to be an iptables entry to allow access to those services from any host. If you do not, you will get a “no route to host” or “max retries” error. This error sounds like a networking problem but it is actually the result of an administrative security policy.

The following is done on the **services/control host**:

The following two ACCEPT lines are added before the existing REJECT line (shown below) in the file:

```
-A INPUT -p tcp -m multiport --dports 9292 -m comment --comment "001 glance incoming" -j ACCEPT

-A INPUT -p tcp -m multiport --dports 9696 -m comment --comment "002 quantum incoming" -j ACCEPT

-A INPUT -j REJECT --reject-with icmp-host-prohibited
```

Then this command is run:
`service iptables restart`

This workaround is implemented by the following script, which is executed **after** Packstack is launched by odk-openstack deploy:
`/usr/libexec/odk/openstack/packstack/open-neutron-ports.sh`

### Allow Hosts to Forward or Accept Packets

The **network gateway host**, which is responsible for forwarding packets, has an iptables rule that prevents forwarding. This workaround deletes that rule.

In */etc/sysconfig/iptables*, delete the following line:
`-A FORWARD -j REJECT --reject-with icmp-host-prohibited`

Then, run the following command:
`service iptables restart`

This workaround is implemented by the following script, which is executed **after** Packstack is launched by odk-openstack deploy: 
`/usr/libexec/odk/openstack/packstack/allow-gateway-forwarding.sh`

### Set Nova Release File

This workaround sets the /etc/nova/release file on the compute node to this:

```
[Nova]
vendor = Red Hat
product = Bochs
package = RHEL 6.3.0 PC
```

Then:
`systemctl restart openstack-nova-compute`

This workaround is implemented by the following script, which is executed after OpenStack is deployed.
`/usr/libexec/f5-onboard/ve/openstack/patch-nova-release.sh`

### Single IP Setup

This workaround sets up the br-ex bridge, OVS, and IP tables to operate with OpenStack with only a single IP address on the host. This workaround is implemented by the following script, which is executed after OpenStack is deployed.
`/usr/libexec/odk/openstack/packstack/setup-single-ip.sh`

The following steps document what you would need to do manually to accomplish what the script above does.

####**DO NOT PERFORM THESE STEPS.**

On the **network node** only, configure the IP address on the “external” bridge. You will set it to the same value you have configured for “ext-address”. Do that in */etc/sysconfig/network-scripts/ifcfg-br-ex*:

```
vi /etc/sysconfig/network-scripts/ifcfg-br-ex
# Contents: (don’t include this line)
DEVICE=br-ex
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
IPADDR=10.99.65.38
NETMASK=255.255.255.224
ONBOOT=yes
```

Then run this command:
`systemctl restart network`

There seems to be an issue that prevents br-ex from picking up its IP address. (You can run the “ip addr” command to verify that br-ex has an IP address). Please **run the command again** to ensure br-ex has an IP address:
`systemctl restart network`.

In the Single IP configuration, the initial tunnel IP address that Packstack configures would be the host address because that is what is available when packstack is run. Now that we have setup the address on br-ex for OpenStack purposes, we will use that address for tunneling. (We need to do this because we are supporting the ability for service
VMs (BIG-IP VE) to connect to the tunnel network and they allocate IPs on that network for that purpose. Since we have only one IP address at the Host level, there are not enough addresses to allocate to those VMs. So, we just use the private network, which we already need for floating-ips, for that purpose.) In order to complete this configuration, we must redefine the local tunnel address to the private subnet address.

Change local_ip in the following file and set it to the same value you have configured for “ext-address”.

```
vi /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
systemctl restart neutron-openvswitch-agent
```

If you are using the single machine and single network configuration, which has both data net and external net combined with the management network (`--data-net-topology combined` `--ext-net-topology combined`), and you are using the single IP address configuration, then there are additional commands which must be run to make that work:

```
iptables -I FORWARD -i br-ex -j ACCEPT
iptables -I FORWARD -o br-ex -j ACCEPT
iptables -N selective-nat -t nat
iptables -t nat -I POSTROUTING -s 10.99.65.32/27 -j selective-nat
iptables -A selective-nat -t nat -s 10.99.65.38/32 -j RETURN
iptables -A selective-nat -t nat ! -d 10.99.65.32/27 -j MASQUERADE
```

### Install F5 LBaaS

This workaround is implemented by the following script, which is executed after OpenStack is deployed.
`/usr/libexec/f5-onboard/lbaas/setup-lbaas.sh`

The following steps document what you would need to do manually to accomplish what the script above does.

####**DO NOT PERFORM THESE STEPS.**

Install python libraries on the **network host**. The F5 agent uses suds for iControl/SOAP support:
`yum install -y python-suds`

Install both RPMs on the **network host**:

```
rpm –i f5-bigip-lbaas-agent-1.0.3-1.noarch.rpm
f5-lbaas-driver-1.0-1.noarch.rpm
```

Install just the driver rpm on the **control host**.
`rpm –i f5-lbaas-driver-1.0.3-1.noarch.rpm`

On the **network host**, configure the agent:
`vi /etc/neutron/f5-bigip-lbaas-agent.ini`

- If you used automated VE onboarding and tunneling, f5_vtep_selfip_name should be selfip.datanet.
- If you are using VLANs, f5_vtep_folder and f5_vtep_selfip_name should be “None” (without quotes).

Now on the **services/control (neutron server) host**, add the F5 LBaaSv1 plug in to */etc/neutron/neutron.conf*:

```
vi /etc/neutron/neutron.conf
[DEFAULT]
…
service_plugins=neutron.services.l3_router.l3_router_plugin.L3RouterPlugin,neutron.services.firewall.fwaas_plugin.FirewallPlugin,neutron.services.loadbalancer.plugin.LoadBalancerPlugin

[service_providers]
…
service_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin_driver.F5PluginDriver
```
**NOTE:** If you do not want to use HA proxy, then append ":default" to the end of the service_provider line above to make F5 the default. Also, comment out HAProxy from */usr/share/neutron/neutron-dist.conf*:

```
[service_providers]
#service_provider =
LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
```

Finally, restart neutron:
`systemctl restart neutron-server`

Then on the **network host**:
`systemctl restart f5-bigip-lbaas-agent`

Packstack does not enable load balancing in the Horizon GUI by default. To change that, set `enable_lb` to `True` on the **services host**:

```
vi /etc/openstack-dashboard/local_settings
# change the bold line below to enable load balancing in the GUI:
OPENSTACK_NEUTRON_NETWORK = {
'enable_lb': True,
'enable_firewall': False,
'enable_quotas': True,
'enable_security_group': True,
'enable_vpn': False,
# The profile_support option is used to detect if an external router can be
# configured via the dashboard. When using specific plugins the
# profile_support can be turned on if needed.
'profile_support': None,
#'profile_support': 'cisco',
}
```
Then, run `systemctl restart httpd`.
