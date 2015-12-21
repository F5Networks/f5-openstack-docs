Table of Contents {#table-of-contents .TOCHeading}
=================

[Introduction 1](#introduction)

[Overview 1](#overview)

[Related Documents 1](#related-documents)

[OpenStack Deployment Tips 2](#openstack-deployment-tips)

[OpenStack Installation Pitfalls 2](#openstack-installation-pitfalls)

[Network Node Sysctl 2](#network-node-sysctl)

[Load kvm kernel module on Ubuntu 12.04
2](#load-kvm-kernel-module-on-ubuntu-12.04)

[Allow GRE to VMs 3](#allow-gre-to-vms)

[Nova and Neutron Security 3](#nova-and-neutron-security)

[OpenStack Sanity Checks 4](#openstack-sanity-checks)

[Ensure Services are Running 4](#ensure-services-are-running)

[Ensure console access is working 4](#ensure-console-access-is-working)

[Ensure DHCP works 4](#ensure-dhcp-works)

[Ensure floating IPs work 4](#ensure-floating-ips-work)

[Ensure metadata access is working
4](#ensure-metadata-access-is-working)

[Ping between VMs on the same and different hosts
5](#ping-between-vms-on-the-same-and-different-hosts)

[Deployment Options 6](#deployment-options)

[Overview 6](#overview-1)

[BIG-IQ 6](#big-iq)

[HA Type 6](#ha-type)

[Replication Mode 6](#replication-mode)

[Global Routed 6](#global-routed)

[Traffic Return 6](#traffic-return)

[SNAT Mode 6](#snat-mode)

[Gateway Mode 6](#gateway-mode)

[LBaaS Dedicated 7](#lbaas-dedicated)

[Deploying TMOS Devices Overview 8](#deploying-tmos-devices-overview)

[Deploying BIG-IQ 9](#deploying-big-iq)

[Hardware 9](#hardware)

[Deploying BIG-IQ Virtual Edition 9](#deploying-big-iq-virtual-edition)

[BIG-IQ LBaaS Setup 9](#big-iq-lbaas-setup)

[OpenStack Setup for BIG-IQ 9](#openstack-setup-for-big-iq)

[Deploying BIG-IPs 11](#deploying-big-ips)

[Deploying BIG-IP Hardware 11](#deploying-big-ip-hardware)

[Licensing 11](#licensing)

[Data network connectivity 11](#data-network-connectivity)

[Deploying BIG-IP Virtual Edition 12](#deploying-big-ip-virtual-edition)

[BIG-IP Setup for Use with Big-IQ 12](#big-ip-setup-for-use-with-big-iq)

[Deploying LBaaS Plug-in 13](#deploying-lbaas-plug-in)

[Driver Installation 13](#driver-installation)

[Install Neutron Server Packages 13](#install-neutron-server-packages)

[For Ubuntu: 13](#for-ubuntu)

[Red Hat/Centos: 13](#red-hatcentos)

[Configure Neutron Server 13](#configure-neutron-server)

[Agent Deployment Options 15](#agent-deployment-options)

[BIG-IP Cluster Scope 15](#big-ip-cluster-scope)

[Tenant Scheduler 15](#tenant-scheduler)

[Relation to BIG-IQ 15](#relation-to-big-iq)

[Agent Placement 15](#agent-placement)

[Agent Installation 17](#agent-installation)

[Install Neutron Gateway Packages 17](#install-neutron-gateway-packages)

[Ubuntu: 17](#ubuntu)

[Red Hat/Centos: 17](#red-hatcentos-1)

[Stop Agent 17](#stop-agent)

[Installing Additional Agents 17](#installing-additional-agents)

[Agent Configuration 18](#agent-configuration)

[Restart Agent 25](#restart-agent)

[Check the Agent Status 25](#check-the-agent-status)

[Enable LBaaS GUI in OpenStack 25](#enable-lbaas-gui-in-openstack)

[Tuning and Performance 27](#tuning-and-performance)

[Limitations 27](#limitations)

[Route Domains, Tunnels, VLANs 27](#route-domains-tunnels-vlans)

[Overlapping Subnets within one OpenStack Project
27](#overlapping-subnets-within-one-openstack-project)

[Procedures 28](#procedures)

[Agent High Availability 28](#agent-high-availability)

[Scaling Out With Multiple Clusters
28](#scaling-out-with-multiple-clusters)

[Overview 28](#overview-2)

[Add Additional Cluster 28](#add-additional-cluster)

[Disable Cluster for New Tenants 28](#disable-cluster-for-new-tenants)

[Disable New Pools on Cluster 28](#disable-new-pools-on-cluster)

[Remove Pool From Cluster 28](#remove-pool-from-cluster)

[Remove Tenant From Cluster 28](#remove-tenant-from-cluster)

[Move Tenant to New Cluster 29](#move-tenant-to-new-cluster)

[GTM Integration 29](#gtm-integration)

[Introduction 29](#introduction-1)

[Wide IP Setup 29](#wide-ip-setup)

[Divert away 29](#divert-away)

[Divert back 29](#divert-back)

[Troubleshooting 30](#troubleshooting)

[Log Files 30](#log-files)

[Neutron Server 30](#neutron-server)

[Neutron Gateway 30](#neutron-gateway)

[Packet Tracing 30](#packet-tracing)

[Network Node 30](#network-node)

[Compute Node 30](#compute-node)

[BIG-IP 31](#big-ip)

Introduction
============

Overview
--------

This guide covers the specific steps for setting up and configuring F5’s
OpenStack solution. It covers how to deploy the overall solution,
including BIG-IQ, BIG-IP(s), and the F5 LBaaS Plug-in for OpenStack. It
also covers operating and troubleshooting the OpenStack solution. It
presumes the F5 OpenStack LBaaS Solution Overview and the F5 OpenStack
ADC Integration Guide have been read and the appropriate deployment
decisions have been made.

Related Documents
-----------------

*F5 OpenStack LBaaS Solution Overview*

This guide describes F5’s OpenStack BIG-IP solution from a high level
functional point of view. It describes the value proposition, the major
components, and the major variations for deploying the solution. The
goal of the document is to help customers choose the appropriate
deployment variation that fits their requirements best.

*F5 OpenStack ADC Integration Guide*

This guide dives deep into the networking issues surrounding the
integration of BIG-IPs with OpenStack. The intent of the document is to
help the customer understand the technical requirements that flow from
the preliminary deployment choices the customer has made (for example,
whether to use multitenant BIG-IPs, or whether to use VLANs or GRE
tunnels) after reading the Solution Overview document. After making
preliminary choices, the customer should take a look at the detailed
technical issues regarding those choices to ensure they understand the
pros and cons of their choice.

*F5 TMOS Virtual Edition OpenStack Deployment Guide*

This guide covers available tools that can be used to deploy BIG-IP and
BIG-IQ in an automated fashion. Manual instructions are provided as well
as a description of corresponding tools available via our F5 DevCentral
community. Please note that the automation tools are considered “Open
Source” and there is no support available for them at this time.

*F5 OpenStack LBaaS Plug-in Design Guide*

This guide describes the design and operation of the F5 LBaaS plug-in.
It covers internal components, major functional operations, and a
detailed explanation of the BIG-IP configuration strategy it uses.

\
OpenStack Deployment Tips
=========================

OpenStack Installation Pitfalls
-------------------------------

The following sections describe common OpenStack installation pitfalls
and how to avoid them.

### Network Node Sysctl

Some OpenStack installers do not setup the network node to route
traffic, which is an essential part of its job. Certain sysctl variables
are required to be set properly, per the documentation at the following
URL:

<http://docs.openstack.org/juno/install-guide/install/apt/content/neutron-network-node.html>

In order to set this up, place the following lines in the
/etc/sysctl.conf file (using Ubuntu for example):

net.ipv4.conf.default.rp\_filter=0

net.ipv4.conf.all.rp\_filter=0

net.ipv4.conf.br0.rp\_filter=0

net.ipv4.ip\_forward=1

Then execute:

sysctl -p

### Load kvm kernel module on Ubuntu 12.04

If you are running the Nova Compute service for OpenStack Icehouse on
Ubuntu 12.04, then you may need to configure a kernel module. This issue
is described at the following URL:

<https://bugs.launchpad.net/openstack-manuals/+bug/1313975>

### \
Allow GRE to VMs

You may need to make a change to your OpenStack installation in order to
allow GRE packets to reach virtual machines. This step may be relevant
if you are using GRE networking with OpenStack and you have chosen to
use a BIG-IP Virtual Machine with “Tunnel Underlay Provider Network” as
the method for connecting the BIG-IP to various OpenStack networks. If
you are uncertain whether this issue applies to you, please read the F5
OpenStack ADC Integration Guide as it is essential that you know what
network type and what ADC integration method you will be using for your
OpenStack LBaaS solution.

The reason this change may be necessary is that recent kernels,
including the recent kernel for Ubuntu 14.04, changed the way that IP
Tables (which is for networking security policy) handles GRE packets.
Now, a GRE packet will be considered INVALID unless certain kernel
modules are enabled. The way that Neutron creates rules for IP Tables is
incompatible with the recent kernel change because Neutron configures IP
Tables to drop INVALID packets before any other rules are processed that
might allow the traffic. Therefore, the proper operation of Neutron’s IP
Tables essentially requires that the operating system be setup properly
in advance. The solution is that the kernel module
“nf\_conntrack\_proto\_gre” must be loaded as part of the operating
system installation and setup. The following commands show how to do
that for Ubuntu:

modprobe nf\_conntrack\_proto\_gre

grep -q nf\_conntrack\_proto\_gre /etc/modules || echo
nf\_conntrack\_proto\_gre &gt;&gt; /etc/modules

### Nova and Neutron Security

For historical reasons, the Nova compute project has its own network
security policy system because it predates the Neutron project. Assuming
you are using Neutron, you should be using Neutron security. Enabling
Neutron security and disabling Nova security is a procedure that is not
easy to do. Indeed, nothing prevents configuring both security systems
at the same time.

You should make sure you have not configured both Nova and Neutron
security. We assume you are using Neutron and if security is a
requirement (and it almost always is) then you should enable Neutron
security and disable Nova security.

OpenStack Sanity Checks
-----------------------

If you have trouble running BIG-IP on OpenStack, it may be that
OpenStack itself is the source of the problem. You should ensure that
your OpenStack is fully functional and you should test all functions
with other virtual machines before concluding the problem is specific to
BIG-IP. A number of status checks and troubleshooting steps are provided
in this section that should be checked before further troubleshooting or
contacting F5 support.

### Ensure Services are Running

Run the following commands and ensure all services are “up”:

\# neutron agent-list

\# nova service-list

### Ensure console access is working

You should be able to access the console of a VM. If OpenStack
networking is not working properly, it can be helpful to access the VM
console in order to perform troubleshooting steps. You should make sure
you can reach the console for your VMs before launching BIG-IP.

### Ensure DHCP works

You should ensure that DHCP is working with other VMs before launching
BIG-IP.

### Ensure floating IPs work

You should assign a floating IP to a VM and ensure that works before
launching BIG-IP.

### Ensure metadata access is working

You should ensure that a VM can access the metadata service before
launching BIG-IP. Usually this can be accessed with the following
command:

curl http://169.254.169.254/latest/user-data

### Ping between VMs on the same and different hosts

You should ping between VMs running on the same Nova host and between
different Nova hosts.

\
Deployment Options
==================

Overview
--------

This chapter covers the various deployment options available for the
LBaaS Solution. For each section, you will need to decide which option
to use so that you can follow the appropriate instructions for deploying
that portion of the solution.

BIG-IQ
------

HA Type
-------

Replication Mode
----------------

Global Routed
-------------

Traffic Return
--------------

### SNAT Mode

### Gateway Mode

\
LBaaS Dedicated
---------------

F5 recommends having BIG-IPs dedicated to LBaaS to avoid conflicts with
other administrative operations. For example, the LBaaS plug-in
periodically saves the configuration. If an administrator was
configuring BIG-IP at the same time then saving the configuration may
not be desirable.

Another example is that route domain allocation may conflict. The LBaaS
plug-in uses the first route domain available when allocated a new route
domain. An administrator might have decided to use the same route domain
and not realize the LBaaS plug-in had already allocated it.

These are just a couple examples of why F5 recommends dedicating your
BIG-IPs to the LBaaS solution. We understand that customers may have
expensive, high capacity BIG-IP appliances or chassis that are far more
capacity than necessary for the LBaaS solution and that there may be a
strong desire to utilize that extra capacity for other purposes. We
recommend using F5 technology such as VCMP in these cases to create
virtual instances of BIG-IP that can be dedicated to LBaaS. There is no
problem with using other VCMP instances in the same BIG-IP chassis for
purposes other than LBaaS because the same management conflicts
mentioned above will not be an issue.

\
Deploying TMOS Devices Overview
===============================

At this point you should have chosen whether you are using shared
multi-tenant BIG-IPs, tenant-dedicated BIG-IPs, or a hybrid of dedicated
and shared BIG-IPs. This issue is described in the F5 OpenStack LBaaS
Solution overview and is summarized in the following paragraph.

If an OpenStack tenant has BIG-IP deployed in their OpenStack project,
the plug-in will deploy their iApp directly to that BIG-IP using BIG-IQ.
In that case the BIG-IQ will “discover” that BIG-IP (i.e. place it under
BIG-IQ management) and then the BIG-IQ will deploy LBaaS iApp services
to that BIG-IP whenever the tenant configures an LBaaS service via
OpenStack. If, on the other hand, the tenant does not have a BIG-IP, the
plug-in can fall back to using a multitenant, shared BIG-IP cluster. In
the latter case, configuration does not go through BIG-IQ with the
current version of the solution.

If you have chosen to include dedicated BIG-IPs in your solution then
you will need to deploy BIG-IQ. If you have chosen not to use dedicated
BIG-IPs for tenants, then the BIG-IQ is not required for the proper
operation of the LBaaS solution. Later in this guide you can skip the
instructions for deploying and configuring BIG-IQ.

Note that we recommend BIG-IQ for general device management, such as
licensing and upgrades and anticipate that BIG-IQ will become a more
essential part of the LBaaS solution in the future. So while you may
choose not to deploy BIG-IQ now, you may need to in the future to remain
compatible with the LBaaS solution.

\
Deploying BIG-IQ
================

This section describes how to deploy BIG-IQ as part of the LBaaS
solution. BIG-IQ supports the deployment of LBaaS services to a
tenant-dedicated BIG-IP. You will need to decide whether to deploy
BIG-IQ as hardware or software. The various reasons to pick either
hardware or software are beyond the scope of this document.

### Hardware

This section describes how to deploy BIG-IQ as hardware.

The detailed instructions for setting up an F5 hardware device are
outside the scope of this document but a summary is provided here.

The first thing to do is the basic hardware setup, which includes:

-   Rack the device and connect the power cables.

-   Connect the BIG-IQ to your switch.

-   Turn on the BIG-IQ

The next thing to do is to setup and configure the device. If you are
using DHCP, then connect to with the DHCP address. If DHCP is not
configured, the device will default to 192.168.1.245. The default
credentials are admin/admin for the GUI and API and root/default for the
command line.

### Deploying BIG-IQ Virtual Edition

If you have decided to deploy BIG-IQ as a virtual machine in OpenStack,
then please refer to the F5 OpenStack TMOS VE deployment guide for
detailed instructions.

### BIG-IQ LBaaS Setup

The LBaaS solution does not require any specific configuration to make
it work except that the initial setup screen must be completed and the
product must also be licensed properly.

TODO: Is adding a route necessary so that discovery is done via TMM
interface?

### OpenStack Setup for BIG-IQ

On the Nova Controller server:

Edit the /etc/nova/policy.json file and change this setting to the
following value:

"compute\_extension:server\_diagnostics": "rule:admin\_or\_owner",

Then restart the Nova server:

service nova-api-os-compute restart

\
Deploying BIG-IPs
=================

### Deploying BIG-IP Hardware

The first thing to do is the basic hardware setup, which includes:

-   Rack the device and connect the power cables.

-   Connect the BIG-IP to your switch.

-   Turn on the BIG-IP

-   Go through the setup process, including licensing and provisioning

We assume that if you are using BIG-IP hardware then you intend to use
the device for multitenant networking. Please see the ADC integration
guide if this remains an open question.

#### Licensing

In order to use multitenancy with tunneling support, you will need a
BIG-IP License with “SDN Services” feature.

tmsh show sys license | grep SDN

We also recommend that you provision for extra management memory to
support many route domains:

tmsh modify sys db provision.extramb { value 500 }

#### Data network connectivity

Finally, the BIG-IP hardware needs to be connected to the OpenStack
networking infrastructure. For VLAN based OpenStack networking, the
BIG-IP should be connected to a VLAN trunk. For tunnel based OpenStack
networking, the BIG-IP should be connected to the physical underlay
network used for tunneling. Furthermore, for tunneling, a VLAN and self
IP address must be configured. Later in the instructions, you will
configured the plug-in with the details of how you have configured the
BIG-IP, such as which interface you connected to the VLAN trunk in the
case of VLANs.

### \
Deploying BIG-IP Virtual Edition

If you have decided to deploy BIG-IQ as a virtual machine in OpenStack,
then please refer to the F5 OpenStack TMOS VE deployment guide for
detailed instructions on how to preparing images for OpenStack, deploy
instances, and configure BIG-IP in a virtual environment.

#### BIG-IP Setup for Use with Big-IQ

If you are deploying a BIG-IP VE for each tenant and are using BIG-IQ,
then there are certain customization options available for how the
BIG-IQ “discovers” the BIG-IP.

##### Network Naming

&lt;Explain setting meta data to customize the external/internal
network&gt;

##### Credentials

&lt;Explain setting meta data to customize the admin credentials &gt;

##### Install LBaaS iApp RPM

Install iApp RPM

\
Deploying LBaaS Plug-in
=======================

Driver Installation
-------------------

### Install Neutron Server Packages

You will need to install the plug-in driver. Perform these steps on the
Neutron Server. The actual names of the package may vary from version to
version.

#### For Ubuntu:

dpkg -i f5-lbaas-driver\_1.0.7-1\_all.deb

#### Red Hat/Centos:

rpm -i f5-lbaas-driver-1.0.7-1.noarch.rpm

### Configure Neutron Server

Modify the /etc/neutron/neutron.conf configuration file on the Neutron
server to include the following entries:

\[DEFAULT\]

service\_plugins=neutron.services.l3\_router.l3\_router\_plugin.L3RouterPlugin,neutron.services.firewall.fwaas\_plugin.FirewallPlugin,neutron.services.loadbalancer.plugin.LoadBalancerPlugin,neutron.services.vpn.plugin.VPNDriverPlugin,neutron.services.metering.metering\_plugin.MeteringPlugin

If you are using F5 LBaaS only, then this entry must also be present:

\[service\_providers\]

service\_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin\_driver.F5PluginDriver:default

Here is an alternative to the previous setting that supports using both
F5 (the default) and HA Proxy:

\[service\_providers\]

service\_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin\_driver.F5PluginDriver:default

service\_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin\_driver.HaproxyOnHostPluginDriver

Then restart the neutron server:

service neutron-server restart

You can check for errors and other relevant log messages in
/var/log/neutron/server.log on the Neutron server.

\
Agent Deployment Options
------------------------

### BIG-IP Cluster Scope

Each F5 LBaaS agent can directly manage one and only one cluster of
BIG-IPs. Note that a cluster of BIG-IPs called a “Device Service Group”
(DSG) in F5 terminology. Before you deploy the agent, you should have a
DSG deployed already and you should know which IP addresses and
credentials should be used to access the devices. You will need to put
this information in the agent configuration file later.

### Tenant Scheduler

By default the F5 LBaaS Plug-in uses an agent scheduler which will keep
all LBaaS pools associated with the same tenant on the same TMOS Device
Service Groups. This association is maintained in the OpenStack database
in a standard fashion. You can view those associations by running the
command:

neutron agent-list

Then for each load balancing agent:

neutron lb-pool-list-on-agent &lt;agent-id&gt;

Even if you add more agents and corresponding device service groups, the
LBaaS plug-in will know which agent it should talk to in order to
service a given tenant. However, if you delete all pools for a tenant,
there will no longer be any record of how to map the tenant pool to an
agent, and so the BIG-IP may choose a new agent for that tenant.

### Relation to BIG-IQ

Alternatively, it may delegate iApp deployment to a BIG-IQ. In the case
where BIG-IQ is used, the BIG-IQ may deploy to more than one cluster of
BIG-IPs but the LBaaS agent will perform no direct interaction with
BIG-IQ managed BIG-IPs.

### Agent Placement

The F5 LBaaS agent can be run on any host which has the appropriate
Neutron python libraries installed. Typically, a Neutron Controller or
Neutron Gateway node is used because those nodes have the appropriate
libraries already. An alternative is to have a dedicated node for
running agents. Multiple F5 LBaaS agent processes can run on the same
host simultaneously.

\
Agent Installation
------------------

### Install Neutron Gateway Packages

You will need to install the F5 LBaaS agent. Perform these steps on
whichever server you have decided to install the agent. Typically this
is done on the Neutron Gateway node.

#### Ubuntu:

dpkg -i f5-bigip-lbaas-agent\_1.1.0-1\_all.deb

#### Red Hat/Centos:

rpm -i f5-bigip-lbaas-agent-1.1.0-1.noarch.rpm

The actual file names may vary from version to version.

#### Stop Agent

Since the agent has not been configured yet, you should stop it now so
it doesn’t fill your logs with errors.

service f5-bigip-lbaas-agent stop

If you want to start with clean logs, you should remove the log file:

rm /var/log/neutron/f5-bigip-lbaas-agent.log

### Installing Additional Agents

The F5 LBaaS solution supports running multiple agents, managing
multiple clusters, simultaneously. The agent

If you are installing additional agents, each on a separate host, then
you can simply install

### Agent Configuration

This agent configuration is in the file
/etc/neutron/f5-bigip-lbaas-agent.ini. The following is a copy of the
configuration file which includes an explanation of the various settings
available.

Figure 1

<img src=""/> [ADD IN IMAGE FROM WORD DOC OR SCREENSHOT]

### \
Restart Agent

If you want to start with clean logs, you should remove the log file:

rm /var/log/neutron/f5-bigip-lbaas-agent.log

Now restart the agent:

service f5-bigip-lbaas-agent restart

### Check the Agent Status

Check the agent status to make sure the agent is running. You may need
to wait a few seconds after restarting the agent before it shows up in
the list.

manager@maas-ctrl-4:\~\$ neutron agent-list

Figure 2

<img src=""/> [ADD IN IMAGE FROM WORD DOC OR SCREENSHOT]

If the agent does not start properly, there should be an error logged in
the file /var/log/neutron/f5-bigip-lbaas-agent.log.

### Enable LBaaS GUI in OpenStack

On the OpenStack “cloud controller” node, which runs the GUI, change the
enable\_lb option to True in the local\_settings file.

This is the file to change for different Operating Systems:

-   RHEL, and CentOS: /etc/openstack-dashboard/local\_settings

-   Ubuntu: /etc/openstack-dashboard/local\_settings.py

The syntax will be something like this:

OPENSTACK\_NEUTRON\_NETWORK = { 'enable\_lb': True, ...}

Then restart the web server for the setting to take effect:

service httpd restart

\
Tuning and Performance
======================

This section should provide our tested performance numbers for BIG-IP
running on KVM on a Dell 620 with an Intel 10GB (ixgbe) card with SR-IOV
enabled.

Configuration and performance improvements for jumbo frames should be
covered here.

Limitations
===========

### Route Domains, Tunnels, VLANs

The maximum number of route domains is currently quoted as 500.

The maximum number of tunnels or vlans has a hardcoded limit of around
64 thousand but in reality the F5 configuration database can only handle
vlans/tunnels in the low thousands efficiently.

### Overlapping Subnets within one OpenStack Project

Currently, the solution does not support having overlapping IP subnets
within the *same* OpenStack Project. The solution does support multiple
tenants and each tenant can be using an IP subnet that overlaps with
another tenant’s IP subnet. The limitation is when you try to create the
same subnet, such as 10.0.0.0/24, twice in the same project. OpenStack
actually supports this. We are evaluating whether to support this
feature in the future and would like to hear from customers whether this
is an important feature.

\
Procedures
==========

Agent High Availability
-----------------------

This solution supports running the F5 LBaaS Agent in a high availability
mode. Further details will be provided in the future. (TODO)

Scaling Out With Multiple Clusters
----------------------------------

### Overview

This solution supports deploying iApps to multiple clusters of BIG-IPs.
Additional clusters can be setup by running additional F5 LBaaS Agents
on additional servers. Each agent will manage their own BIG-IP cluster.

### Add Additional Cluster

Setup cluster

Setup agent.

### Disable Cluster for New Tenants

If a cluster is getting overloaded, disable it for new tenants.

### Disable New Pools on Cluster

If a cluster is getting really overloaded, disable it for new pools.

### Remove Pool From Cluster

Disable new tenants.

Remove a service for tenant. Create service again.

### Remove Tenant From Cluster

### Move Tenant to New Cluster

GTM Integration
---------------

### Introduction

### Wide IP Setup

### Divert away

### Divert back

\
Troubleshooting
===============

Log Files
---------

### Neutron Server

/var/log/neutron/server.log

### Neutron Gateway

/var/log/neutron/ f5-bigip-lbaas-agent.log

grep ERROR /var/log/neutron/f5-bigip-lbaas-agent.log

Packet Tracing
--------------

### Network Node

ping the VM floating IP

neutron router-list

ip netns list

ip netns exec &lt;ns&gt; bash

ping the VM fixed IP

ovs-vsctl show

tcpdump

### Compute Node

ovs-vsctl show

tcpdump

### BIG-IP

Before tracing tunnel packets, be sure you have the proper license.
