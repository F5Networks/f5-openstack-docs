---
layout: landing_page
title: Cloud Services Overview
---


#F5 Partnerships and Integrations
================================

#Cisco ACI
---------

#VMware
------

<https://www.gosavo.com/EDGE/Document/Document.aspx?id=824034&view>=

<https://www.gosavo.com/EDGE/Document/Document.aspx?id=961756&view>=

## vSphere Management Plug-In

## VMware View and F5

Patch for ESXi 5.1:

<http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2035268>

<http://www.vmware.com/files/pdf/solutions/vmw-alwayson-validated-design-guide.pdf>

## vCloud Director

# NSX

<http://www.f5.com/pdf/solution-center/vmware-nsx-overview.pdf>

# IBM

http://www-304.ibm.com/software/brandcatalog/ismlibrary/details?catalog.label=1TW10SO06

John Gruber’s comments:

It's stuck at v10.2.  Has problems with HA pairs.\
\
Nojan Moshiri worked with them through our bizdev partner organization.\
\
John

# Nuage Networks

Yes, we are the LB part of the ALU Nuage solution.  Nuage is currently
in the process of trying to close their first few deals, with F5 active
in at least a couple of them.  There is some documentation out on Hive
that should be able to give you an ideal about the solution:

<https://hive.f5.com/docs/DOC-11431>

<https://hive.f5.com/people/roeder/blog/2013/04/02/nuage-networks-alu-sdn-is-finally-live>

<https://hive.f5.com/people/roeder/blog/2012/12/11/alu-sdn-story-goes-public--f5-will-be-part-of-it>

Let us know if you have questions!

**John Allen**

Principal Solutions Engineer

Carrier Service Provider Partners

Microsoft Hyper-V Gateway
-------------------------

Ask Bellamy

OpenStack
---------

# Nova Networking (legacy networking) vs Quantum Networking

Different kinds of Quantum networks

BIG-IP Integration Strategy

OVS integration strategy

#Arista
------

##Arista VXLAN Gateway

<http://www.aristanetworks.com/media/system/pdf/VMworld_Demo_Brief.pdf>

#BigSwitch
---------

The following is content that BigSwitch has created, not F5.

![](media/image1.emf)

![](media/image2.emf)

![](media/image3.emf)

![](media/image4.emf)

#NetApp
------

<http://www.f5.com/pdf/deployment-guides/f5-vmotion-flexcache-dg.pdf>

#BMC Cloud Lifecycle Manager
---------------------------

<https://devcentral.f5.com/blogs/us/bmc-cloud-lifecycle-manager-and-f5-automated-application-delivery>

<http://www.f5.com/products/technology/bmc-software/>

<http://www.f5.com/pdf/solution-center/f5-bmc-partnership-overview.pdf>

#HP
--

##CloudStack and Xen CloudPlatform / CloudPortal
----------------------------------------------

I believe this written by John Gruber:

The interface supported by the CloudStack portal is networking LBaaS
unfortunately. They have a networking FWaaS interface which supports
Juniper which we could code to as well.

CloudStack supports its own L4 LoadBalancer VM. Other LBaaS devices are
considered 'external' and require an integration driver.\
\
There was a community based f5 LBaaS driver for CloudStack 3.0 which
used java iControl to setup virtual servers on an external BigIP, but it
was very basic. It was not written by f5.  It does not support v11
(welcome to folders) nor administrative partitions in v10.   I haven't
spent anytime with it since Agility 2011 when we used CloudStack as our
example private cloud.  The presentation was designed right before
Citrix bought them, and I had an heck of a time getting an eval.\
\
As of last summer, CloudStack was still touting f5 BigIP support.  See
the attached presentation slide 26th, but this is stull just the old
community LBaaS driver. The presentation is all about the network modes
of setting up CloudStack.\
\
As far as PD defined product, f5 has no IaaS integration with CloudStack
as of today.
