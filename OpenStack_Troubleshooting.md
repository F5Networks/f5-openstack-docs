# OpenStack Troubleshooting

## Check Horizon Dashboard

```
juju status openstack-dashboard/0
```

Using the address listed from the command above, open a browser and
check on it:

[http://172.2.99.192/horizon](http://172.27.99.192/horizon) (User admin,
pass openstack)

(User and password were set by Juju deployment config file.)

### Checking OpenStack Networking Status

maas-ctrl\$ cd

maas-ctrl\$ odk_creds &gt; creds.sh

maas-ctrl\$ odk_qg_scp creds.sh

maas-ctrl\$ odk_qg

quantum-gateway\$ source creds.sh

quantum-gateway\$ neutron agent-list

+--------------------------------------+--------------------+--------------------+-------+----------------+

| id | agent_type | host | alive | admin_state_up |

+--------------------------------------+--------------------+--------------------+-------+----------------+

| 1b6b8d19-ba6f-4967-a6f3-a2de1cb83067 | Open vSwitch agent |
maas-1-node-4.maas | :-) | True |

| 3a3f0915-a44a-436a-9a57-d69f50c0fcba | Open vSwitch agent |
maas-1-node-1.maas | :-) | True |

| 4206243d-5e26-4667-9159-704de405e735 | DHCP agent | maas-1-node-4.maas
| :-) | True |

| 851ffa93-59a6-41bb-b493-c9f875fab190 | L3 agent | maas-1-node-4.maas |
:-) | True |

+--------------------------------------+--------------------+--------------------+-------+----------------+

quantum-gateway\$ nova service-list

### F5 Diagnostics

See the odk-openstack diagnose script for various commands that we run
to collect data from the OpenStack environment.

ovs-vsctl show

ovs-ofctl dump-flows

ovs-ofctl show

ovs-appctl ofproto/trace br-int &lt;packet matches&gt;

ovsdb-client dump

ovsdb-client dump | grep -e iface-id -e admin_state | cut
-c1-49,155-311,415-461

\
Red Hat Certification Testing Procedures
========================================

Introduction
------------

These instructions are for Test Suite version 6, which corresponds to
OpenStack Juno. The Red Hat certification instructions are here:

<https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform_Certification_Test_Suite/>

Requirements
------------

You will need:

-   Two machines with Internet connections.

-   A Red Hat Account with Business Partner privileges. Contact F5
    Business Development for this. Matt Quill is the current
    bizdev contact.

Start OpenStack All-in-one Setup
--------------------------------

Setup the first Red Hat 7 server. Create root and manager accounts
during installation. Login as root and perform these steps:

subscription-manager register

subscription-manager list --available

subscription-manager attach --pool=&lt;ID of Business Partner
Subscription&gt;

subscription-manager repos --enable=rhel-7-server-rpms \\

--enable=rhel-7-server-rh-common-rpms \\

--enable=rhel-7-server-openstack-6.0-rpms
--enable=rhel-7-server-cert-rpms

yum update -y

systemctl disable NetworkManager

echo GATEWAY=10.144.65.62 &gt;&gt; /etc/sysconfig/network

reboot

Login after boot

yum install -y screen

Do full ODK quickstart here, using object config mode,, including
running odk-install. (Yes some commands from above will be run again in
odk-install but don't worry about it.)

odk-openstack deploy --quickstart --icontrol-config-mode object

NOTE that while the ODK is running, you can setup the second server.
Those instructions are next.

\
Setup Testing Device
--------------------

Setup a second Red Hat 7 server from scratch. This system will run the
GUI for the test suite.

On second server:

subscription-manager register

subscription-manager list --available

subscription-manager attach --pool=&lt;ID of Business Partner
Subscription&gt;

subscription-manager repos --enable=rhel-7-server-rpms \\

--enable=rhel-7-server-cert-rpms \\

--enable=rhel-7-server-openstack-6.0-rpms

yum install -y redhat-certification redhat-certification-openstack

Give first server a hostname and add the hostname and ip address to
/etc/host on second server.

vi /etc/hosts

iptables -F \# unblock web server port

rhcert-backend server start

Prepare All-in-One Setup for Certification Test
-----------------------------------------------

Back on the first server, after seeing the ODK say TEST PASSED, continue
with these instructions. Do this on FIRST server:

vi /etc/neutron/f5-bigip-lbaas-agent.ini

max_namespaces_per_tenant = 5

systemctl restart f5-bigip-lbaas-agent

source keystonerc_admin

keystone role-create --name Member

keystone user-role-list

keystone tenant-list

keystone user-role-add --user &lt;admin id&gt; --role &lt;admin role
id&gt; --tenant &lt;proj_1 id&gt;

sudo yum install -y redhat-certification redhat-certification-openstack

sudo systemctl restart httpd

sudo vi /etc/hosts

Put the SECOND server's hostname in /etc/hosts

su

rhcert-backend server listener

\
Prepare Red Hat Bugzilla Submission
-----------------------------------

Following the instructions from the Red Hat OpenStack Certification
User’s Guide, we are required to open a Red Hat Bugzilla Request to be
certified. This process is used to facilitate issue tracking and as a
mechanism for submitting information of documents to Red Hat.

The instructions require you to answer a questionnaire and submit the
answers in the Description field of the bugzilla request.

These are the answers that were provided for 6.0 certification. Cut and
paste the text into the Description field and also create a word
document with just these answers (with the diagrams) and attach the word
document.

**Product Overview**

1.  Company Name:

F5 Networks Inc.

1.  Product name and version:

F5 BIG-IP LBaaS Plug-in 1.0.8

1.  Type of Product/Component (In Tree/Out of Tree/Other Application):

Out of Tree

1.  Product license:

Apache 2.0

1.  Product Packaging Format:

RPM

1.  Product Dependencies (List all the dependencies that are not
    included in Red Hat Enterprise Linux OpenStack Platform, For each
    component include name, version and URL):

None.

**Product Description**

1.  OpenStack API version implemented (For example, Networking, Block
    Storage or Object Storage APIs implemented by your In tree/ Out of
    tree component):

OpenStack LBaaS v1.0

1.  General Availability (GA) date of product via Openstack.org (Only
    for In tree components):

N/A

1.  Link to upstream blueprint (Only for In tree components):

N/A

1.  Link to the source code (external repository) or software download
    URL (Only for Out of tree components/Other applications):

<https://devcentral.f5.com/d/openstack-neutron-lbaas-driver-and-agent?download=true&vid=210>

1.  Link to product documentation, including (if applicable)
    installation and configuration steps specific to Red Hat Enterprise
    Linux OpenStack Platform (For all components/products):

<https://devcentral.f5.com/d/openstack-neutron-lbaas-driver-and-agent?download=true&vid=210>

(Package above installs
/usr/share/doc/f5-bigip-lbaas-agent/f5lbaas-readme.pdf)

1.  Hostname for your Red Hat Certification back-end server or OpenStack
    deployment controller node? (**NOTE**: The hostname will be the same
    since you are expected to run Red Hat Certification back-end server
    and your OpenStack deployment which is under test on the
    same machine)

pack13.openstack

(NOTE: Not a public DNS name)

**Platform Dependency on Red Hat Enterprise Linux 7.x**

1.  Do you have OpenStack management apps which run on RHEL 7.0.x &
    6.6.x (Yes/No)?

No

1.  Do you have OpenStack management apps which run on top of RHEL
    OpenStack Platform (Yes/No)?

No

1.  For a given RHEL OpenStack Platform release, does your hardware
    require linux kernel drivers shipped via Red Hat (For Red Hat Driver
    Update Program partners)?

No

**\
Networking (Neutron) Component Specific Questions**

1.  Please choose any one of the following options for the type of
    plugin:

-   Monolithic

-   ML2 Driver

> **ML2 Driver chosen**

Network Topology

1.  Which technology is used for network isolation? {For example VLAN,
    Tunneling (GRE/VXLAN}

GRE

1.  Which components does your solution include? (For example
    centralized controller, OVS, Agents, other)

Neutron Server LBaaS Plug-in

LBaaS Agent

1.  Please attach a diagram/file that represents an architectural
    overview of the system: (For example Compute nodes, OpenStack
    controller, Network node, SDN controller)

2.  Which component of the Open vSwitch (OVS) reference implementation
    are you using (if any)? (OVS, ovs-agent, dhcp-agent,
    l3-agent, metadata-agent)

F5 works with OVS. There is no dependency on the agents listed above.

1.  If you are using Open vSwitch, please answer the following
    questions:

-   Are you using OVS -Userspace? If yes which upstream version of OVS
    -Userspace are you using? Are you using a forked version delivered
    by you?

> No.

-   Are you using OVS-Kernel in your solution? If yes, you are dependent
    on which version of OVS-Kernel?

> No specific version. We tested with Kernel 3.10.0-229.1.2.el7.x86_64

Advanced Services/Extensions

1.  Does your solution support LBaaS (Yes/No)?

Yes

1.  Does your solution support VPNaaS (Yes/No)?

No

1.  Does your solution support FWaaS (Yes/No)?

If the answer to any of the above questions is “Yes”, please provide a
brief description of your solution:

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

The F5 LBaaS Agent Driver runs in the F5 Agent. It is responsible for
taking requests from the Agent Manager and, depending on configuration,
either passes it to BIG-IQ or configures the BIG-IP directly.

1.  Is your solution dependant on any specific hardware? (For example
    switch, router, NIC). If so, please specify which hardware is
    required by your solution:

No.

**High Availability Certification with RHEL OpenStack Platform 6.0**

1.  Is your solution fully HA for all the components involved? Please
    describe the recommended HA deployment for your solution:\
    Examples:\
    RHEL OpenStack Platform + Neutron with GRE\
    RHEL OpenStack Platform + your specific drivers\
    RHEL Pacemaker + RHEL OpenStack Platform

Yes, F5 supports running multiple simultaneous Neutron LBaaS plug-ins
and multiple simultaneous LBaaS Agents.

Certification Reference Configuration for the Physical hardware Switches

1.  Arista

2.  Cisco (Nexus and other product lines)

3.  Mellanox

4.  Juniper

N/A

Refer [Red Hat High Availability
Configuration](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Configuring_the_Red_Hat_High_Availability_Add-On_with_Pacemaker/index.html#s1-installation-HAAR) for
more details.

**Sahara Component Specific Questions**

**N/A**

1\. Please specify the Sahara provisioning plugin supported by your
solution:

-   Cloudera Plugin (Cloudera Images in KVM supported format)

-   Hortonworks Data Platform (HDP) Plugin (HDP Cluster Images in KVM
    supported format)

-   MapR Plugin

2\. Please specify the following:

-   Node Group Template:

-   Version Recertification:

-   Security Group API consumption:

Run the Test
------------

Go to the test GUI (browser pointed at <http://first-server>/)

Click Configuration Tab on top.

Add System, use hostname of first server, which you added to /etc/hosts

Click Certifications Tab on top.

Click +OpenStack Certification

Select scratch

When the when page redirects your browser, you may need to put the right
ip address back in the url. This might happen more than once.

Click +System, Click on radio button for the system. Click Test.

Wait a few seconds until you see Continue Testing. Click Continue
Testing

Click Run Interactive. Wait a few seconds.

Answer questions. The openstack info is in the keystonerc_admin file.
Use “admin” for user name.

Select “networking” plugin type.

Type in “load_balancer” (without quotes) for the APIs/Extensions.

Click Submit for the tempest config.

Wait 6 minutes

Describe Environment
--------------------

Red Hat requires that a description of the test environment be included
with the certification results. The following instructions should be
sufficient:

The following is a description of the testing environment that F5 used
to perform the Red Hat Certification tests for the F5 LBaaS (Load
Balancing as a Service) Plugin. F5 uses two machines, each installed
with Red Hat 7.0 minimal ISO installation. Each server was registered,
repositories enabled, and standard packages and updates were applied.

F5 uses the Packstack All-In-One installation method to setup OpenStack.
The All-in-one method was chosen to make running the test simpler. There
is no functional difference between using an All-in-one or a
multi-machine OpenStack installation.

The Packstack answer file should be provided to Red Hat.
(\~/.odk/tmp/Packstack/answers.conf)

The Load Balancer was tested using a BIG-IP Virtual Edition running
within OpenStack. F5 also supports physical hardware, but again, to make
testing simple, the virtual edition was chosen. There is absolutely no
difference in configuration or function between the F5 BIG-IP Virtual
Edition and F5 physical appliances.

The F5 solution consists of two RPM packages that must be installed:

f5-bigip-lbaas-agent-1.0.7-1.noarch.rpm

f5-lbaas-driver-1.0.7-1.noarch.rpm

Install python libraries on the **network gateway host**. The F5 agent
uses suds for iControl/SOAP support:

yum install -y python-suds

Install both RPMs on the **network gateway host**:

rpm –i f5-bigip-lbaas-agent-1.0.7-1.noarch.rpm
f5-lbaas-driver-1.0-7-1.noarch.rpm

Install just the driver rpm on the **neutron server host**.

rpm –i f5-lbaas-driver-1.0.7-1.noarch.rpm

On the **network gateway host**, configure the agent:

vi /etc/neutron/f5-bigip-lbaas-agent.ini

f5_vtep_selfip_name should be selfip.datanet. Set the hostnames and
credentials near the bottom.

Now on the **neutron server host**, add F5 load balancer plug in to
/etc/neutron/neutron.conf:

vi /etc/neutron/neutron.conf

[DEFAULT]

…

service_plugins=neutron.services.l3_router.l3_router_plugin.L3RouterPlugin,neutron.services.firewall.fwaas_plugin.FirewallPlugin,**neutron.services.loadbalancer.plugin.LoadBalancerPlugin**

[service_providers]

…

service_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin_driver.F5PluginDriver

NOTE: If you do not want to use HA proxy, then **append :default to the
end of the service_provider line** above to make F5 the default. Also,
comment out HAProxy from /usr/share/neutron/neutron-dist.conf:

[service_providers]

#service_provider =
LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default

Finally, restart neutron:

systemctl restart neutron-server

Then on the **network gateway host**:

systemctl restart f5-bigip-lbaas-agent

\
ODK Dev NOTEs
=============

Preparing Patches
-----------------

Check-out code using separate instructions.

Then:

odk-set-conf singletons globals dev_mode=true

f5-onboard-set-conf singletons globals dev_mode=true

cd \~/odk/lib/juju

./updatecharms.sh

cd odk-patches/01_ml2_havana/

./applypatches.sh

./makepatches.sh

cd ../02_ml2_network_config/

./applypatches.sh

./makepatches.sh

And so on for all patches in the odk.

Then:

cd \~/f5-onboard/lib/odk-extension/f5-onboard-odk-patches/

cd 01_ve_nova_fix

./applypatches.sh

./makepatches.sh

cd ../02_f5_lbaas

./applypatches.sh

./makepatches.sh

\
Installer Variations
====================

Overview
--------

The various ways that OpenStack is installed can be divided into three
categories. The first is “Vendor Based Distributions”, which are
provided by vendors. You can download and operate these distributions
yourself. The second is “On-Premise Private-Cloud Commercial Services”;
these are clouds which are deployed and managed by a vendor. The third,
“Public Cloud Commercial Services”, are OpenStack clouds operated by a
vendor. Additionally, there is a project for deploying OpenStack that
was built by the OpenStack community.

Vendor-Based Distributions
--------------------------

### Ubuntu OpenStack

#### Juju/MaaS

<http://www.ubuntu.com/cloud/tools/>

<http://www.ubuntu.com/cloud/tools/maas>

<http://www.ubuntu.com/cloud/tools/juju>

### Red Hat RDO

This chart explains all the methods Red Hat uses to install, HOWTO links
for each method, and the status of each install method:

<http://openstack.redhat.com/TestedSetups>

**NOTE:** RDO is the Fedora/Open Source OpenStack and is not supported
by Red Hat.

#### eNovance eDeploy

eNovance is the OpenStack deployment company that Red Hat bought in
Spring 2014 to handle their OpenStack support. eNovance uses a tool
called eDeploy to deploy OpenStack.

<https://github.com/enovance/edeploy>

#### PackStack

<http://openstack.redhat.com/Quickstart>

<http://openstack.redhat.com/RDO_Videos#Installing_OpenStack_with_PackStack_and_RDO>

<http://www.cloudbase.it/rdo-multi-node/>

#### Foreman

<http://openstack.redhat.com/Deploying_RDO_using_Foreman>

#### Triple-O

<http://openstack.redhat.com/Deploying_RDO_Using_Tuskar_And_TripleO>

### Dell

#### Crowbar

<https://github.com/crowbar/crowbar/wiki>

### Mirantis 

#### Fuel

<http://software.mirantis.com/key-related-openstack-projects/project-fuel/>

On-Premise Private-Cloud Commerical Services
--------------------------------------------

### Piston

### Nebula

### CloudScaling

Public Cloud Commercial Services
--------------------------------

### Rackspace Cloud

<http://www.rackspace.com/knowledge_center/article/installing-openstack-with-rackspace-private-cloud-tools>

### HP Cloud

Unknown whether HP has instructions or tools for deploying OpenStack

### IBM SmartCloud

Unknown whether IBM has instructions or tools for deploying OpenStack

OpenStack Projects
------------------

### Dev Stack

<https://github.com/openstack-dev/devstack>

### Triple-O

<https://wiki.openstack.org/wiki/TripleO>
