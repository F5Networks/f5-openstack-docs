---
title: F5 Platforms for Cloud
url: {{ page.title | slugify }}
categories: cloud, platforms, misc_docs
resource: true
---


#Introduction
============

#F5 Platform Selection
=====================

There are a number of factors to consider when evaluating which F5
platforms are appropriate for your cloud deployment. Many of these
factors are specific to your particular business issues. There are too
many variables to recommend one specific platform or set of platforms
for the cloud environment. In fact, there may be an appropriate cloud
scenario that might make sense for every one of the F5 platforms.

The two major divisions of the platforms are Virtual Application
Delivery Controllers (vADCs) in the form of the F5 Virtual Editions, and
Physical Application Delivery Controllers (pADCs) in the form of fixed
appliances (e.g. 3900, 8950) and modular chassis based platforms
(Viprion).

Much of the content of this section is derived from a white paper
written by Lori MacVittie and is linked here:
<https://www.gosavo.com/EDGE/Document/Document.aspx?id=1004042&view>=

#Workload Analysis
-----------------

In order to determine which platforms are appropriate for your
environment, you should think about what kind of services you will be
providing, how much of a workload you expect, and how much and at what
rate you expect those workloads to increase. This may be one of the more
difficult steps in the entire process of using or building a cloud. The
reader is referred to the section on **Error! Reference source not
found.** to help them decide which services will be supported.

Some key factors to focus on here are: the expected number of concurrent
connections, the expected throughput per second, whether SSL offload
will be provided, and the SSL handshakes per second and SSL bits per
second requirements. Also, the customer should determine whether they
will have advanced services with high CPU workloads such as ASM or AVR.

#Capacity
--------

Once you have estimated the amount and kind of workloads that you are
anticipating, you can proceed to selecting platforms that can support
those workloads.

Capacity should be considered in combination with scalability. A small
platform may be fine if there is an appropriate way to scale up to meet
the requirements. All F5 platforms can be scaled out by creating larger
device clusters. That said, expanding a cluster in production is not
simple and may cause disruptions. So, it is desirable to limit this
activity by choosing a platform which is large enough such that adding
more capacity really does add a lot more capacity and would be done
infrequently, rather than adding capacity in such small increments that
you are constantly scaling out your clusters.

#Scalability
-----------

As noted in the previous section, all F5 platforms can be scaled out by
creating larger device clusters. Some F5 platforms also support
“Scale-Up” by adding more capacity to the existing platform. These are
the Virpion modular systems that can accommodate expansion by adding
additional blades to the system. These blades can be added on-the-fly.

Questions: Can VCMP instances automatically pick up new blades? Addition
of a blade is non-disruptive, correct?

The Viprion has its own capacity limits (there are only so many slots
for blades) and once those limits are reached, a scale-out solution is
necessary. If you think you may never exceed the capacity of a
fully-populated Viprion, then you may not need a scale-out strategy.
That may be a desirable simplification, especially if you don’t have the
time and resources to create a scale-out solution.

Assuming you cannot handle all of your traffic through one device (or HA
pair), then you can consider scaling out beyond an HA pair. You can
scale out by either segmenting your traffic managers or by creating
larger Active-Active clusters of traffic managers.

You can segment traffic by assigning an ADC (or HA pair) to a tenant or
group of tenants. For example, the ADC may act as the default route for
a set of servers or tenants, while another ADC (or HA pair) acts as the
default route for a different set of servers. Segmentation is a fairly
common solution because it is relatively simple to setup. You just setup
HA pairs and if you need more of them, just stamp them out. The downside
is that ADCs setup this way cannot be shared across segments, and so one
segment can be overloaded while another segment is mostly idle. This may
not be as economical as using a larger shared resource that can be
utilized more efficiently.

Another way to scale out is to create a larger device cluster. If you
want to create large groups of devices for clustering purposes, it is
necessary to be familiar with ***device-groups*** and
***traffic-groups***. A device-group is a group of devices that trust
each other and synchronize their configurations. A traffic-group is a
discrete (indivisible) workload of traffic that can be run on one of the
devices in the device-group. A traffic-group consists of a set of
virtual servers and other IP addresses (such as default gateways) that
represent a set of traffic that needs to be processed through the same
device. You can create multiple traffic-groups across your device-group
and run one traffic-group (workload) on one device and a different
traffic-group on another device. For example, a virtual server for
incoming traffic and the gateway IP address that the real servers will
use as their return address would be in the same traffic-group. The
reason for this is that if there is a failover, the virtual IP and the
gateway IP must failover to another device, *together.* Otherwise,
incoming traffic might go through one device while outgoing return
traffic would go through a different device, which does not work.

Scaling out traffic managers with device-groups and traffic-groups seems
like a straightforward solution, but there is one huge limitation to be
aware of. A traffic-group can only be handled by one BIG-IP. A
traffic-group essentially represents a set of IP addresses, and in our
standard traffic-group configurations, only one BIG-IP will respond to
an IP address. So, you can divide up your traffic into multiple virtual
servers, and you can spread those virtual servers across many devices,
but each individual virtual server IP address is limited to running on
one BIG-IP at a time. In other words, you cannot create a “Super VIP” (a
VIP who’s traffic is processed by multiple BIG-IP instances) like you
can with multiple blades of a Viprion.

Just to be clear, while a Super VIP is not possible with the standard
configuration, if you add an upstream load balancer to the mix, then a
Super-VIP becomes possible with appliances clustered using
device-groups. You are still limited to what the single upstream BIG-IP
can handle, but if the upstream load balancer uses layer 4, and the
downstream load balancers are processing at layer 7, the upstream load
balancer may be able to process far more traffic than one ADC processing
traffic at layer 7.

#Economics
---------

Economics may factor into your platform selection. For example, F5
physical devices include SSL offload hardware and it would be much more
economical to use a physical device rather than a virtual device for
workloads that include a lot of SSL traffic. Also, pADCs can handle a
large number of Layer 4 connections and high amounts of throughput. If
multiple cloud tenants are using the same pADC, then the cost for the
pADC is amortized across many customers. Depending on pricing and
licensing, this may be the most economical choice for a cloud provider.
An alternative might be to deploy a vADC for each tenant. However, if
each tenant is only using a small amount of traffic, the cost of a vADC
for each customer would be prohibitive. Note that a pay-as-you-go
licensing model could alleviate this economical issue with vADC. See the
section on F5 Licensing Models for further discussion on that topic.

A special mention should be made about VCMP. As you probably know, vCMP
allows you to divide a Viprion chassis into many BIG-IP instances. It
may be worth considering a model where you assign a vCMP instance to a
cloud tenant. This has the advantage of providing resources to a tenant
that are isolated from other tenants. See the section on Resource
Isolation. The downside is that a Viprion can only host a small number
of vCMP instances. So, this would only make sense if a tenant is a very
large tenant. Even if you divide a Viprion into 16 different instances,
each instance would still cost upwards of ten thousand dollars each when
the price is divided between instances.

Another option to consider with the Viprion is to designate some vCMP
instances as reserved to a tenant and others as shared across tenants.
See the best practice recommendations at the end of this chapter for
further discussion.

It should be noted that the same Viprion license applies to all vCMP
instances. Therefore, if one vCMP instance requires certain licensing
options to satisfy a particular tenant, then the entire Viprion must be
licensed for that option as well.

#Agility
-------

Another factor to consider when choosing an F5 platform is the ability
to easily deploy many instances of BIG-IP with little human interaction.
This kind of agility may be important when there are a large number of
cloud tenants signing up over a given period of time and a dynamic
deployment mechanism is needed to keep up with the volume. Without
question, the Virtual Edition is going to be more agile than a physical
BIG-IP. This simple reason is that hypervisors support the ability to
spin up and deploy a VE automatically via their APIs. A physical BIG-IP
will always need to be cabled into the infrastructure, so it will never
be as agile as a virtual solution.

Besides deployment agility, a Virtual Edition can also support
redeployment agility. For example, a Virtual Edition could be shutdown
and moved to another physical host, whereas that is not possible with a
pADC. This agility helps with balancing load in the cloud infrastructure
and can be used to consolidate tenants and BIG-IPs into a common
location to reduce latency, for example. In this way, agility of
deployment may help avoid traffic trombone issues that can arise when
virtualizing Network Functions. See the section on Network Function
Virtualization for further information.

#Resource Isolation
------------------

In the discussion on Economics, it was noted that if multiple tenants
share a BIG-IP instance, that can result in cost savings. The other side
of the coin is that tenants that are sharing a resource can adversely
affect other tenants. For example, one tenant may consume all the memory
available for handling connections if too many connection attempts are
flooding the virtual server for a particular tenant.

As mentioned in the section on Economics, a Viprion chassis can be
divided into multiple vCMP instances that can each be assigned to a
tenant or group of tenants. Each vCMP instance is assigned a dedicated
amount of CPU and memory. So, you get sort of the best of both worlds –
multi-tenancy and resource isolation. As mentioned in the Economics
section, a serious constraint is that a Viprion can only support 16 vCMP
instances.

The reality is that the current options are not ideal. Ideally, there
would be platforms that economically support many tenants for a
reasonable price while also having resource isolation that allows for
fine-grained, flexible, and accurate assignment of resources to tenants.

#Failure and Security Isolation
------------------------------

In some deployment options, the BIG-IP is shared across multiple
tenants. The risk with this kind of deployment is that a bug or other
issue with traffic management of one tenant could affect another tenant.
For example, if one tenant is attacked and the attacker found a
vulnerability in BIG-IP, then all tenants using that BIG-IP would be
exposed. However, if each tenant has their own BIG-IP, then the failure
of one tenant is isolated to that tenant.

As with many of the factors in choosing a platforms, there are
trade-offs. While sharing a BIG-IP may be more economical and easier to
manage, the downside is that failure and security domains are larger,
and so the impact of a failure or intrusion is larger.

#Manageability
-------------

Manageability is a critical issue for cloud environments because a big
advantage of using a cloud is the ability to quickly and easily spin up
network and compute resources. Moreover, the management interfaces are
critical to achieving this agility. With that said, it is worth looking
at the differences in the way different deployment models would be
managed.

One issue to consider with respect to managing many tenants is how to
deal with route domains. Support for route domains means that each
tenant can have a separate routing table. So, if you are providing route
domain support and you are supporting multiple tenants on a single
big-ip instance, then you have to craft your api calls so that the
proper route domain is specified when creating objects for a tenant. You
can simplify this a bit by using partitions and specifying a default
route domain for the partition, but it will still be a significant
amount of work.

If you require the use of features that do not support route domains,
such as ASM, then you may need to choose a platform that makes sense for
this scenario. If you deploy a virtual edition for each tenant, then the
default route domain can be used for each tenant and you won’t have to
create secondary route domains or really deal with route domains at all.
So, for ASM support for multiple tenants, virtual edition is probably
the way to go.

#Best Practices
--------------

## Use Virtual Edition for Third Party Cloud

If you are using a third party cloud environment that you have no
control over, you should use the Virtual Edition of BIG-IP and deploy it
like a regular virtual machine into your cloud network. If the vendor
allows you to deploy your own physical BIG-IP then that’s more of a
hosting solution than a cloud solution. For the cloud, you’ll need use
virtual machines.

## Use physical ADCs for Session Layer

If you are building a cloud, there are a number of options, but there is
a common pattern that you should consider, which is a hybrid of pADC and
vADC. Physical BIG-IPs are good for a larger number of tenants because
it is more economical than deploying a Virtual Edition for every tenant.
Specifically, for layer 4 and SSL traffic, these platforms have hardware
acceleration that can support many times the amount of traffic that an
equivalent Virtual Edition could support.

So, it is worth considering the use of an upstream BIG-IP that handles
connections for many tenants and offloads the NAT and SSL functions. The
upstream BIG-IP may decrypt the SSL and forward to a lower level BIG-IP
that handles more CPU-intensive functions. For example, the lower level
BIG-IP may handle application level security using ASM.

Unfortunately, it won’t be as simple as configuring a layer 4 virtual
server that directs traffic to the appropriate lower level BIG-IP. If
the upstream BIG-IP is also doing load balancing, then persistence may
be required. The most reliable form of persistence is cookie
persistence, which is a layer 7 feature. So, the upstream BIG-IP may
need to do some layer 7 processing, which will increase the workload on
that BIG-IP. To keep the upstream BIG-IP from being a bottleneck, you
should limit the processing done at that layer. So, while it is
*necessary* that persistence be handled at the upper layer, other
features, such as web optimizations, that don’t need to be done at the
upper layer should probably be done at the lower layer. There will be
some gray areas. HTTP Compression, for example, doesn’t need to be done
at a higher layer, but it might make sense from an economical
perspective if the upstream BIG-IP has hardware that can support
compression more economically.

## Use vADC for CPU-intensive or Advanced Features

If you are using features that consume a lot of CPU and memory
resources, a best practice is to deploy a vADC with dedicated resources
to handle that traffic. While you may still host multiple tenants on a
single vADC, the point is that having a dedicated vADC or cluster of
vADCs for particular features allows you to reserve capacity for those
purposes. Another benefit to this model is that a shared, upstream
BIG-IP may only need to do simpler tasks such as NAT if the higher level
processing is handled at a lower level by dedicated resources. Simpler
is better, especially for a shared infrastructure element. The more you
can do to isolate heavy processing for particular tenants, the better.
For example, a site that requires a web application firewall policy that
consumes a lot of memory and processing shouldn’t affect another tenant
that is not using those features. Dedicating vADCs to handle ASM could
resolve that. An alternative is using a bigger BIG-IP that is shared.
The problem is that a burst of traffic to one web site could consume
enough CPU and memory that traffic for other web sites could be
affected, either with increase latency, or rejected connections if too
much memory is consumed. There are security factors to consider as well,
as mentioned in the previous chapter on selecting a platform.

## Load balance virtual ADCs with physical ADCs

We’ve mentioned that an upstream BIG-IP can perform certain functions
such as session management and SSL offload, but another feature that can
be used is load balancing. It may be that a single BIG-IP cannot handle
all of the processing for a web site. For example, the web site may have
a lot of traffic and may require SSL offload, cookie persistence, web
security, web optimization, and caching. A single BIG-IP may not be able
to handle that workload. A way to deal with this problem is to use an
upstream load balancer to handle SSL offload, cookie persistence, and
load balancing. The web security, optimization, and caching can be done
at a lower layer BIG-IP. You will still be limited to what one BIG-IP
can handle in terms of SSL and cookie persistence, but that is a great
deal more than if it was also performing the other functions as well.

## Build PODs for Scalability

A **point of delivery**, or **POD**, is "a module of network, compute,
storage, and application components that work together to deliver
networking services. The POD is a repeatable pattern, and its components
maximize the modularity, scalability, and manageability of data
centers."

<http://en.wikipedia.org/wiki/Point_of_delivery_(networking)>

I should be clear that we use a generic form of “POD” rather than the
more narrow definition is sometimes used to refer to prefabricated
commercial PODs that are entirely self-contained environments. Here, we
just mean the “repeatable pattern” of components. You can build your own
PODs.

The idea is that you design a modular pattern of components that can be
built and added to your infrastructure in order to incrementally add
capacity. You should include the traffic management components as part
of the POD design. There may even be a hierarchy to your design. For
example, you may design your POD to be a rack of equipment which
includes networking components and servers. You may dedicate some of the
hypervisor capacity to vADCs that handle particular web sites. For your
data center-level traffic management, you may decide to allocate a
Viprion pADC for every 4 racks of equipment, for example. You may decide
that you will host 50 cloud tenants per rack. So, that is a Viprion for
every 200 cloud tenants. The exact numbers you select will depend on
exactly what services you will offer and how much traffic you expect
your tenants to consume, on average.

## Final Thoughts

Reading through guidelines on Platform Selection and the Best Practices
for deployment models can be a bit overwhelming. Anticipating traffic
requirements and which services will be adopted by customers is
difficult. It may be helpful to start with a small deployment to gather
data about how much traffic is being processed and which services will
be in demand. From there you can start to think about what model makes
sense for scaling out your traffic management capacity (Viprion versus
Appliance Clusters, versus Virtual Edition). From there you can start
planning POD designs and how you will expand your POD deployments. Only
at that point do you really start to have a handle on *what you are
building*. The rest of this document gets into specific details on *how*
to build your cloud environment.
