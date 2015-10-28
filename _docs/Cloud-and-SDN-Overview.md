---

---

Table of Contents {#table-of-contents .TOCHeading}
=================

[Audience 1](#audience)

[Introduction 1](#introduction)

[Understanding the Cloud 2](#understanding-the-cloud)

[Overview of Usage Scenarios 2](#overview-of-usage-scenarios)

[Public Cloud 2](#public-cloud)

[Hosted Private Cloud 2](#hosted-private-cloud)

[On-Premise Private Cloud 3](#on-premise-private-cloud)

[Hybrid Cloud 3](#hybrid-cloud)

[Multi-Cloud / Hyper Hybrid Cloud 4](#multi-cloud-hyper-hybrid-cloud)

[Abstract Cloud 4](#abstract-cloud)

[Cloud Network Services 7](#_Toc413313775)

[Introduction 7](#introduction-1)

[Types of Services 7](#types-of-services)

[Example Basic Network Services 8](#example-basic-network-services)

[Example Intermediate Network Services
9](#example-intermediate-network-services)

[Example Advanced Network Services
9](#example-advanced-network-services)

[Cloud Architecture 10](#cloud-architecture)

[Cloud Networks 10](#cloud-networks)

[Virtual / Overlay Networks 10](#virtual-overlay-networks)

[Transport Network Implementation 11](#transport-network-implementation)

[Virtual Network Implementation 12](#virtual-network-implementation)

[Layered Virtual Network Implementation 12](#_Toc413313786)

[Virtual Infrastructure Network API
12](#virtual-infrastructure-network-api)

[Virtual Infrastructure Compute API
13](#virtual-infrastructure-compute-api)

[Cloud Services API 13](#cloud-services-api)

[Service Fabrics and Service Chaining
14](#service-fabrics-and-service-chaining)

[Cloud Management Tools 17](#cloud-management-tools)

[Overview 17](#overview)

[Virtual Subnet Mgmt 17](#virtual-subnet-mgmt)

[Virtual Private Cloud Mgmt 18](#virtual-private-cloud-mgmt)

[Virtual Private Cloud Templating 20](#virtual-private-cloud-templating)

[Service Templating / Insertion 21](#service-templating-insertion)

[Provider Cloud Management 21](#provider-cloud-management)

[Hybrid and Heterogeneous Cloud Management
22](#hybrid-and-heterogeneous-cloud-management)

[Abstract cloud management 22](#abstract-cloud-management)

[Business Integration for Clouds 24](#business-integration-for-clouds)

[Technology Directions 25](#technology-directions)

[Software Defined Networks 25](#software-defined-networks)

[Introduction 25](#introduction-2)

[Use Cases 25](#use-cases)

[Vendors 25](#vendors)

[VMware NSX 25](#vmware-nsx)

[Nuage 25](#nuage)

[Juniper Contrail 25](#juniper-contrail)

[OpenDayLight 25](#opendaylight)

[PlumGrid 25](#plumgrid)

[Midokura 25](#midokura)

[Cisco 25](#cisco)

[BigSwitch 25](#bigswitch)

[Cisco 25](#cisco-1)

[Juniper 25](#juniper)

[HP 25](#hp)

[Service Stiching 26](#service-stiching)

[IP based 26](#ip-based)

[NAT on ingress and egress to SDN 26](#nat-on-ingress-and-egress-to-sdn)

[Network Function Virtualization 26](#network-function-virtualization)

[Containers 26](#containers)

Audience
========

This document was written for F5 employees working in a technical role
to help F5 customers plan their cloud deployments. While not intended
for F5 customers, some care has been taken to ensure that no important
F5 proprietary information is present in this document. So, while this
document was not written for F5 customers directly, there shouldn’t be a
problem with a customer receiving any of the information within this
document.

Introduction
============

The Cloud introduces new concepts, new limitations, new services, and
new opportunities for F5 customers. Services such as Amazon Web Services
or Rackspace Cloud and products such as VMware vCloud Director are
fundamentally changing the landscape of IT. F5 Customers are struggling
to understand the changing business and technical landscape in order to
deploy applications and network services economically and productively
in this new environment. This document attempts to provide guidance and
best-practices for customers using F5 products and services in a Cloud
environment.

The first part of this document is called *Understanding the Cloud* and
is intended to give an overview of the business and technical landscape
of the cloud. The next section is called *Deploying F5 Devices in a
Cloud* *Environment* and describes how to get an F5 device operational
in a cloud environment, which applies to both deploying and using a
BIG-IP in an existing cloud environment, and also to deploying BIG-IP as
part of a cloud infrastructure that you are building. The next two
sections provide specific information for each of the two major
deployment models: *Using a Cloud* or *Building a Cloud*.

Finally, the last two sections provide additional information to think
about beyond a basic cloud deployment. The next to the last section
describes integrated solutions that combine technology from F5 and a
third party partner of F5 as well as general information on F5
Partnerships. The last section describes the future directions of F5
technology within cloud environments.

\
Understanding the Cloud
=======================

Overview of Usage Scenarios
---------------------------

In order to make appropriate deployment decisions, it is important to
think about the model you want to use for engaging with cloud
technologies. You can build it yourself, you can purchase cloud
offerings, or you can do both. You can run the cloud deployment on your
own premises, you can run them off-premise, or you can do both. There
are a number of variations to choose from. The following sections
provide definitions for the major variations of cloud deployments.

### Public Cloud

By definition, a VM in a Public Cloud is accessible by the general
public. There is no isolated networking capability, and generally these
offerings are cheaper than Hosted Private Cloud offerings which provide
more isolation, such as IP subnets that are dedicated to a particular
tenant.

With a “basic” Public Cloud deployment such as Amazon EC2, each VM is
given its own public IP address that maps to an internal private IP
address. However, another VM that is deployed using the same tenant’s
account may be deployed to a different IP subnet. With Amazon EC2, the
tenant has very little control of IP addresses, subnets, or routing.
Also, the VM is limited to one network interface. This makes it
impossible to create an isolated network for a three-tier deployment,
for example. (Well, not really impossible – see the section on Layered
Virtual Network Implementation.)

The quintessential example of Public Cloud is Amazon EC2.

It should be noted that Amazon has a premium service called Virtual
Private Cloud that does not have the same limitations as EC2.

### Hosted Private Cloud

An off-premise cloud may be considered private if it is not accessible
to the public or from any other tenants using the same cloud provider.
Typically, a VPN is used to connect the cloud deployment back to the
enterprise.

In addition to enhanced isolation, the private cloud may provide IP
subnets managed by the tenant, and provide more routing flexibility so
that the tenant can route back to their enterprise network.

Examples of this are Amazon VPC, Rackspace Hosted Private Cloud, and
vCloud Director based Cloud Providers. Details on particular vendors are
provided in a later section.

### On-Premise Private Cloud

An on-premise private cloud is something an enterprise will build or
purchase if they want an elastic computing infrastructure (a cloud) but
they do not want to expose certain IT assets outside the enterprise.

There are products available that allow the customer to run their own
cloud in their own environment. An example is VMware vCloud Director.

### Hybrid Cloud

The Hybrid Cloud is a solution that combines a private cloud on the
enterprise premise along with a vendor hosted cloud offering.

While an enterprise may have some applications that they consider
sensitive and they may not be comfortable running in the cloud, there
may be some applications that they have no problem placing in the public
cloud because the information is less sensitive.

Some vendors have recognized this and provide on-premise versions of
their infrastructure software so that the customer can run the cloud
infrastructure in their own environment. Then, if the customer wants to
deploy some assets to the cloud provider, the management system for the
enterprise can be designed to make that transition seamless.

Examples of offerings oriented towards enterprise and vendor cloud
combinations are VMware vCloud Director and Rackspace Private Cloud.
Also, Eucalyptus is an open-source software platform that is design to
mimic Amazon’s EC2 environment. Eucalyptus is a bit different in that
Amazon is not providing the software, but has licensed the Amazon APIs
to Eucalyptus. Further details on particular vendors are provided in a
later section.

In addition to vendors offering hybrid solutions, there are some
features that a cloud vendor may provide that will allow you to sort of
build your own hybrid cloud. For example, Amazon offers an IPSEC VPN
that can be used to connect your enterprise network to your cloud
deployment. So, this could be considered “hybrid-light”. It may not be a
full hybrid management solution that allows migrating workloads, a
combined view, and so forth, but it does at least support secure
communication between enterprise and cloud.

Example Offerings: Rackspace Private Cloud (Hosted or Enterprise),
vCloud Director

Example Gateway Products: Verizon CloudSwitch, Citrix CloudBridge, F5
Cloud Connector

Example Hybrid-oriented Cloud Features: Amazon’s VPN

Details on particular vendors are provided in a later section.

### Multi-Cloud / Hyper Hybrid Cloud

The term **Hyper Hybrid** **Cloud** has been used to describe the most
sophisticated cloud deployments that include potentially multiple public
and private clouds networked together. In contrast, the simpler term
Hybrid Cloud may refer to a deployment of a combination of a single
private cloud and a single public cloud.

Despite being around for years, the Hyper Hybrid term is not being used
consistently and in a widespread fashion. The simpler term, **Hybrid
Cloud,** appears to be used sometimes to refer to more complex cloud
deployments that include multiple clouds. So, it remains to be seen
whether these terms will be used interchangeably.

Recently, Ranjeet from F5 has used the term “Multi Cloud” to refer to
the usage of multiple clouds, whether they are public or private.

### Abstract Cloud

Some vendors are providing solutions that *abstract* the cloud. A
customer of this vendor would purchase cloud capacity from the
“abstract” vendor and then the vendor turns around and deploys the VMs
to a “real” cloud vendor. So, the customer interacts with one vendor and
does not necessarily know that their VMs have been “outsourced” to some
other vendor. By purchasing capacity from a “real” vendor in advance and
in bulk, the abstract vendor may be able to resell cloud capacity at a
lower price point and still make a profit. Also, the “abstract” vendor
can outsource to multiple vendors for redundancy, pricing, or other
reasons.

In order to support multiple back end cloud vendors, the abstract vendor
will need to provide a consistent experience across all vendors. Given
the variation between cloud vendors, this is a significant problem. One
solution proposed by some abstract cloud vendors is to layer another
hypervisor on top of the hypervisor provided by the back end cloud
vendor. While this provides a consistent experience, there are two major
downsides to this approach. One is performance and latency problems
introduced by an additional layer. The second is that services that were
available from the underlying cloud vendor may not be directly
accessible because the layered hypervisor may not allow access to the
underlying network layer, for example, at least without going through
some sort of gateway.

Example: Ravello

\
 
-

\
<span id="_Ref344887978" class="anchor"><span id="_Toc413313775" class="anchor"></span></span>Cloud Network Services
--------------------------------------------------------------------------------------------------------------------

### Introduction

One very important part of a cloud offering are Cloud Services. Cloud
Services are services that a tenant can sign up for, usually by
purchasing them and having them billed to their account. While this
seems like a simple requirement, it has profound implications for how
various network features are exposed to users and how they are
configured.

For a vendor selling cloud services, the services must be arranged into
sellable packages with clear pricing. Services are usually offered with
a simple configuration model because requiring complex configuration
options only adds friction to the sale. While the service may be
complex, the way the service is deployed and operated should not be
complex. Finally, the customer must understand exactly what they are
going to get for their money.

The above requirements commonly result in simple tiered service
offerings with labels such as Gold, Silver, Bronze, or Small, Medium,
and Large. They result in simple service menus so the customer
understands what services are available. Simple web based wizards to
configure a service are presented. Finally, Service Level Agreements
(SLAs) regarding how the service will behave are established so the
customer understands exactly what they have purchased. SLAs may cover
simple issues like how many IP addresses are available to more complex
issues such as networking Quality of Service (QoS) enforcement of
latency and bandwidth, for example.

Anyone building a cloud should first think about what services are being
offered, how they will be offered to the customer, how the customer will
configure the service, and precisely what the customer should expect
from the service. After that, they can start thinking about how to build
the services.

### Types of Services

It is important to understand the different types of services offered by
a cloud vendor. These services can be divided into many types of
services, but the three most common ones are IaaS, PaaS, and SaaS.
Definition of these terms and more can be found here:
<http://en.wikipedia.org/wiki/Cloud_computing>.

This document mainly focuses on IaaS using its broadest definition. For
example, while being able to order a VPN might be considered to be more
sophisticated than simply being able to run VMs on network segments, for
purposes of this document, it is still considered an IaaS. When you
consider the breadth of IaaS services that can be offered, such as DNS,
DHCP, and even a Web Application Firewall, it is clear that some
services are more sophisticated than others, but they still fall into
the IaaS category. The reason is that these services are still
supporting some high level application. They are not the application
themselves, such as Saleforce.com or Microsoft SharePoint. Providing an
application service is SaaS. Salesforce.com is the quintessential SaaS.

Given that there are so many infrastructure services that can be
offered, it may be useful to divide them into categories that clarify
whether these are *really* basic services that are somewhat fundamental
and that nearly all tenants will use, such as IP address assignment,
versus more sophisticated services such as Web Application Firewall,
that a smaller subset of tenants will use.

### Example Basic Network Services

Create tenant

Create broadcast domain or IP subnet

Enable Router

Assign IP to VM

Deploy, Start, Stop VM

Enable DNS service

Enable DHCP service

Manage Access Control Lists

### \
Example Intermediate Network Services

Create VPN Connection

Outbound Internet Access Address

Inbound Internet Access Address

Bidirectional Internet Access Address

Private L4 Load Balancing

Offload SSL Termination

Offload DNSSEC Termination

Tenant-to-Tenant Access

Network Tap

### Example Advanced Network Services

HTTP Caching

HTTP LB w/Cookie persistence

HTTP Optimization

Advanced Service Checking (cloudwatch from vmware)

GSLB

Web Application Firewall

IDS/IPS virus detection

ADCaaS: Dedicated Traffic Manager

\
Cloud Architecture
------------------

Since the cloud introduces many new points of interactions between
hypervisors, management consoles, tenants, providers, and so forth, this
leads to entirely new management models and solutions for managing this
infrastructure. In order to build or use a cloud offering, it is helpful
to understand the various components that are being managed and the
various ways those components can be managed. While this list is a bit
unorganized, it should be helpful in understanding what elements are
present in the cloud management landscape. Also, it should be noted that
these are not formalized terms that you’ll find on Wikipedia. They were
just made up to help explain these concepts.

### Cloud Networks

Users of Cloud services should be aware that networking may not operate
the same way that they are used to with standard Ethernet equipment. For
example, Amazon only supports IP level connectivity between virtual
machines. Other traffic is likely to be dropped. Moreover, Amazon does
not support IP Multicast, so users requiring that functionality will
need to seek alternatives to using Amazon. Different cloud environments
have different limitations and so customers should be aware of these
limitations.

Customers should also be aware that cloud environments also offer (or
impose) additional services, such as a router or VPN. Customers should
be aware of the presence of these components because it may affect the
design of their network topology or selection of vendor components.

Additional information is provided later in this document about the
specific limitations of networking components imposed on customers by
various cloud and hypervisor vendors.

#### Virtual / Overlay Networks

Since cloud environments may have hundreds or thousands of tenants
creating many networks, it is easy to exhaust the 4096 VLANs that are
allowed with standard networking equipment. This is has lead to
alternative solutions that support more than 4096 networks. In order to
move beyond that limit without replacing the existing network, many
environments have introduced an overlay network. An overlay is typically
implemented with tunnels protocols that run on top of the standard
Ethernet equipment. Examples of these protocols are VXLAN and NVGRE.

While using overlay networks is becoming more popular, it is possible to
implement virtual networks with OpenFlow or other SDN technologies, or
with evolutionary network protocols such as Q in Q.

### Transport Network Implementation

The Transport Networking Implementation is typically VLANs. Even though
your virtual network traffic may be encapsulated into VXLAN packets or
similar, those packets ultimately need to traverse a real network. VLANs
are typically the implementation of this transport network, in terms of
segmenting the traffic from other traffic at the lowest level. There are
other solutions such as MPLS and solutions built on OpenFlow that
control the network connectivity.

The relevance of this layer to the upper layers in the cloud environment
is that you’ll ideally want to limit the amount of configuration
necessary to make the transport network work. For example, if you use an
overlay protocol such as VXLAN or NVGRE, that traffic may be carried on
a small number of VLANs. Those VLANs are used to implement the various
IP subnets that your hypervisor servers are running on. The setup of
additional virtual networks shouldn’t require any additional VLANs to be
configured.

While not requiring switches to be configured with VLANs is the ideal,
the reality is that some customers may be using VLANs for segmenting
virtual networks because that may have been the only technology
available when it was first implemented or they have chosen not to
implement the overlay protocols for some other reason. In this case, the
Transport and Virtual Network Implementation may be one and the same.

Another term that may describe the Transport Network is “Provider
Network”. Ideally, in a cloud scenario, the Provider owns and manages
the transport network, while the Tenants manage their own virtual
network segments. This division of ownership is another reason to
implement a layered solution where the activities of tenants do not
directly affect the operation of the transport network in a way that may
affect other tenants in an unexpected way.

### Virtual Network Implementation

The virtual network implementation layer is the mechanism that gets
packets from one virtual machine to another. It must leverage a
transport network to move the packets. The Virtual Network
Implementation layer is responsible for isolating network segment, for
isolating tenants, and for supporting the location and communication
with virtual machines that may have moved to different area of the
*transport network.* Examples of Virtual Network Implementations would
be VXLAN and NVGRE.

&lt;discuss legacy bridging&gt;

### <span id="_Ref341947870" class="anchor"><span id="_Toc413313786" class="anchor"></span></span>Layered Virtual Network Implementation

The concept of a Layered Virtual Network Implementation is interesting
to be aware of, even though this is rather uncommon at this point. The
idea is that there is so much variation between different cloud vendors
in terms of how their networks operate, their APIs, and so forth, that
it becomes very difficult to create a “portable” cloud deployment.
Portable in this context means that I can deploy to a different cloud
provider without too much trouble. For this to work, I need a
combination of standardize behavior and standard APIs to configure that
behavior.

To solve this problem, a few vendors have proposed layering another
hypervisor on top of the existing cloud hypervisor. While this provides
a consistent experience, there are two major downsides to this approach.
One is the performance bottlenecks and latency introduced by an
additional layer. The second is that services that were available from
the underlying cloud vendor may not be directly accessible because the
layered hypervisor may not allow access to the underlying network layer,
for example, at least without going through some sort of gateway.

### Virtual Infrastructure Network API

Once you’ve selected your network virtualization implementation, you can
proceed to working out how to configure these virtual networks. In the
cloud environment, automation is critical, so virtual network segments
need be created via an API. An API that allows creating virtual subnets
is what is named the “Virtual Infrastructure Network API”, at least in
this document. Examples of APIs that provide this functionality are
Amazon AWS (VPC), VMware vCenter, and OpenStack Quantum.

Also, these APIs include a way to attach and detach the VM to a network
segment. Typically, this can be done by associating a specific network
adapter on the VM with a specific network segment.

### Virtual Infrastructure Compute API

Once subnets are available, VMs can then be deployed. Obviously, VMs
talking over networks requires the VMs to be deployed and operational.
So, there needs to be an API for deploying and operating the VMs as part
of the system for creating a cloud. This is typically done in
conjunction with networking oriented APIs and it would be strange to
have either a Compute API or Networking API but not both. Examples of
APIs that provide this functionality are Amazon AWS (VPC), VMware
vCenter, and OpenStack Nova.

### Cloud Services API

In the previous chapter, the importance of Cloud Services was
emphasized. Examples were listed of various services that may be offered
in a Cloud. For these various services, it is expected that the service
will be configurable via an API.

Most cloud services are available to be configured via REST APIs while
some are available alternatively via SOAP/XML. APIs are typically
available for configuring, listing, monitoring, and discontinuing
services.

A cloud tenant buys a cloud service, so the cloud services API should be
accessible to the cloud tenants. The cloud service API should be easy to
use and should be oriented around the benefits of the service. It may be
associated with a Service Level Agreement that details the benefits of
the service and expectations of how well the service will operate,
usually in terms of availability, performance, and scalability.

Because many cloud services are related to networking, cloud services
are often implemented by configuring networking features on networking
equipment and/or virtual machines. Therefore, it is common for the cloud
management system to take cloud service configuration parameters and map
them to the configuration parameters of features on networking
equipment. This mapping from service parameters to feature parameters
should be part of an abstraction layer that can be used to simplify the
configuration model for customers. It can also provide a useful layer
for a cloud operator to include business logic for their particular
environment.

&lt;ADD DIAGRAM&gt;

### Service Fabrics and Service Chaining

A Service Fabric is a set of devices that provide a service and operate
in a unified fashion as though you were operating a single entity. While
customers may have been attempting to build service fabrics for a very
long time, new technologies such as SDN/OpenFlow and Network Overlays
such as VXLAN, have re-ignited an interest in building these fabrics
with new technologies.

Many of the technologies proposed for usage in a service fabric are
fairly new, and the networking patterns that are being developed are not
well understood and standardized. Even the terminology is not well
developed. We’ll start with trying to identify the main components of a
service fabric so it is clear what is being talked about. Some of the
terms in the following section are adopted ad-hoc and so they may be
unfamiliar to a customer.

First we will attempt to distinguish between a Cluster, a Service
fabric, and a Service Chaining Fabric.

![](media/image1.png)

*Network Function / Service Cluster*

A cluster is a set of devices that are designed to work closely together
and are tightly coupled by a control plane. Each device is probably
aware of the other devices in the cluster. In the diagram above, there
are two ADC clusters shown. Each ADC cluster has a full mesh of
connections.

*Network Function / Service Fabric*

A fabric is the larger set of all devices providing a function and may
consist of multiple clusters. A management system (sometimes referred to
as the Service Fabric Controller) sets up and scales clusters and knows
when to create a new cluster. The reason that multiple clusters may be
created is that there is a limit to the number of devices in a cluster.

Workloads are directed to a fabric by a higher level management system,
then a Service Fabric Controller assigns the workload to a cluster based
on load, and then the Cluster assigns the workload to a member or set of
members (in the case of a Super VIP, which runs simultaneously on
multiple elements) of the cluster based on load.

*Service Chaining Fabrics*

Service Chaining allows a customer to transparently insert a new service
into a service graph without affecting other services in the graph. The
key factor is that many of these services rely on the IP addresses to
identify the original source (a mobile handset) and the ultimate
destination (e.g. an internet address), and do not allow the IP
addresses to be modified.

The IP-transparency requirement introduces a challenge to traditional
“proxy” devices or middle-boxes that have typically used IP addresses to
direct traffic to the next hop in the service path. Some other mechanism
must be used to direct traffic within the service graph. There are a
number of ideas for this.

<http://tools.ietf.org/id/draft-boucadair-network-function-chaining-02.txt>

<http://tools.ietf.org/html/draft-jiang-service-chaining-arch-00>

Assembling services into a graph of services to apply to various traffic
classifications is the job of a Service Fabric Controller. This
controller exposes a management user to the administrator to allow
managing the service chaining policies.

*Service Identifier*

The IETF drafts in the previous section describe the use of various
kinds of identifiers in the network packets that can be used to direct
the traffic between services. For example, a VLAN or VXLAN id could be
used for this purpose. The second IETF draft calls the logical
identifier for a service to be a Service Id. That maps to an on-the-wire
packet identifier, which could be one of various fields in the packet.

It is interesting to consider that the Service Identifier represents a
processing endpoint just like an IP based Virtual Server address would
work for a load balancer. It is not too much of a stretch to consider a
device that directs traffic based on a Service Identifier to be very
much like an ADC (application delivery controller).

Cloud Management Tools
----------------------

### Overview

### Virtual Subnet Mgmt

Once you have APIs to manage compute and networking, there should be a
console for ad hoc management tasks. Generally, self-service combined
with automation is the preferred way to “manage” networks, but it is
often convenient for a cloud provider to utilize a management console
that allows them to manage all of the virtual subnets and VMs in their
cloud. Examples of management consoles that provide this are VMware
vCenter and DynamicOps.

![](media/image2.png)

vCenter Networking Management

### Virtual Private Cloud Mgmt

A cloud provider needs to have Administrator privileges for their entire
infrastructure. For example, if some VM is violating some security
policy, the cloud administrator may want to shutdown that VM or
disconnect it. They also need to view the cloud holistically to monitor
capacity and plan for growth. A tenant, in contrast, who wants to manage
their own resources, needs their own view and management console that is
restricted to their own resources. When you combine tenant isolate with
self-service management, you have the components of a Virtual Private
Cloud.

Examples of this are VMware vCloud Director and the Amazon VPC console.

![](media/image3.png)

vCloud Director vApp Networking Diagram

![](media/image4.png)

AWS Virtual Private Cloud Subnet Management (some fields are redacted.)

### Virtual Private Cloud Templating

Once a tenant has control over their private cloud and can create
subnets and deploy VMs, there are some scenarios where the tenant can
benefit from “cloud templating” capabilities. The idea of a cloud
template is that there may be some kind of services which a tenant may
want to deploy multiple times. For example, the tenant may have a
three-tiered application (web, application, db) that is composed of
multiple subnets and VMs arranged together in a specific way. Now
imagine that the tenant wants to “stamp-out” that application into
multiple geographical locations. Some vendors are providing template
technologies that allow the tenant to define a template that defines the
arrangement of the VMs, but leaves out certain details that are unique
to each deployment (such as public IP addresses).

Once a tenant has defined a template, they can select that template and
fill in the details (either automatically or manually) and have all the
subnets and VMs created and deployed. This substantially reduces the
effort to deploy the service.

Examples of cloud templating technologies are VMware vApp and VMware
vFabric App Director, Amazon Cloud Formation templates, and Oracle VAB.

&lt;add vshield iApp screen shot&gt;

### Service Templating / Insertion

The previous section described a templating system for tenants to
leverage to deploy their services. There are also cases where the cloud
provider offers standard services that can be ordered and deployed by
the tenant. These services may be provided by a third party, so there is
a desire to have some sort of standard for defining the service and
relaying configuration between a tenant, cloud provider, and service
provider.

*Service Templates for cloud services and inserting those services into
cloud environments is different than Service Chaining, which is defined
in the Cloud Architecture section of this document and described in
detail in the SDN section.*

Examples of this are vCloud Ecosystem Framework and TOSCA.

### Provider Cloud Management

Provider Cloud Management is the management system that a cloud provider
uses to manage the entire cloud infrastructure, including physical and
virtual networking, Hosts and Hypervisors, VMs, VM catalogs, services,
etc. This console should support monitoring, resource balancing, and
capacity planning. It should also support orchestration.

Examples of this are the VMware vSphere suite, which includes
sophisticated facilities such as the Distributed Resource Scheduler for
resource balancing and VMware Orchestrator for orchestration. Other
examples are BMC Cloud Lifecycle Manager and DynamicOps.

&lt;add screen shot of VMware distributed scheduler&gt;

### Hybrid and Heterogeneous Cloud Management

An example of Hybrid cloud management would be vCloud Director in
combination with a third party provider. Citrix CloudBridge is another
example.

An example of Heterogeneous cloud management is BMC Lifecycle Manager,
Dynamic Ops.

&lt;add BMC screen shot&gt;

### Abstract cloud management

Abstract cloud management provides the same functionality as virtual
private cloud management except that underneath, there are adaptors to
each cloud deployment.

An example of an abstract cloud is Ravello.

![](media/image5.png)

Here is a zoom of Step 3:

![](media/image6.png)

Business Integration for Clouds
-------------------------------

The following presentation is, by far, the most comprehensive available
that discusses the challenge of providing a public service using a cloud
and integrating that into the business processes of an organization. In
this case the company was Dell.

<https://www.openstack.org/summit/portland-2013/session-videos/presentation/best-practices-for-integrating-a-third-party-portal-with-openstack/>

![](media/image7.png)

\
Technology Directions
=====================

Software Defined Networks
-------------------------

### Introduction

### Use Cases

### Vendors

#### VMware NSX

#### Nuage

#### Juniper Contrail

#### OpenDayLight

#### PlumGrid

#### Midokura

#### Cisco

#### BigSwitch

#### Cisco

#### Juniper

http://www.theregister.co.uk/2013/01/16/juniper\_sdn\_strategy/

#### HP

http://www.networkcomputing.com/next-gen-network-tech-center/hp-details-sdn-strategy-announces-new-pr/240008407

Service Stiching
----------------

### IP based 

#### NAT on ingress and egress to SDN

##### Use routing to pick service chains

##### Use bitmasks to pick service chains

###### Is this possible with OpenFlow?

Not clear because the SDN switches claim they will select a service
member to handle a flow, perhaps using a hash. OpenFlow cannot operate
on a flow hash, I think. I could be wrong. (It may support ECMP)

Network Function Virtualization
-------------------------------

Containers
----------


