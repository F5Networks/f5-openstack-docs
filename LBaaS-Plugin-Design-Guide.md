---
layout: docs_page
title: LBaaS Plugin Design Guide
categories: lbaasv1, plugin, design, openstack
resource: true
---

#Introduction
==============================================================================
This document explains the architecture and design of the F5 OpenStack
LBaaS Plug-in for F5 BIG-IP. This is a highly technical document and is
intended to be read by F5 technical staff, partners, and customers, who
would like to gain a deeper understanding of how the F5 plug-in works.
This document is not intended for end-users of the LBaaS plug-in.

#Related Documents

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

*F5 OpenStack LBaaS Deployment Guide*

This guide covers the specific steps for setting up and configuring F5’s
OpenStack solution. It covers how to deploy the overall solution,
including BIG-IQ, BIG-IP(s), and the F5 LBaaS Plug-in for OpenStack. It
also covers operating and troubleshooting the OpenStack solution. It
presumes the OpenStack Solution Overview and the ADC Integration Guide
have been read and the appropriate deployment decisions have been made.

*F5 TMOS Virtual Edition OpenStack Deployment Guide*

This guide covers available tools that can be used to deploy BIG-IP and
BIG-IQ in an automated fashion. Manual instructions are provided as well
as a description of corresponding tools available via our F5 DevCentral
community. Please note that the automation tools are considered “Open
Source” and there is no support available for them at this time.

#Major Requirements

The major requirements of the plug-in are:

-   The plug-in supports the entire OpenStack LBaaS v1.0 API.

-   No extensions to the API have been implemented.

-   The database schema used in OpenStack to store LBaaS configuration
    has not been modified.

-   The plug-in will work with OpenStack Havana, Icehouse, and
    Juno releases.

-   All F5 platforms can be used (for appropriate scenarios)

-   The plug-in can leverage BIG-IQ for service deployment

#Plug-in Architecture/Design

##Overview

OpenStack defines standard services in terms of command line, API, and
GUI interfaces, and then utilizes a plug-in architecture for
implementing those services. For example, the networking system in
OpenStack can use various networking implementations, with the most
common being the standard “Neutron” system for networking. In some
cases, a plug-in implements so much functionality that they in turn use
a plug-in design. The Neutron networking system for example allows you
to plug in various networking services, such as load balancing.

The F5 OpenStack LBaaS Solution provides a plug-in for the Neutron load
balancing service. This plug-in is delivered as a package that installs
python code primarily, as well as related files such as startup scripts
and configuration files.

The plug-in leverages existing OpenStack python classes in order to
implement the primary functions of the services.

The F5 LBaaS code is delivered as two packages: the Plug-In and the
Agent. The Plug-in runs in the Neutron server and handles the LBaaS
requests. The Plug-in hands off to an Agent to handle provisioning the
load balancing service. There can be multiple agents and each agent
handles requests for a subset of the tenants.

##Components and Layers

###Major Components

The F5 LBaaS solution is packaged into these major deliverables:

-   F5 BIG-IQ Management Solution

    -   F5 LBaaS Plug-in Package

    -   F5 LBaaS Agent Package

-   F5 BIG-IP Application Delivery Controller

This is a breakdown of these deliverables into the major solution
components:

-   The Neutron Server, which initially receives LBaaS API requests.
    Neutron is part of OpenStack and must be setup and working before
    the F5 LBaaS solution is installed. F5 Networks does not sell or
    support OpenStack itself.

-   The F5 LBaaS Service Plug-in itself, which accepts F5 LBaaS requests
    from Neutron.

-   The F5 LBaaS Service Plugin Driver (F5PluginDriver), which is loaded
    by the F5 service plug-in, handles F5 LBaaS requests on behalf of
    the Plug-in, selects an Agent, and passes request to that Agent via
    a messaging-based Remote Procedure Call.

-   The F5 LBaaS Agent, which is responsible for handling the LBaaS
    requests for a subset of tenants. Each agent can utilize one BIG-IQ
    and/or one BIG-IP Device Service Group to setup the service for
    its tenants. The Agent loads an Agent Manager and delegates all
    requests to the manager.

-   The F5 LBaaS Agent Manager runs in the F5 Agent. It loads the F5
    Agent Driver, handles the requests from the Service Plug-in, and
    passes request to the F5 Agent Driver.

-   The F5 LBaaS Agent Driver runs in the F5 Agent. It is responsible
    for taking requests from the Agent Manager and, depending on
    configuration, either passes it to BIG-IQ or configures the
    BIG-IP directly.

-   BIG-IQ is the component of the solution that acts as a
    “Service Manager”. As a service manager, BIG-IQ publishes a catalog
    of services and supports the entire service lifecycle: creating,
    configuring, monitoring and deleting.

-   BIG-IP Device Service Groups

### Single Agent Diagram

Each agent manages one BIG-IP Device Service Group. Also, each agent can
delegate service deployment to a BIG-IQ. The lines around BIG-IQ are
dotted because BIG-IQ is optional.

The BIG-IQ can manage multiple independent BIG-IPs; one per tenant.

### Multiple Agents and BIG-IP Service Groups

There can be multiple agents. Each agent will automatically handle a
subset of the tenants.

### Agent-Tenant Affinity

The F5 LBaaS solution maps a tenant permanently to a particular agent.

## Agent Driver

### Overview

The layers in the diagram above are described in more detail in the
following sections.

### Plug-in Driver

(Not shown in diagram)

The plug-in driver is responsible for processing individual LBaaS APIs.
It converts those to an F5 LBaaS Service Request and passes the request
to the agent.

### Agent Manager

The agent manager is responsible for being the endpoint for RPC calls
and relaying those to the driver.

###iControl Driver

The driver is responsible for configuring all aspects of the service.
The driver leverages additional “Builder” classes to configure the
networking on BIG-IP if necessary and build the higher level objects or
the iApp, possibly deploying via BIG-IQ.

### Network Builder

A Network Builder class is used to configure BIG-IP with all of the
necessary networking for a service definition.

### LBaaS Builder

The LBaaS Builder is responsible for creating the high level iApp or
objects for the service, such as the pool, pool members, vip, and
monitors.

There are a few methods for doing this: deploying an iApp via BIG-IQ,
deploying an iApp directly to BIG-IP, or creating objects directly on
BIG-IP.

### Configuration Managers

The managers convert LBaaS service definitions and identifiers to F5
configuration. The tenant, l2, selfip, snat, pool, and vip managers all
handle converting from the LBaaS service definition to the appropriate
objects.

The vCMP manager talks to the vCMP host to assign VLANs to a guest.

### BIG-IP Interfaces

These are low level interfaces that should not have any LBaaS semantics.

### Plug-in Code

The F5 LBaaS Plug-in Driver runs in the Neutron process and has access
to all the methods and data that Neutron uses.

One of the major components of the driver is the F5PluginDriver class.
This is the class that is referenced in the Neutron server configuration
file as the class to load for the F5 LBaaS “provider” and this is the
class that receives the method calls for the LBaaS service. This class
is derived from a Neutron class named LoadBalancerAbstractDriver.

There is also a class named LoadBalancerAgentApi which is just an
interface for making RPC calls to agents. When the driver has one of its
methods called from Neutron, it will do appropriate preprocessing,
select an agent, and then hand off the call from Neutron to the
appropriate Agent.

There is also a class called LoadBalancerCallbacks that handles requests
from the agent.

Finally, there is a class named TenantScheduler which has one method
which is used to assign an agent to handle an operation on a load
balancing pool.

###Agent Code

The agent is structured quite a bit differently than the plug-in driver.
The agent runs as a standalone process while the plug-in driver runs
within the Neutron server.

Since the agent is a standalone process, it has its own startup,
configuration, and logging files. The execution script is
/usr/bin/f5-bigip-lbaas-agent which is just a short python program which
imports the agent and runs the main function. The real startup script is
in the /etc/init directory and it passes all the appropriate command
line options that specify the config file and logging file.

The main agent process entry point is in agent.py. The main program
creates an instance of LbaasAgentManager (from the agent\_manager
module), which in turn creates and instance of the agent driver, which
is by default, the iControlDriver class in the icontrol\_driver module.

## RPC

### Overview

The LBaaS Driver and Agents communicate using RPC classes that are part
of the Neutron server.

### RPC Queues

#### Driver to Agent Methods

The driver calls into the agent for these purposes:

-   To process all LBaaS methods

#### Agent to Driver Methods

The agent calls into the driver for these purposes:

-   To update the status of LBaaS objects

-   To allocate a port on a Neutron network

-   To make query back into Neutron via the driver

##F5 LBaaS Service Definition


Requests come in to agent as full service definitions, not incremental
changes.

The driver looks up networks, mac entries, segmentation info, etc and
places all information in a service object (which is a python dictionary
variable) and passes that to the agent.

The following is a simplified version of a service definition.

{% raw %}

```
service = {'pool': {'id': 'pool\_id\_1',

'status': plugin\_const.PENDING\_CREATE,

'tenant\_id': '45d34b03a8f24465a5ad613436deb773'},

'members': \[{'id': 'member\_id\_1',

'status': plugin\_const.PENDING\_CREATE,

'address': '10.10.1.2',

'network': {'id': 'net\_id\_1', 'shared': False},

'protocol\_port': "80"},

{'id': 'member\_id\_2',

'status': plugin\_const.PENDING\_CREATE,

'address': '10.10.1.4',

'network': {'id': 'net\_id\_1', 'shared': False},

'protocol\_port': "80"}\],

'vip': {'id': 'vip\_id\_1',

'status': plugin\_const.PENDING\_CREATE,

'address': '10.20.1.99',

'network': {'id': 'net\_id\_1', 'shared': False}}}
```

{% endraw %}

###Agent Request Serialization

In order to avoid conflicting requests being handled simultaneously on
BIG-IP, all requests are processed in a serialized fashion. This is
implemented with a decorator on all of the functions that need to be
serialized together. The decorator is unsurprisingly named “serialized”.

##Major Deployment Variations

###Hardware or Virtual BIG-IP

The agent operates exactly the same whether or not the BIG-IP device is
virtual or physical hardware. There is some special handling for vCMP,
which is only supported by hardware, but other than that, the API calls
are the same. The vCMP differences are explain in the next section.

###VCMP

vCMP is an F5 technology that allows the customer to create several
independent BIG-IP instances from a single BIG-IP device. These
“virtual” instances are almost exactly like full BIG-IPs. There is a
vCMP “host” that managers the vCMP “guests” that have been created.

The F5 LBaaS agent supports vCMP. The credentials for the host and guest
must be provided. The LBaaS agent uses the host credentials to create
VLANs and assign them to guests. That is the only operational difference
in how the agent configures vCMP BIG-IP instances.

##BIG-IQ

The agent driver includes configuration variable that allow it to work
with BIG-IQ. If these variables are present, then the BIG-IQ is
utilized, otherwise the agent driver falls back to using the BIG-IP
cluster in the agent configuration file.

###HA Type

The following HA types are supported:

#### Pair

Pair is an active / standby HA configuration. One device does not
process traffic.

#### ScaleN

ScaleN is an active / active HA configuration. The agent uses all
available floating traffic groups. The agent currently assigns all
traffic for a given tenant to one traffic group. This may be related to
the fact that all virtuals within a tenant share the same SNAT pool.

#### Standalone

Standalone is a single BIG-IP with no HA functionality. This mode might
work for non-production or as part as a geographically distributed HA
solution using DNS as the load balancing method.

####Sync Mode

The agent driver supports two different sync modes: replication and
autosync.

If the agent driver sync mode is “replication” mode then the driver
configures each BIG-IP independently from the others. In replication
mode, the driver turns off BIG-IP autosync.

####Global Routed

When global routed mode is enabled, the driver skips all L2 and L3
provisioning and only deploys the LBaaS related objects. No SNAT objects
are created.

###Traffic Return Method
####SNAT

### Gateway

This diagram is not entirely accurate. If the plug-in is configured for
gateway mode, the Neutron router would not exist and the BIG-IP would be
the default route in that case.

##BIG-IP Configuration Strategy
###Overview

The following diagram illustrates the relationship of various LBaaS
configuration objects on the BIG-IP in a multi-tenant configuration.

###Tenancy

A BIG-IP partition is created for each tenant with a name using this
syntax:

/&lt;prefix&gt;&lt;tenant\_id&gt;

The partition is created when the first pool for the tenant is created.

The partition is removed when the last pool is removed for a tenant.

###L2 Configuration

#### Network Types

The plug-in supports configuring networks with these types:

-   vlan

-   gre

-   vxlan

The plug-in also supports pre-existing networks of unspecified type via
predeclared “common” networks, which are explained later in this
chapter. These can be used for locally connected networks for either
physical or virtual BIG-IPs.

#### Naming Conventions

The default prefix is “uuid” and it is always used in combination with
an underscore like so: “uuid\_”.

If a folder or iApp is not prefixed with the prefix that the agent is
configured for, then the agent “ignores” those folders. That means it
doesn’t delete those folders when it attempts to clean up leftover
objects.

#### Predeclared Common Networks

The plug-in supports pre-declaring networks that have already been
provisioned on BIG-IP. Sometimes you have existing configuration on
BIG-IP with existing VLAN names. If you do not declare that these
networks are already present (and the name of the VLAN on BIG-IP that
they correspond to) then the agent driver will attempt to create and
delete the VLAN (or tunnel), as well as IP addresses associated with the
network, whenever it provisions a service using that network. If the
VLAN is already present, this operation will fail because the subnet is
already in use on another vlan. So, the configuration file has a setting
that allows you to basically say, “network 3242-2423-353543534-4353534”
in OpenStack is VLAN “external” on BIG-IP. It is assumed that
pre-declared VLANs exist in the “Common” partition.

#### Enable Common External Networks

This configuration variable, if enabled, causes all networks with the
router:external key set to True to be considered predeclared /Common
networks.

### SDN Integration Strategy

#### SDN Background

In order to understand the status of OpenStack networking and F5
integration with it, it may be helpful to review the technical issues in
detail in order to provide some context for the recent developments in
this space.

The main requirement of the cloud networking system is to provide an
isolated networking environment for tenant networks and to provide
access to outside networks via NAT and L2 Gateway facilities. Different
tenants can use the same IP ranges, for example because each tenant will
use their own isolated set of routers. Within OpenStack the job of
implementing the networking falls to a component name Neutron. Neutron
uses a plug-in mechanism to allow for different solutions to implement
the layer 2 networking and layer 3 routing (and many other services).
The L2 implementation is responsible for actually moving the Ethernet
packets from virtual machines to other virtual machines or external
networks. The destination virtual machine may be running on a different
host server (which I’ll refer to as a compute host) in which case the
packets will need to be sent to the other compute host using the IP
address of the host. This where a variety of new solutions are being
implemented . A common solution in this space is to use Open vSwitch to
move packets around as defined by OpenFlow rules, which specify how to
manipulate packets and direct them into VXLAN or NVGRE tunnels or
traditional VLANs. A number of major commercial and open source
offerings involve this type of solution including the reference
out-of-the-box OpenStack solution (OVS) and OpenDayLight.

#### SDN L2 to L3 Table

When the VXLAN or NVGRE protocols are used, the VM Ethernet packets are
encapsulated in an IP based protocol (UDP and GRE respectively) and so
the IP address of the remote compute host that is running the
destination VM must be known. This information is typically kept in a
table. This table is basically a mapping from a &lt;Network ID + MAC
Address&gt; to an IP address. To allow the solution to scale, the
compute host should only contain the network mappings relevant to the
VMs it is running. There are a variety of solutions that have been used
to keep this table on each compute host up-to-date.

#### SDN Control Planes

The job of keeping the networking mapping table up-to-date and for
responding to certain operations, such as creating a network or network
port, is implemented by the control plane of the networking
implementation. The reference OpenStack control plane is implemented by
python code sending messages typically over a RabbitMQ or ZeroMQ message
bus. The OpenDayLight control plane uses OVSDB and OpenFlow. The
Midokura control plane is implemented with Zookeeper.

### ML2 VTEP Strategy

F5 has integrated with the ML2/OVS plug-in that allows us to leverage
our BIG-IP hardware to provide a multi-tenant solution (using partitions
and route domains) for load balancing. That solution also works with
Virtual Edition, allowing it to be a multi-tenant Service VM in
OpenStack. We have implemented a solution where the BIG-IP can terminate
VXLAN or NVGRE tunnels into tenant networks and participates in the
reference OVS message bus in order to create or own &lt;Network +
MAC&gt; to IP mappings. These are created as forwarding database (fdb)
entries on BIG-IP.

#### External L2/L3 Gateway

As I mentioned in the discussion about integration with L2 networking
control planes, there is another strategy that allows hardware and
service VMs to achieve L2 connectivity to the tenant VMs via another
approach that does not require integrating with the tunneling and
control plane protocols. Broadly, this can be called the L2 Gateway
strategy. This strategy allows a service orchestrator, such as the F5
LBaaS plug-in, to request via a north bound interface of the cloud
management system (OpenStack) or the SDN controller (Nuage /
OpenDaylight) that the tenant network be mapped to something that the
BIG-IP can handle, which is almost always a VLAN. The SDN controller
would be required to provide the L2 gateway. (F5 may also implement the
L2 gateway feature itself, which is a little more of a complicated
scenario, but is conceptually the same solution).

In the case of OpenStack, the L2 gateway features have not shipped yet
and even the basic design is still under debate. The downside to the L2
gateway approach is that this will typically only support 4095 or so
tenant networks, as limited by the VLAN range and it requires some
solving significant issues with respect to how the VLANs are
provisioned. Specifically, it is not clear who controls the VLAN pool
and how are they kept separate from other VLANs in the enterprise and
where the mapping is stored. That said, it does provide a viable
solution (with the caveats mentioned). The nice thing about integrating
with VLANs is that they do not have a control plane. We can simply send
and receive Ethernet packets out of our hardware, like we normally do,
and it just works.

##### Q an Q Evolution?

There is an evolution to the L2 gateway approach that solves the 4096
VLAN limit while also avoiding costly and complicated control plane
integrations. I know there may be some discomfort with the idea, but the
natural solution is Q in Q. F5 introduced Q in Q support in v11.6 and
now BIG-IP could conceivably support 24 Million tenant networks
(ignoring capacity issues and yes I know capacity is equally limiting in
practice) using the Q in Q feature, assuming the L2 gateway also
supports that type of mapping (and none do at this point as far as I
know.)

##### Port Specific VLANs

There is actually a middle ground using “port specific” VLANs, as Nuage
calls them. This would allow supporting (4095 \* Number of Interfaces)
VLANs. In other words, if you dedicate ten physical interfaces to the
task, you could support 40,000 tenant networks. The key to this approach
is to define a mapping that includes the physical port, such that VLAN
999 on interface 1.3 is actually a different VLAN than VLAN 999 on
interface 1.4. Both BIG-IP and Nuage both support this concept. (BIG-IP
would support this using single tagged Q in Q VLANs).

Using VLANs and port-specific VLANs we can get to tens of thousands of
networks using only traditional single tagged VLANs on the wire. If that
is not enough, double tagged VLANs on the wire is the next step up.

##### L2 Gateway Network Mapping

There is no currently working solution with an L2 Gateway, but the basic
idea is to implement a layer early in the service handling process which
maps the virtual tenant network (perhaps a VXLAN) to the external
network (perhaps a VLAN) and calls to a SDN controller to establish the
mapping. Then it changes the service definition to use the appropriate
VLANs instead of VXLANs (in that situation).

##### L2 Gateway Sequence Diagram

##### OVSDB HW VTEP Strategy

While the ML2 control plane uses RPC messages, Nuage, OpenDayLight, and
NSX all use a protocol called OVSDB for their control plane. There are
two schemas, by the way, that the OVSDB protocol commonly uses. The
first one is called Open vSwitch schema and it allows a remote
controller to setup the networking for a compute node using Open
vSwitch. This protocol allows for doing things like creating instances
of a virtual switch that can be used by VMs on that compute host to talk
to each other. Also, OpenFlow rules can be programmed using that data
model. The Hardware VTEP schema, in contrast, is much simpler and
intended for a completely different purpose: to program a device with
can act as a tunnel endpoint on the network and can host MAC addresses,
and that’s it. When I say “host MAC addresses” it just means that the
tunnel endpoint can receive and send packets for those MAC addresses,
whether by being a gateway to a VLAN that has machines with those MAC
addresses or by advertising its own MAC addresses in order to implement
a load balancing VIP, for example. The controller can program this
device in order to tell it where the relevant VMs are on the network (in
terms of the familiar Network+MAC to IP mappings).

When an OVSDB-based SDN controller is being used for setting up BIG-IP
as an OVSDB HW VTEP L2 gateway, then the tunnel will be created first by
the plug-in and then the OVSDB communication will be setup with the
controller. The controller will update OVSDB entries and the BIG-IP
vxland daemon will respond by updating L2-to-L3 entries for the tunnel.

##### OVSDB HW VTEP Sequence Diagram

#### Distributed Routing Support

When BIG-IP is used as a HW VTEP, it may be called on to interface in a
special way with a virtual machine distributed router. Consider the
scenario where the BIG-IP receives packets (destined to one of its VIPs)
from a VM network that it is not directly connected to. Typically BIG-IP
would return those packets to a default route, but in the case of a
distributed router, there is no designated router available to route for
BIG-IP because it is not a VM and nothing is in the packet path to
receive the BIG-IP packets.

In some scenarios, the VIP is considered “off network” from the VMs and
so the distributed router places these packets in a special tunnel that
goes to a designated “external gateway” tunnel endpoint. When acting as
one of these gateways, BIG-IP can return packets if it is directly
connected to the virtual network. It can have multiple gateway tunnels
in multiple route domains in order to identify the particular IP network
interface.

If not directly connected, perhaps the BIG-IP could source packets with
the gateway MAC (requiring it to be fully L3+L2 aware of the entire
virtual network) or provision a network and IP+SNAT address directly on
the fly.

With Neutron, even if there is a distributed router, there is typically
a designated external gateway behind a designated tunnel endpoint that
can still route packets.

###Self IPs

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/Common)(tmos)\# list net self

**net self
uuid\_local-host-10-10-0-2.openstacklocal-552dea3a-965f-4a97-bae1-1f18f87cb54d
{**

**address 10.60.0.5/24**

**traffic-group traffic-group-local-only**

**vlan uuid\_tunnel-gre-14**

**}**

net self selfip.external {

address 10.20.0.2/24

allow-service {

default

}

description "Self IP address for BIG-IP External (VIP) subnet"

traffic-group traffic-group-local-only

vlan vlan.external

}

net self selfip.datanet {

address 10.30.30.200/24

allow-service {

default

}

description "auto-added by openstack-init"

traffic-group traffic-group-local-only

vlan vlan.datanet

}

net self selfip.ha {

address 10.40.0.2/24

allow-service {

default

}

description "Self IP address for HA subnet"

traffic-group traffic-group-local-only

vlan vlan.ha

}

net self selfip.mirroring {

address 10.50.0.2/24

allow-service {

default

}

description "auto-added by openstack-init"

traffic-group traffic-group-local-only

vlan vlan.mirroring

}

net self selfip.internal {

address 10.30.0.2/24

allow-service {

default

}

description "Self IP address for BIG-IP Internal (Pool) subnet"

traffic-group traffic-group-local-only

vlan vlan.internal

}

This shows self IP addresses in the tenant partition:

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/Common)(tmos)\# cd
/uuid\_4ae5e0e06dbb49eead35a66792e1023e/

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\# list
net self

**net self
uuid\_local-host-10-10-0-2.openstacklocal-d1cee7c4-da59-49b1-94fe-99ca796a909b
{**

**address 10.20.1.4%2/24**

**partition uuid\_4ae5e0e06dbb49eead35a66792e1023e**

**traffic-group /Common/traffic-group-local-only**

**vlan uuid\_tunnel-gre-16**

**}**

**net self
uuid\_local-host-10-10-0-2.openstacklocal-77a9f215-832f-477a-9a3d-9560034de268
{**

**address 10.10.1.5%2/24**

**partition uuid\_4ae5e0e06dbb49eead35a66792e1023e**

**traffic-group /Common/traffic-group-local-only**

**vlan uuid\_tunnel-gre-15**

**}**

#SNATs

The SNAT pool for a tenant is shared by all vips.

SNAT address name:

&lt;prefix&gt;\_snat-&lt;traffic-group&gt;&lt;neutron subnet id&gt;

Unfortunately, there is no delimiter between traffic group and neutron
subnet id. There probably should be.

SNAT pool:

&lt;prefix&gt;\_&lt;tenant id&gt;

ltm snat-translation
uuid\_snat-traffic-group-1d1cee7c4-da59-49b1-94fe-99ca796a909b\_0 {

address 10.20.1.5%2

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

traffic-group /Common/traffic-group-1

}

ltm snat-translation
uuid\_snat-traffic-group-177a9f215-832f-477a-9a3d-9560034de268\_0 {

address 10.10.1.6%2

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

traffic-group /Common/traffic-group-1

}

ltm snatpool uuid\_4ae5e0e06dbb49eead35a66792e1023e {

members {

/Common/uuid\_snat-traffic-group-1552dea3a-965f-4a97-bae1-1f18f87cb54d\_0

uuid\_snat-traffic-group-177a9f215-832f-477a-9a3d-9560034de268\_0

uuid\_snat-traffic-group-1d1cee7c4-da59-49b1-94fe-99ca796a909b\_0

}

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

}

\
<span id="_Toc288678398" class="anchor"><span id="_Toc416167919" class="anchor"></span></span>iApps and Objects
---------------------------------------------------------------------------------------------------------------

### <span id="_Toc288678399" class="anchor"><span id="_Toc416167920" class="anchor"></span></span>Overview

### iApp Folder

#### Naming Convention

/&lt;partition&gt;/&lt;prefix&gt;\_&lt;neutron lb-pool id&gt;.app/

#### Example

(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\# list sys folder

sys folder uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app {

app-service
/uuid\_4ae5e0e06dbb49eead35a66792e1023e/uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app/uuid\_48dfaed4-2502-4169-8191-85cc8a114308

device-group /Common/openstack.bigip.cluster

inherited-devicegroup true

inherited-traffic-group true

traffic-group /Common/traffic-group-1

}

### \
iApp Folder Contents

(/uuid\_4ae5e0e06dbb49eead35a66792e1023e/uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app)(tmos)\#
**list sys application**

sys application service uuid\_48dfaed4-2502-4169-8191-85cc8a114308 { … }

(/uuid\_4ae5e0e06dbb49eead35a66792e1023e/uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app)(tmos)\#
**list ltm**

ltm default-node-monitor {

rule none

}

ltm dns analytics global-settings { }

ltm dns cache global-settings { }

ltm global-settings connection { }

ltm global-settings general {

share-single-mac vmw-compat

}

ltm global-settings traffic-control { }

ltm monitor http uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_http {

&lt;contents snipped&gt;

}

ltm persistence global-settings { }

ltm pool uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_pool {

&lt;contents snipped&gt;

}

ltm profile http uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_http {

&lt;contents snipped&gt;

}

ltm virtual uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_vip {

&lt;contents snipped&gt;

}

### \
iApp Service

#### Naming Convention

&lt;prefix&gt;\_&lt;neutron lb-pool id&gt;

#### Example

root@(host-10-10-0-2)
(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e/uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app)(tmos)\#
list sys application service

sys application service uuid\_48dfaed4-2502-4169-8191-85cc8a114308 {

device-group /Common/openstack.bigip.cluster

inherited-devicegroup true

inherited-traffic-group true

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

tables {

pool\_\_members {

column-names { addr connection\_limit port state }

rows {

{ row { 10.10.1.2%2 10000 80 enabled } }

{ row { 10.60.0.2%0 10000 80 enabled } }

}

}

}

template /Common/f5.lbaas

traffic-group /Common/traffic-group-1

variables {

app\_stats { value enabled }

pool\_\_lb\_method { value round-robin }

pool\_\_monitor { value http }

pool\_\_port { value 80 }

vip\_\_addr { value 10.20.1.2%2 }

vip\_\_port { value 80 }

vip\_\_protocol { value http }

vip\_\_state { value enabled }

}

}

### \
Pool

#### Naming Convention

uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_pool

#### Example

### <span id="_Toc288678401" class="anchor"><span id="_Toc416167931" class="anchor"></span></span>VIP

#### Naming Convention

uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_vip

#### Example

### <span id="_Toc288678402" class="anchor"><span id="_Toc416167934" class="anchor"></span></span>VIP profile

ltm profile http uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_http {

app-service
/uuid\_4ae5e0e06dbb49eead35a66792e1023e/uuid\_48dfaed4-2502-4169-8191-85cc8a114308.app/uuid\_48dfaed4-2502-4169-8191-85cc8a114308

}

### <span id="_Toc288678403" class="anchor"><span id="_Toc416167935" class="anchor"></span></span>Monitor

ltm monitor http uuid\_48dfaed4-2502-4169-8191-85cc8a114308\_http

<span id="_Toc414602465" class="anchor"><span id="_Toc288678404" class="anchor"><span id="_Toc414602464" class="anchor"></span></span></span>\
Node and Virtual addresses
----------------------------------------------------------------------------------------------------------------------------------------------

Node addresses and virtual-addresses are created automatically for pool
members and virtual servers. They represent the IP-level identify of the
pool member and virtual-service.

Pool member are identified by address and port. All pool members with
the same address implicitly refer to the same “node-address”. The
node-address can be used, for example, to set a connection limit on the
node (the server) as a whole rather than for a specific address/port
used by pool members.

Node addresses and virtual addresses are created in the “root” of the
partition. In other words, they are in the tenant partition, but they
are not

root@(host-10-10-0-2)(cfg-sync Changes Pending)(Standby)(/)(tmos)\# cd
uuid\_4ae5e0e06dbb49eead35a66792e1023e/

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\#
**list ltm node**

ltm node 10.10.1.2%2 {

address 10.10.1.2%2

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

}

ltm node 10.60.0.2%0 {

address 10.60.0.2

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

}

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\#
**list ltm virtual-address**

ltm virtual-address 10.20.1.2%2 {

address 10.20.1.2%2

mask 255.255.255.255

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

traffic-group /Common/traffic-group-1

}

Node addresses are apparently not be cleaned up when an iApp is deleted,
so they have to be deleted by the plug-in after the iApp is deleted.

ISSUE: Node addresses for route-domain %0 addresses also show up in a
tenant partition. Is that OK? Can another tenant create the same exact
node in a different partition?

\
<span id="_Toc288678405" class="anchor"><span id="_Toc416167937" class="anchor"></span></span>Static ARP Entries
----------------------------------------------------------------------------------------------------------------

IP addresses for shared networks have ARP entries in the /Common
partition.

root@(host-10-10-0-2)(Standby)(/Common)(tmos)\# list net arp

net arp /Common/10.60.0.2 {

ip-address 10.60.0.2

mac-address fa:16:3e:6a:7d:a9

}

IP addresses for tenant networks have ARP entries in the tenant
partition:

root@(host-10-10-0-2)(Standby)(/Common)(tmos)\# cd
/uuid\_4ae5e0e06dbb49eead35a66792e1023e/

root@(host-10-10-0-2)(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\#
list net arp

net arp /uuid\_4ae5e0e06dbb49eead35a66792e1023e/10.10.1.2%2 {

ip-address 10.10.1.2%2

mac-address fa:16:3e:53:42:dc

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

}

FDB Entries
-----------

IP addresses for shared networks have fdb entries in the /Common
partition.

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/Common)(tmos)\# list net fdb

net fdb tunnel http-tunnel { }

net fdb tunnel socks-tunnel { }

net fdb tunnel uuid\_tunnel-gre-14 {

records {

fa:16:3e:6a:7d:a9 {

endpoint 10.30.30.2

}

}

}

net fdb vlan vlan.datanet { }

net fdb vlan vlan.external { }

net fdb vlan vlan.ha { }

net fdb vlan vlan.internal { }

net fdb vlan vlan.mirroring { }

IP addresses for tenant networks have fdb entries in the tenant
partition:

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/Common)(tmos)\# cd
/uuid\_4ae5e0e06dbb49eead35a66792e1023e/

root@(host-10-10-0-2)(cfg-sync Changes
Pending)(Standby)(/uuid\_4ae5e0e06dbb49eead35a66792e1023e)(tmos)\# list
net fdb

net fdb tunnel uuid\_tunnel-gre-15 {

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

records {

fa:16:3e:53:42:dc {

endpoint 10.30.30.2

}

}

}

net fdb tunnel uuid\_tunnel-gre-16 {

partition uuid\_4ae5e0e06dbb49eead35a66792e1023e

records {

02:00:16:1e:1e:01 {

endpoint 10.30.30.1

}

}

}

\
<span id="_Toc414602466" class="anchor"><span id="_Toc288678406" class="anchor"><span id="_Toc416167939" class="anchor"></span></span></span>Major Operations
=============================================================================================================================================================

<span id="_Toc414602468" class="anchor"><span id="_Toc288678407" class="anchor"><span id="_Toc416167940" class="anchor"></span></span></span>Driver Startup
-----------------------------------------------------------------------------------------------------------------------------------------------------------

Create RPC interface to Agent.

Load the agent scheduler driver.

Install callbacks for RPC.

Wait for a service request.

<span id="_Toc414602469" class="anchor"><span id="_Toc288678408" class="anchor"><span id="_Toc416167941" class="anchor"></span></span></span>Agent Startup
----------------------------------------------------------------------------------------------------------------------------------------------------------

Process the networking configuration.

Process the hostnames.

Initialize the managers.

Connect to the BIG-IPS.

Validate HA config.

Discover traffic groups

Setup Tunneling

Prepare the Agent “Configuration” for reporting.

If the agent fails, it should be restarted automatically by the
operating system. The most common fatal failure is that the agent is
unable to connect to the BIG-IPs. In this case, the agent pauses 5
seconds before terminating, in order to avoid a restart “storm”.

\
<span id="_Toc288678409" class="anchor"><span id="_Toc416167942" class="anchor"></span></span>Agent Status Updates
------------------------------------------------------------------------------------------------------------------

The agent periodically reports its status to the neutron server. The
agent uses the default period, which is currently defined in
neutron/agent/common/config.py as 30 seconds.

The agent\_manager reports the agent state using the \_report\_state
method. It uses the following data structure to report the state:

self.agent\_state = {

'binary': 'f5-bigip-lbaas-agent',

'host': self.agent\_host,

'topic': plugin\_driver.TOPIC\_LOADBALANCER\_AGENT,

'agent\_type': neutron\_constants.AGENT\_TYPE\_LOADBALANCER,

'l2\_population': self.conf.l2\_population,

'configurations': agent\_configurations,

'start\_flag': True}

A significant amount of information is populated in the “configurations”
member. The agent\_manager populates agent\_state.configurations before
reporting with the current service count, the current service queue
size, and the agent driver configurations:

service\_count = self.cache.size

self.agent\_state\['configurations'\]\['services'\] = service\_count

if hasattr(self.lbdriver, 'service\_queue'):

self.agent\_state\['configurations'\]\['request\_queue\_depth'\] = \\

len(self.lbdriver.service\_queue)

if self.lbdriver.agent\_configurations:

self.agent\_state\['configurations'\].update(

self.lbdriver.agent\_configurations

)

The agent driver populates its configuration with the following members:

tunnel\_types

icontrol\_endpoints

bridge\_mappings

common\_networks

tunneling\_ips

environment\_prefix

This information can be displayed with the “neutron agent-show
&lt;agent-id&gt;” command. Agent ids can be obtained with the “neutron
agent-list” command.

<span id="_Toc288678410" class="anchor"><span id="_Toc416167943" class="anchor"></span></span>Request Handling
--------------------------------------------------------------------------------------------------------------

### <span id="_Toc288678411" class="anchor"><span id="_Toc416167944" class="anchor"></span></span>Request Initiation

Command line, GUI, or API is used. Command line and GUI are converted to
API calls.

The API call is made to the Neutron Server.

### <span id="_Toc288678412" class="anchor"><span id="_Toc416167945" class="anchor"></span></span>Plug-In Request Handling

After the request has been validated and authorized by Neutron, the F5
plug-in receives a python method call from the Neutron server for the
LBaaS operation. All LBaaS requests are related to a particular pool.
The plug-in determines which agent “owns” the pool related to the
request. If this is a new pool, the plug-in selects an agent using a
pool-to-agent “scheduler”. The scheduler records the selected agent for
the pool in the Neutron database.

While the most folks use the word “scheduler” to describe something that
sequences events across time, the OpenStack community is using it to
describe something that “assigns a workload”. So, a VM “scheduler” might
choose which compute host a VM should run on. An LBaaS agent scheduler
chooses which LBaaS agent to service a particular request.

Typically the plug-in builds a service definition for the request and
then calls into the agent RPC interface. Some requests are handled in a
special manner, however. Those details are provided in the following
sections.

#### <span id="_Toc288678413" class="anchor"><span id="_Toc416167946" class="anchor"></span></span>Create Pool

Since this is a new pool, an agent is selected.

#### <span id="_Toc288678414" class="anchor"><span id="_Toc416167947" class="anchor"></span></span>Create Member

If this is a duplicate member then the plug-in sets the member status to
error, and continues processing. Frankly, it may not make sense for it
to continue processing but it does.

#### \
<span id="_Toc288678415" class="anchor"><span id="_Toc416167948" class="anchor"></span></span>Create VIP

When the plug-in receives a request to create a vip, the vip will
already have a port assigned to it. All IP addresses in Neutron are
associated with a port on a subnet. The notion of a port in Neutron is
rather “flexible”. A port does not necessarily represent a port on a
switch. It is simply the data structure in Neutron that “connects” a
subnet with an IP address, and (optionally) a device that “owns” that IP
address. The interesting flexibility within Neutron is that the “device”
that connects to the port does not necessarily have to be a Virtual
Machine, although it commonly is. The “device” can be pretty much
anything (or just left blank). This makes sense because Neutron has a
number of “devices” such as the Neutron router, DHCP agent, and the HA
Proxy load balancer, none of which are typically implemented as virtual
machines.

The plug-in updates the VIP port to say that the LBaaS agent is the
device that owns the port. Then the plug-in proceeds with the usual
processing.

### \
<span id="_Toc288678416" class="anchor"><span id="_Toc416167949" class="anchor"></span></span>Agent Request Handling

#### <span id="_Toc288678417" class="anchor"><span id="_Toc416167950" class="anchor"></span></span>Overview

The agent manager receives the LBaaS RPC calls from the plug-in and
calls into the driver to process the method.

<span id="_Toc371078180" class="anchor"></span>The service request
handler methods all call into \_common\_service\_handler.

Determine whether big-iq can be used

Ensure tenant partition exists if necessary

Ensure networking is provisioned if necessary. This is explained in
further detail later.

If BIG-IQ possible, proceed to BIG-IQ iApp deployment, otherwise
configure directly.

Depending on configuration, proceed to configuring directly using iApp
(template) APIs, which is explained by the topic named “BIG-IP iApp
Deployment”, or using object (non-template) APIs, which is explained by
the following section named “BIG-IP Object Deployment”.

After service configuration, networking cleanup is done if necessary.

Tenant cleanup is done if necessary.

OpenStack LBaaS object statuses are updated via RPC back to Neutron.

#### <span id="_Toc288678418" class="anchor"><span id="_Toc416167951" class="anchor"></span></span>Determining whether BIG-IQ can be used

The BIG-IQ configuration must be present and correct. The OpenStack
credentials must be present and correct. The tenant must have a BIG-IP
running in their project.

#### <span id="_Toc288678419" class="anchor"><span id="_Toc416167952" class="anchor"></span></span>Networking Setup

The agent driver uses a “NetworkBuilderDirect” class to configure BIG-IP
so it can connect to OpenStack networks. The entry point into this class
that is used to ensure network connectivity with a service definition is
named “prep\_service\_networking”.

Currently, the driver does not deploy the iApp until a VIP is defined,
and so the driver does not do any networking configuration either if the
vip is not define. This should be resolved in the Green Flash release.

For every BIG-IP, a VLAN or tunnel, and an IP address is configured for
every subnet that the BIG-IPs need to be connected to. Each BIG-IP gets
a unique IP address so that it can independently communicate with pool
members in order to perform service checking. Additional floating IP
(SNAT) addresses are used when the BIG-IP is load balancing connections
that flow through the vip.

#### <span id="_Toc288678420" class="anchor"><span id="_Toc416167953" class="anchor"></span></span>BIG-IQ iApp Deployment

Create Connector

Discover Devices

Deploy iApp

Allowed Address Pairs

#### <span id="_Toc288678421" class="anchor"><span id="_Toc416167954" class="anchor"></span></span>BIG-IP iApp Deployment

Deploys iApp

#### <span id="_Toc288678422" class="anchor"><span id="_Toc416167955" class="anchor"></span></span>iApp Design

This section describes how the iApp, which resides on BIG-IP, works.
First, this is a traditional Tcl based iApp

#### \
<span id="_Toc288678423" class="anchor"><span id="_Toc416167956" class="anchor"></span></span>BIG-IP Object Deployment

This section describes the process for creating LBaaS objects on BIG-IP
directly from the plug-in (instead of using BIG-IQ) and by using
individual REST APIs to create objects rather than using iApp templates.

#### <span id="_Toc288678424" class="anchor"><span id="_Toc416167957" class="anchor"></span></span>Networking Cleanup

If any pool members or vip deleted the driver checks to see if any other
members or vips are on the network

\
<span id="_Toc414602471" class="anchor"><span id="_Toc288678425" class="anchor"><span id="_Toc416167958" class="anchor"></span></span></span>Periodic Sync
----------------------------------------------------------------------------------------------------------------------------------------------------------

The Agent periodically ensures that all services in OpenStack are
configured properly.

<span id="_Toc414602472" class="anchor"><span id="_Toc288678426" class="anchor"><span id="_Toc416167959" class="anchor"></span></span></span>Periodic Save
----------------------------------------------------------------------------------------------------------------------------------------------------------

The Agent periodically saves the configuration. Saving is serialized
along with other methods.

<span id="_Toc414602473" class="anchor"><span id="_Toc288678427" class="anchor"><span id="_Toc416167960" class="anchor"></span></span></span>Periodic Purge
-----------------------------------------------------------------------------------------------------------------------------------------------------------

Pools on BIG-IP that appear to be managed\* by the current agent but do
not correspond to a known service within OpenStack are removed
automatically.

\*See the Agent Prefix topic for additional information.

<span id="_Toc414602474" class="anchor"><span id="_Toc288678428" class="anchor"><span id="_Toc416167961" class="anchor"></span></span></span>Tunneling Control Plane Integration
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Tunnel Sync

The agent periodically reports its tunnel end points.

### <span id="_Toc414602475" class="anchor"><span id="_Toc288678429" class="anchor"><span id="_Toc416167963" class="anchor"></span></span></span>FDB Handling

The agent periodically updates tunneling MAC-to-VTEP records.

### <span id="_Toc414602476" class="anchor"><span id="_Toc288678430" class="anchor"><span id="_Toc416167964" class="anchor"></span></span></span>L2 Population Handling

When l2 tunnel created or deleted, l2.assure\_bigip\_network\_vxlan and
l2.assure\_bigip\_network\_gre use the fdb\_connector class to call l2
population rpcs which advertise flooding records for the tunnels, which
the local tunnel ip address of the bigip as the endpoint.

\
<span id="_Toc414602477" class="anchor"><span id="_Toc288678431" class="anchor"><span id="_Toc416167965" class="anchor"></span></span></span>Failure Recovery
=============================================================================================================================================================

<span id="_Toc288678432" class="anchor"><span id="_Toc416167966" class="anchor"></span></span>Agent Failure
-----------------------------------------------------------------------------------------------------------

If the agent stops working for whatever reason, restarting it is the
first procedure to try and will usually will resolve the problem.

<span id="_Toc288678433" class="anchor"><span id="_Toc416167967" class="anchor"></span></span>Intermittent API Failure
----------------------------------------------------------------------------------------------------------------------

Any intermittent problems with APIs and so forth will usually throw an
exception that will fail the entire request. There is very little retry
handling in the lower level code. Therefore, recovery is done at a
higher level. The method that is used to “repair” a service that was not
configured properly is to periodically sync services with BIG-IP. So,
even if the configuration failed, later the sync process will attempt to
resync the service definition to the device. At that point the
configuration should be completed. This process may take several minutes
because the sync process does not run very often.

<span id="_Toc288678434" class="anchor"><span id="_Toc416167968" class="anchor"></span></span>BIG-IQ Failure
------------------------------------------------------------------------------------------------------------

Discuss BIG-IQ HA strategy here.

<span id="_Toc288678435" class="anchor"><span id="_Toc416167969" class="anchor"></span></span>BIG-IP Failure Handling
---------------------------------------------------------------------------------------------------------------------

An exception handler needs to be added to every big-ip loop so failure
of one big-ip doesn’t affect population of the others.

Currently syncs will probably fail with long delays.

<span id="_Toc288678436" class="anchor"><span id="_Toc416167970" class="anchor"></span></span>BIG-IP Failure Recovery
---------------------------------------------------------------------------------------------------------------------

### Replication Mode

When a BIG-IP comes back online, it should recovery missing services as
it sees them.

### Auto Sync Mode

When a BIG-IP comes back online, its per-device configuration needs to
be established before a sync can succeed. But the current autosync
sync\_mode strategy will probably fail after the first sync fails for
the first service. The configuration may need to be put into replication
mode to recover. This is an open issue.
