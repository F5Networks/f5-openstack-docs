---
layout: docs_page
title: LBaaS Solution Overview
categories: lbaasv1, solution, openstack
resource: true
---

#F5 LBaaS Solution Overview {#f5-lbaas-solution-overview}
---------------

#Introduction {#intro}

**This document is intended for internal use by F5 employees only.** 

F5 Networks provides a plug-in for OpenStack that implements the Load Balancing as a Service v1.0 specification. This document provides an overview of the solution's basic value proposition and describes the major design points defining how the solution works. 

This guide describes F5’s OpenStack BIG-IP solution from a high level
functional point of view. It describes the value proposition, the major
components, and the major variations for deploying the solution. The
goal of the document is to help customers choose the appropriate
deployment variation that fits their requirements best.

##Key Terms {#key-terms}

**Load Balancing as a Service (LBaaS)**: pronounced *el-bass*; the provision of load balancing tools as a standalone product.

**OpenStack**: an open-source cloud computing platform [openstack.org](http://www.openstack.org). 

**Neutron**: OpenStack's networking service. [openstack.org/wiki/Neutron](https://wiki.openstack.org/wiki/Neutron)

___________________

#OpenStack Overview {#openstack-overview}

OpenStack provides infrastructure as a service (IaaS) to institutions and service providers who want to use their existing physical hardware to create large-scale cloud deployments (source: [OpenStack.org](http://www.openstack.org/projects/openstack-faq/)). 

To find out more about OpenStack, please see [About OpenStack](http://www.openstack.org/software/) or the [OpenStack documentation](http://docs.openstack.org).

##OpenStack LBaaS v1.0 {#lbaasintro}

LBaaS is one of many services available for deployment in OpenStack. Typically, an open source plug-in is provided out-of-the box for each service in an OpenStack deployment; you are free to replace the stock plug-in or to add plug-ins as needed. 

LBaaS v1.0 has somewhat limited functionality in comparison with that of BIG-IP. A tenant using LBaaS 1.0 can create a pool; add pool members; configure a monitor; set a persistence method; and add a virtual server. Additional features are planned for future releases of OpenStack. Any advanced F5 services a customer wishes to deploy need to be configured via the BIG-IQ or BIG-IP management interface.

## Service Model and Interfaces {#interfaces}

OpenStack has a standardized GUI, API, and command line interface (CLI). The configuration interfaces are identical regardless of the type of plug-in you use (stock or vendor). The standardization provides an advantage in terms of testing, documenting, training, and operating an OpenStack deployment.

### API {#api}

The OpenStack API uses [Keystone](http://docs.openstack.org/developer/keystone/api_curl_examples.html) tokens for authentication. 

The most common way to use the OpenStack API is via a [command-line client](https://wiki.openstack.org/wiki/OpenStackClients). These python-based clients are available in the standard operating system package repositories. 

    **TIP:** For [Neutron](https://wiki.openstack.org/wiki/Neutron), the download/install commands are `apt-get install python-neutronclient` or `yum install python-neutronclient` for Ubuntu and Centos/Red Hat, respectively. 

You can also send API requests via cURL, REST clients, or create automated scripts via the [OpenStack Python SDK](http://docs.openstack.org/user-guide/sdk.html).

For more information, see the OpenStack Documentation: [API for LBaaS v1.0](http://developer.openstack.org/api-ref-networking-v2-ext.html#lbaas-v1.0)

### Command Line Interface {#cli}

The Neutron CLI is available for download as part of the [Neutron client package](https://wiki.openstack.org/wiki/OpenStackClients#python-neutronclient).

The load balancing commands are a subset of the [OpenStack Neutron command set](http://docs.openstack.org/cli-reference/content/neutronclient_commands.html). Each is prefaced with “lb-“. 

**NOTE:** Commands that start with “lbaas-“ are for LBaaSv2 and are not currently supported.

### GUI {#gui}

The OpenStack GUI - also called the 'Dashboard' - allows users to access and control their OpenStack resources. For more information, see [OpenStack Dashboard](https://www.openstack.org/software/openstack-dashboard/).  

## Supported Releases {#openstack-supported-releases}

The F5 OpenStack LBaaS solution is supported on the OpenStack Icehouse,
Juno, and Kilo releases. Liberty support is planned. 

## Versions {#lbaas-version}

OpenStack LBaaS v1.0 is the only version currently supported. Please see the [roadmap](http://go/roadmap) for information regarding support for LBaaS v2.0.


#F5 Solution Overview {#f5-solution-overview}

## Introduction {#solution-intro}

The F5 OpenStack LBaaS solution will be formally supported as part of the BIG-IQ product in a future, as-yet-undetermined release.

**NOTE:** This solution has a number of major limitations, outlined in this document, which should be carefully examined and considered. and taken seriously. **There is no guarantee that the solution will work should any variation, no matter how seemingly minor, from the test implementation be made.**


## Solution Components {#solution-components}

The F5 LBaaS solution consists of the following components: 
 - Driver package: accepts the LBaaS requests from OpenStack;
 - Agent package:  the Driver uses the Agent to fan out request handling to
appropriate BIG-IPs;
 - iApp package: **must be installed on the BIG-IPs to create the necessary BIG-IP configuration objects**;
 - BIG-IQ: manages devices and deployed services.

These packages are contained in a BIG-IQ directory and must be installed on the appropriate OpenStack machines and BIG-IPs to use the F5 LBaaS solution. 

Detailed deployment instructions are available in the [F5 OpenStack Deployment Guide]().


## F5 supported platforms {#f5-platforms}

The solution supports the use of BIG-IP VEs, BIG-IP HW Appliances, or
VCMP instances, including VCMP instances for the Viprion Chassis.

There are [limitations](#bigiq-deployment) on which platforms can be used in
combination with BIG-IQ. These limitations are expected to be addressed in future BIG-IQ releases.

LineRate and Service Delivery Controller platforms are not supported.

## BIG-IP {#bigip}

BIG-IP can be used directly in an OpenStack project, or as a shared cluster. The F5 LBaaS plug-in applies the iApp configurations to any BIG-IP deployed directly within a project. If BIG-IP is not deployed within a project, the plug-in falls back to a multi-tenant, shared BIG-IP cluster.

### Deployment and Scalability {#bigip-deployment}

**The solution does not automatically deploy BIG-IPs**. The tenant must condfigure all BIG-IPs manually. Furthermore, the solution cannot monitor capacity or deploy additional BIG-IPs to handle increased traffic.

However, when the tenant has a number of BIG-IPs configured, the F5 LBaaS driver *can* scale out deployments across that BIG-IP pool. 

### MultiTenant SDN/Overlay Integration {#bigip-sdn}

The F5 LBaaS solution integrates with the OpenStack networking (SDN) implementation. This allows BIG-IP to communicate with any VM on any network in OpenStack. 

**NOTE:** This feature currently only works with the standard Neutron ML2 networking implementation with Open vSwitch. 

### BIG-IP Versions {#bigip-versions}

The F5 LBaaS plug-in can be used with any F5 hardware which supports **version 11.5.0** or higher.

**NOTE:** Depending on your configuration, an F5 Hot Fix may also be
required. 

### SR-IOV Performance {#bigip-sriov}

Single root I/O virtualization (SR-IOV) allows a virtual machine to access a network card directly, allowing for higher performance. The standard OpenStack networking environment is complex and involves multiple layers, which reduces latency and throughput. With SR-IOV, the packets bypass all of these layers and go directly to the virtual machine. 

SR-IOV is available starting in the Juno release of OpenStack and F5
recommends using SR-IOV in combination with the F5 BIG-IP Virtual
Edition in order to achieve the highest performance. The F5 TMOS
OpenStack deployment guide provides details on how to use SR-IOV.


## BIG-IQ {#bigiq}

The F5 OpenStack LBaaS solution is oriented around the F5 BIG-IQ
management product. This document describes the solution that will be
available in a future release of BIG-IQ. Unfortunately, a projected
release date is not available at this time.

BIG-IQ can be used to discover a BIG-IP in a tenant’s OpenStack project
and to deploy LBaaS iApp services to that BIG-IP when the tenant
configures LBaaS via OpenStack.

Note that it is possible to configure the solution in such a way that
the OpenStack plug-in configures BIG-IPs directly. In this scenario,
deploying BIG-IQ is technically not necessary for the solution to work.
However, we recommend using BIG-IQ for its device management (including
device licensing), rich monitoring features, and other features which
will provide for a better overall LBaaS solution. Our roadmap is heavily
oriented towards BIG-IQ and the solution design may evolve to the point
where we require the using BIG-IQ for the solution to work. For example,
the automated deployment of additional BIG-IPs for additional capacity
is expected to be available in the future only through use of the BIG-IQ
product. Therefore, even if you do not plan to use BIG-IQ initially, we
recommend planning for that in the future and for the reasons stated,
this solution is only supported by purchasing a BIG-IQ support contract.

### Deployment {#bigiq-deployment}

**When BIG-IQ is used as part of the OpenStack LBaaS solution, the
BIG-IQ can only deploy an iApp to a standalone BIG-IP Virtual Edition
dedicated to a single tenant.** That does not mean you cannot use
hardware or use BIG-IP in an HA or shared configuration. It just means
that if you choose those kinds of deployments, the BIG-IQ will not be
involved in deploying the service to the BIG-IP(s). The OpenStack
plug-in itself will need to configure the BIG-IPs when BIG-IQ is unable
to.

Keep in mind however that our best-practice, recommended solution going
forward is to use BIG-IQ for deploying all OpenStack LBaaS services. We
are focused on addressing the limitations of BIG-IQ in the near future.

It should be noted that tenant-dedicated BIG-IPs can only use pool members that are on networks that are pre-connected directly to the BIG-IP VE (in the same tenant project) or that can be reach via routing. In other words, the BIG-IP will not be able to utilize VLAN tags or tunnel interfaces to reach the
private networks of other tenants.

### Versions {bigiq-versions}

This solution requires a future version of BIG-IQ (TBD).


## System Requirements and Limitations {#requirements_limitations}

### Operating Systems {#opsys}

Testing is limited to Ubuntu 12.04 and 14.04, CentOS / RedHat 6.5 and 7.0.

Mirantis OpenStack is a short term goal. HP Helion is a goal.

### Multi-Tenancy and Alternative (non-ML2) Neutron Plug-ins {#multitenancy-nonNeutron}

If you intend to use a multi-tenant configuration model for your BIG-IPs,
then be aware that that solution only works with certain OpenStack
networking configurations. If you use tunneling (e.g. VXLAN or GRE),
BIG-IP needs to participate in the control plane for the tunneling
implementation in order to learn where the other tunnel endpoints are.

**This integration has only been done with the standard Neutron ML2
plug-in that ships by default with OpenStack.**

If the OpenStack deployment is using an alternative implementation, such
as NSX, Nuage, Contrail, PlumGrid, OpenDaylight, MidoKura, etc, then
multi-tenancy is not available at this time. F5 has integrations in
development for some of these alternatives. Please see the roadmap.

##Documentation and Online Resources

### Documentation

*F5 OpenStack LBaaS Solution Overview (This document)*


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

*F5 OpenStack LBaaS Plug-in Design Guide*

This guide describes the design and operation of the F5 LBaaS plug-in.
It covers internal components, major functional operations, and a
detailed explanation of the BIG-IP configuration strategy it uses.

#### Online Resources

<http://devcentral.f5.com/openstack>

### \
Support Policy and Early Access

Support for this solution requires a valid BIG-IQ support contract.

If the customer intends to use multitenant BIG-IPs, that aspect of the
solution will be considered Early Access until BIG-IQ supports this
scenario directly. Our supported, best-practice, recommended solution
going forward is to use BIG-IQ for deploying all OpenStack LBaaS
services. However, we realize that BIG-IQ currently has certain
limitations that could prevent BIG-IQ from deploying iApps in a
multitenant, HA scenario (such as setting the proper partition,
traffic-group, and route domain). While we are focused on addressing
those limitations in the near future, we realize that customers strongly
desire a solution they work with as soon as possible.

So, in lieu of the fully enabled BIG-IQ solution, we are implementing
the above mentioned scenarios by having the OpenStack plug-in directly
deploy iApps to BIG-IP using the REST interface. In that scenario,
BIG-IQ will not be involved in deploying the iApp. However, in parallel,
we are designing and implementing the BIG-IQ functionality that will
allow BIG-IQ to deploy those iApps in a multi-tenant, HA fashion. As we
work through this design, we are anticipating that we may evolve the
configuration scheme (such as naming conventions) as we go. Therefore,
the configurations deployed without using BIG-IQ should be considered
subject to change. There may be updates to the Early Access code and
configurations already deployed without using BIG-IQ may not migrate
forward. Migration tools may be provided at F5’s discretion, but
customers should not rely on tools being provided and they should
seriously consider this issue when planning their dev, test, and
production roll-outs.

F5 will provide updates as time goes by as to the state of the solution
and when the Early Access status will be lifted.

To address an urgent customer demand, there may be code available prior
to release, for example during Beta testing, but that will mainly depend
on the size of the customer opportunity and what resources are available
to support the customer. With sufficient money on the table, we could
probably provide a preliminary form of the solution or perhaps a demo,
in the near term. Short of that, the BIG-IQ release timeline is the one
to track for this feature.

To be clear, the Early Access status for the multitenant use case will
likely apply to the BIG-IQ release, not just preliminary software that
may have been provided prior to the release.

\
F5 BIG-IQ OpenStack Roadmap
---------------------------

These requirements are on the BIG-IQ roadmap. Generally, specific
release dates are not available for these features.

### BIG-IQ and F5 Hardware

For the current OpenStack solution, BIG-IQ can only discovers a BIG-IP
running as a VM in the OpenStack tenant’s project. We intend to support
using any kind of BIG-IP platform to support the LBaaS service.

### BIG-IQ and MultiTenant BIG-IPS

For the current OpenStack solution, BIG-IQ each tenant must have a
dedicated BIG-IP. We intend to support multi-tenant configurations using
BIG-IP Partitions and Route Domains to isolate the configuration and
network traffic, respectively.

### BIG-IQ and High Availability

We intend to support having BIG-IQ deploy an iApp to BIG-IPs configured
for high availability, not just standalone devices.

### LBaaS v1 for OpenStack Kilo

We intend to get the current LBaaS v1 plug-in working with the Kilo
OpenStack release. Note that Kilo is still under development. Our Kilo
support may not be available at the time Kilo is release - no specific
time frame has been committed.

### LBaaS v2 for OpenStack Kilo

We intend to support the LBaaS v2.0 specification. Note that full LBaaS
v2.0 support is part of the Kilo release which has not been released
yet.

### Alternative SDN Controllers

As explained previously in this document, the multitenant features
require integration with the control plane of the SDN implementation and
this integration has only been done with the standard Neutron ML2
networking implementation with Open vSwitch.

F5 intends to have integrations with various other SDN Controllers. NSX,
Nuage, Contrail, and OpenDaylight are on this list. No specific date has
been committed for these integrations to be completed. Additional
controllers may be added to this list in the future.

It should be restated that using a BIG-IP in a multi-tenant fashion
requires SDN integration. Therefore, if you intend to use an SDN
controller other than the stock Neutron ML2, you are limited to a model
where a separate BIG-IP Virtual Edition is necessary for each tenant.


