---
layout: docs_page
title: F5 LBaaS Plug-in - OpenStack Installation Tips
url: {{ page.title | slugify }}
tags: lbaas, openstack, plugin
resource: true
openstack version: 
---

#F5 LBaaS Plug-in -- OpenStack Installation Tips

## Common Pitfalls

### Network Node Sysctl

Some OpenStack installers do not set up the network node to route
traffic. If this is the case, you will need to set some `sysctl` variables manually. 

**NOTE:** The below configuration example uses Ubuntu. 

To configure the network node to properly route traffic:
1. Add the following lines to the */etc/sysctl.conf* file:

`net.ipv4.conf.default.rp\_filter=0`
`net.ipv4.conf.all.rp\_filter=0`
`net.ipv4.conf.br0.rp\_filter=0`
`net.ipv4.ip\_forward=1`

2. Execute `sysctl -p`.

### Change Kernel Settings to Allow GRE Packets to Reach VMs

**CAUTION:** If you are uncertain whether this issue applies to you, please refer to the [F5 OpenStack ADC Integration Guide](https://devcentral.f5.com/d/f5-and-openstack-adc-integration-guide). It is essential that you know what network type and ADC integration method you will be using for your OpenStack LBaaS solution.

This issue may apply to you if your OpenStack installation utilizes the following:
 
 - Ubuntu 14.04
 - GRE networking
 - a BIG-IP vm using “Tunnel Underlay Provider Network” to connect the BIG-IP to various OpenStack networks

In Ubuntu 14.04, the way IP tables handle GRE packets are incompatible with how Neutron creates rules for IP tables. Neutron configures IP tables to drop INVALID packets *before* any other rules are processed. 

To address this issue:

Load the kernel module *nf\_conntrack\_proto\_gre* as part of the operating system installation and setup by running the below commands. 

`modprobe nf_conntrack\_proto_gre`
`grep -q nf_conntrack_proto_gre /etc/modules || echo`
`nf_conntrack_proto_gre &gt;&gt; /etc/modules`

### Security: Nova vs Neutron

The Nova compute project has its own network security policy system because it predates the Neutron project. If you are using Neutron, you should also be using Neutron security. 

Make sure you don't have both Nova security and Neutron security configured. The F5 OpenStack solutions are designed to use Neutron securtity. 

## BIG-IP Troubleshooting
If you're having trouble running BIG-IP on OpenStack, OpenStack itself may be the source of the problem. You should test all of your OpenStack networking functions with other virtual machines before concluding the problem is specific to BIG-IP. 

The status checks and troubleshooting tips provided here can be used to double-check your configuration before [contacting F5 support](https://support.f5.com/kb/en-us.html). 

### Check that all services are running

Run the following commands to see if all services are “up”:

`\# neutron agent-list`

`\# nova service-list`

### Check that your VM's console access is working

If OpenStack networking is not working properly, it can be helpful to access the VM console to perform troubleshooting steps. **You should make sure you can reach the VM console before launching BIG-IP.** 

### Ensure DHCP works

You should ensure that DHCP works with other VMs before launching BIG-IP.
\[Do we need to provide steps / links to outside instructions on how to do this? --JP \]

### Ensure floating IPs work

Assign a floating IP to a VM and ensure that works **before** launching BIG-IP.
\[Do we need to provide steps / links to outside instructions on how to do this? --JP \]

### Check that metadata access is working

You should ensure that a VM can access the metadata service **before** launching BIG-IP. Usually, this can be accessed with the following command:

`curl http://[ip-address]/latest/user-data`

### Ping between VMs on the same and different hosts

You can ping VMs running on the same Nova host and on different Nova hosts to test their functionality.

## Additional Resources
If you've determined that your issue is with OpenStack and not with BIG-IP, you may want to check the [OpenStack documentation](http://docs.openstack.org/) or browse the [OpenStack bugs](https://bugs.launchpad.net/openstack).