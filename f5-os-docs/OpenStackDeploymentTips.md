---
layout: default
title: OpenStack Deployment Tips
---
#F5 LBaaS Plug-in -- OpenStack Installation Tips

## Common Pitfalls

### Network Node Sysctl

Some OpenStack installers do not set up the network node to route
traffic, which is an essential part of its job. Certain `sysctl` variables
are required to be set properly, per the OpenStack documentation: [Install Guide - Neutron Network Node](http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-network-node.html).

In order to set this up, place the following lines in the */etc/sysctl.conf* file:

`net.ipv4.conf.default.rp\_filter=0`
`net.ipv4.conf.all.rp\_filter=0`
`net.ipv4.conf.br0.rp\_filter=0`
`net.ipv4.ip\_forward=1`


Then, execute `sysctl -p`.

**NOTE:** This configuration example uses Ubuntu. 

### Load KVM kernel module on Ubuntu 12.04

If you are running the Nova Compute service for OpenStack Icehouse on
Ubuntu 12.04, then you may need to configure a kernel module. This issue
is recorded in the OpenStack Manuals as [bug # 1313975](https://bugs.launchpad.net/openstack-manuals/+bug/1313975).

### Change Kernel Settings to Allow GRE Packets to Reach VMs

**CAUTION:** If you are uncertain whether this issue applies to you, please read the [F5 OpenStack ADC Integration Guide](). It is essential that you know what network type and what ADC integration method you will be using for your OpenStack LBaaS solution.

You may need to change your OpenStack installation to allow GRE packets to reach virtual machines. This step may be relevant if you're using GRE networking with OpenStack and you've chosen to use a BIG-IP Virtual Machine with “Tunnel Underlay Provider Network” as the method for connecting the BIG-IP to various OpenStack networks. 

The reason this change may be necessary is that recent kernels, including the recent kernel for Ubuntu 14.04, changed the way that IP tables handle GRE packets.

With the recent change, the way that Neutron creates rules for IP tables makes it incompatible with the OS. Neutron configures IP tables to drop INVALID packets *before* any other rules are processed. 

To address this issue, load the kernel module *nf\_conntrack\_proto\_gre* as part of the operating system installation and setup. The following commands can be used to do so for Ubuntu:

`modprobe nf\_conntrack\_proto\_gre`
`grep -q nf\_conntrack\_proto\_gre /etc/modules || echo`
`nf\_conntrack\_proto\_gre &gt;&gt; /etc/modules`

### Nova and Neutron Security

The Nova compute project has its own network security policy system because it predates the Neutron project. Assuming you are using Neutron, you *should* also be using Neutron security. 

You should make sure you have not configured both Nova and Neutron security. We assume you are using Neutron and, if security is a requirement (and it almost always is!), then you should enable Neutron security and disable Nova security.

## Sanity Checks

If you have trouble running BIG-IP on OpenStack, it may be that OpenStack itself is the source of the problem. You should ensure that your OpenStack cloud is fully functional **by testing all functions with other virtual machines** before concluding the problem is specific to BIG-IP. 

A number of status checks and troubleshooting steps are provided here; these can be used to double-check your configuration before [contacting F5 support]().

### Ensure Services are Running

Run the following commands and ensure all services are “up”:

`\# neutron agent-list`

`\# nova service-list`

### Ensure console access is working

**You should make sure you can reach the console for your VMs before launching BIG-IP.** If OpenStack networking is not working properly, it can be helpful to access the VM console to perform troubleshooting steps. 

### Ensure DHCP works

You should ensure that DHCP is working with other VMs before launching BIG-IP.

### Ensure floating IPs work

You should assign a floating IP to a VM and ensure that works before launching BIG-IP.

### Ensure metadata access is working

You should ensure that a VM can access the metadata service before launching BIG-IP. Usually this can be accessed with the following command:

`curl http://169.254.169.254/latest/user-data`

### Ping between VMs on the same and different hosts

You should ping VMs running on the same Nova host and on different Nova hosts to test functionality.