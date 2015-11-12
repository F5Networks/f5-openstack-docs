---
layout: landing_page
title: OpenStack Demo and Testing Tools
---


#Introduction
============

This document provides instructions alongside a set of tools that will
build a reference implementation of OpenStack, which includes
integration with technology from F5® Networks. Rather than build yet
another installer for OpenStack, the strategy for providing this support
is in the form of automation scripts and enhancements to existing
installers. These scripts are used to continually integrate, deploy, and
test the solution.

Packstack is supported for CentOS and Red Hat. MaaS/Juju is supported
for Ubuntu.

The simplest way to get OpenStack up and running with F5 is to use the
Packstack with the Quick Start instructions. This requires only a single
dedicated machine with an internet connection. This is a good way to get
familiar with OpenStack without setting up a lot of machines and
networking equipment.

After working with the Quick Start deployment, you may decide to deploy
different variations of OpenStack (for example to try a different
network type such as VXLAN instead of the default, which is GRE) or you
may decide to try a more realistic deployment that uses more networks
and machines. You can start simple and try progressively more
complicated and powerful deployments.

The Packstack tool is a good way to deploy and test a specific OpenStack
deployment. If however, you are looking for a more permanent test
harness, which can automatically install OpenStack onto bare metal via
PXE boot, and can run unattended and continuously, then MaaS/Juju is the
appropriate tool. While this is more powerful, it takes much more effort
to set up. MaaS/juju requires a minimum of three physical machines but
Packstack can work with only one. So, if you only have one or two
machines, you must use Packstack.

The big operational difference between the two is that MaaS/Juju uses
IPMI to automatically turn on your machine and then uses DHCP/PXE to
automatically install the operating system onto bare metal, while
Packstack assumes you have already installed the operating system. Since
MaaS can install an operating system, this toolkit can deploy OpenStack
from bare metal in various combinations of configurations in a
completely automated fashion. With the current Packstack process,
however, you will need to install the operating system manually, and
then you can only deploy one configuration of OpenStack via automation.

Near the end of this document, there is also an inventory and
description of the various alternatives that are available for deploying
OpenStack.

--------------
#Packstack

##Overview

Depending on your resources and your goals, you can choose a
configuration which only requires a single machine and a single routable
IP address (see Quick Start), or you can choose to deploy a more
complicated, but more realistic, configuration that includes a Control
Server, a Network gateway, and multiple Compute nodes with separate
networks: VM Data, External Public, and OpenStack management.

In every configuration, some network acts as the “external” or “public”
network. This network will have a range of IP addresses to support the
local / management IP, all the floating IPs for BIG-IP and VM instances,
the gateway IPs for every OpenStack router attached to the external
network, etc.

You can choose a “single-ip” configuration, (which Quick Start uses), in
which all of the public IP addresses mentioned above are configured on
an internal software bridge (specifically, an instance of openvswitch),
and those OpenStack IPs are able to access the outside world through the
use of IP Tables masquerade (source address NAT) rules that utilize the
IP address of the host machine.

Alternatively, you can choose to place the OpenStack public network
“on-the-wire” so to speak. This requires a lot of routable IP addresses.
We recommend acquiring a range that includes at least 24 IP addresses if
you would like to use this configuration.

The following instructions start with the Quick Start configuration as
the default and then describe how you can change your deployment options
to progressively build a more complicated, but more powerful, setup.

## Initial Setup

Once you have chosen the number of machines, install CentOS 7 minimal
ISO (or for Red Hat 7, use the standard DVD) on every machine that will
run Packstack or OpenStack. You can run services on the same machine as
the Packstack machine or separately.

You should set the time zone on the first screen. For bare metal
install -- **which will wipe out your disk drive(s)** -- click the
Installation Destination option and then check the “I would like to make
additional space available” checkbox, click Done in the upper left
corner, and then click “Delete All” and “Reclaim Space”.

Then configure the network. There have been reports of problems with
using DHCP so a static IP address is recommended. IMPORTANT: If you
configure a valid hostname of the form a.b.c (in the lower left corner
of the screen), then the hostname MUST be resolvable via your DNS server
(not just /etc/hosts). If you are unable to configure DNS, then DO NOT
configure a hostname - just leave it as localhost.localdomain.
Alternatively, we have had success with using a hostname in the form a.b
(for example stack1.openstack) without configuring DNS.

After you click the Begin Installation button, our current convention
for test lab scenarios is to configure the root password as “default”,
although that specific password is not required. Also, you should add a
user account named “manager” and our convention is to use a password of
“manager”.

## Red Hat 7

If you are using Red Hat 7 instead of CentOS, you will need a Red Hat
Enterprise Linux Server subscription and RHEL OpenStack Platform
subscription. (Free evals are available for 30 days). You should setup
the subscription and repositories according to the instructions in the
following URL below, but DO NOT RUN packstack (the last step). Also, the
referenced instructions are problematic because it asks you to disable
Network Manager and reboot but it doesn’t mention that you may need to
put your default gateway in /etc/sysconfig/network using the following
syntax before rebooting (or else you will lose connectivity to your
machine):

GATEWAY=1.2.3.254

Here are the Red Hat instructions:

<https://access.redhat.com/products/red-hat-enterprise-linux-openstack-platform/get-started>.

Then continue on to the Quick Start instructions.

## CentOS 6.5 or Red Hat 6.5

These extra steps must be done for 6.5:

-   After installing odk and f5-onboard, copy the lbaas RPMs built for
    6.5 to /usr/lib/f5-onboard/lbaas. (These are only available by
    special request.)

## F5 OnSite Licensing

The quickstart tarball which is available locally onsite at f5 contains
pre-generated Dev licenses assigned to the developer who originally
generated the licenses and create the tarball. You really should
generate your own licenses. See the section named “Get Proper Licenses”
for more information on how to generate and install your own Dev
licenses.

## Offsite Licensing

If you are offsite, you **must** follow the instructions in the section
name “Get Proper Licenses” before following the Quick Start instructions
that follow. Really, everyone should follow those instructions.


#Quick Start Process

If you want to get OpenStack up and running with F5 BIG-IP Virtual
Edition as quickly and easily as possible, using only one machine with
only one IP address, then follow these instructions.

After installing the operating system, login as manager (NOT ROOT) and
then run these commands:

```
$ scp <manager@10.144.65.66:quickstart.tgz> . \# 1 GB file; password:
manager

$ tar xvzf quickstart.tgz

$ su

# rpm -i odk-\*.noarch.rpm f5-onboard-\*.noarch.rpm

# odk-install

# reboot
```
Log back in, then:

```
$ f5-onboard-setup

$ odk-openstack deploy --quickstart
```

This process currently takes about an hour. The output should end with
“TEST PASSED”. If not, something went wrong and you may need to get
help.


#What's Next?

You should now be able to access the OpenStack GUI at your IP address
with a browser using the pathname *http://your-ip-address/dashboard* and
using the credentials in the file *keystonerc\_admin* which is placed in
the current directory.

The Quick Start process does the following:

-   Installs updates and configures repositories for OpenStack and
    packstack packages

-   Applies a few patches for stuff that don’t work

-   Sets up the packstack answer file for how to configure OpenStack

-   Runs packstack to install all OpenStack packages and configure them

-   Sets up IPtables to allow outbound access from the OpenStack
    internal bridge (10.99.0.0/16 on br-ex)

-   Creates an admin project/tenant with initial security settings

-   Creates admin networks to support running BIG-IP.

-   Uploads BIG-IP VE 11.6.0 qcow image file.

-   Creates a instance flavor for BIG-IP

-   Launches a BIG-IP in the admin project, sticking it’s license key in
    metadata

-   BIG-IP get license from metadata and licenses itself on startup

-   Installs the F5 LBaaS plug-in and configures it to use the new
    BIG-IP

-   Creates a proj\_1 project with a network and two VMs on a private
    network each running a web server.

-   Creates a proj\_2 project with a network and two VMs on a private
    network each running a web server.

-   Creates a proj\_3 project with a network and one VM on a private and
    one VM on a shared network, each running a web server.

-   Creates a pool, monitor, and VIP which load balances proj\_1 VMs and
    then tests the VIP

-   Creates a pool, monitor, and VIP which load balances proj\_2 VMs and
    then tests the VIP

-   Creates a pool, monitor, and VIP which load balances proj\_3 VMs and
    then tests the VIP


Get Proper Licenses
-------------------

The Quick Start process “cheats” because it uses pre-generated BIG-IP
licenses. In other words, someone else acquired the Dev license keys
(and used their email address) and you are just “borrowing them”
temporarily. You really should go generate your own licenses (at least
4) and place them, one per line, in the file:

*.f5-onboard/conf/startup.licenses*

This is the kind of license we have been using:

Product Line: BIG-IP

Product: F5-BIG-LTM-VE-5G-LIC-DEV

Options:

Best Bundle, 5gbps

Recycle, VE

**NOTE:** If you are offsite, you MUST do this prior to running the Quick Start.


# Exploring OpenStack


## Explore projects

You can login to the OpenStack dashboard with the following URL
(replacing with your IP address): *http://your-ip-address/dashboard*.

**NOTE:** We’ve had better luck accessing VM remote consoles with Chrome than Internet
Explorer.


You can login into the admin project using the username “admin” and
password from the keystonerc\_admin file which is placed in your local
directory.

Also, you can login as a regular tenant using the username “user\_1” and
password “user\_1” which will log you into the “proj\_1” tenant project.
You can also explore proj\_2 and proj\_3 using credentials “user\_2” and
“user\_3” respectively.

From the command line, you can use the OpenStack CLI by first sourcing
the credentials:

\[manager@pack43 \~\]\$ source keystonerc\_admin

Check out a few commands:

\[manager@pack43 \~(keystone\_admin)\]\$ keystone tenant-list

id |name |enabled 
:------|:------|:------|
ca2d148d2f004029b147084a0e58f69c |admin    | True    
32d4cde8a9c54767883e4a3894373155 |proj\_1  | True    
b2b7599a9ba34292ab1a66a6239fc201 | proj\_2  | True    
4fbf9eddf32c41e28a40beb935e96c35 | proj\_3  | True    
18fc8dbb8d9745429e10224de01a78a3 | services | True    


More commands to try:

```
\[manager@pack43 \~(keystone\_admin)\]\$ keystone user-list

\[manager@pack43 \~(keystone\_admin)\]\$ keystone role-list

\[manager@pack43 \~(keystone\_admin)\]\$ keystone user-role-list

\[manager@pack43 \~(keystone\_admin)\]\$ keystone service-list

\[manager@pack43 \~(keystone\_admin)\]\$ keystone catalog

\[manager@pack43 \~(keystone\_admin)\]\$ nova service-list

\[manager@pack43 \~(keystone\_admin)\]\$ neutron agent-list
```
Check out the Load Balancer Agent (be sure to use the ID listed in the
previous command):

**INSERT TABLE IMAGE HERE**

### Explore Networks and Floating IPs

neutron net-list

neutron net-show &lt;id&gt;

neutron subnet-list

neutron subnet-show &lt;id&gt;

neutron port-list

neutron port-show &lt;id&gt;

neutron floatingip-list

## Explore Flavors, Images, and VMs

nova list

nova show bigip1

nova hypervisor-list

nova hypervisor-servers &lt;hypervisor-hostname&gt;

nova hypervisor-stats

nova image-list

nova flavor-list

nova flavor-show m1.bigip

## Explore Security Rules

neutron security-group-list

neutron security-group-rule-list

We haven’t created a firewall, so the results of these commands will be
empty:

neutron firewall-list

neutron firewall-policy-list

neutron firewall-rule-list

## Explore LBaaS Configuration

neutron help | grep lb-

neutron lb-vip-list

neutron lb-pool-list

neutron lb-member-list

neutron lb-healthmonitor-list

### \
Explore BIG-IP 

The BIG-IP should be available locally at the address 10.99.2.2. (Use
nova list to be sure.) It has default credentials. If you want to access
the BIG-IP GUI from a remote machine, then you will need to manually run
the following IPTables commands on the CentOS host command line:

myif=\`ip route show | grep default | head -n 1 | cut -d' ' -f5\`

myip=\`ip addr show dev \$myif | grep "inet "| cut -d' ' -f6 | cut -d'/'
-f1\`

iptables -t nat -A PREROUTING -i \$myif -p tcp --dport 2443 -d \$myip -m
conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.2:443

If you deployed a second BIG-IP using the option “--ha-type pair” (which
is not the default), then you should also do this for the second BIG-IP:

iptables -t nat -A PREROUTING -i \$myif -p tcp --dport 3443 -d \$myip -m
conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.3:443

### Explore BIG-IP Partitions and LTM Objects

Login to the BIG-IP.

tmsh

list net tunnels

Type: cd /u&lt;tab&gt; … select a folder and press return

list ltm virtuals

list ltm pools

### Explore Tunnel Config

Login to the BIG-IP.

tmsh

list net tunnels

Type: cd /u&lt;tab&gt; … select a folder and press return

list net tunnels

### \
Launch a Nova Instance

curl -O
http://cloud-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img

glance image-create --name Ubuntu-12.04-LTS-OVF --is-public True
--disk-format qcow2 --container-format ovf \\

--file ubuntu-12.04-server-cloudimg-amd64-disk1.img --property
os\_distro=ubuntu

curl -O
http://cloud-images.ubuntu.com/releases/trusty/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img

glance image-create --name Ubuntu-14.04-LTS-OVF --is-public True
--disk-format qcow2 --container-format ovf \\

--file ubuntu-14.04-server-cloudimg-amd64-disk1.img --property
os\_distro=ubuntu

nova keypair-add --pub\_key \~/.ssh/id\_rsa.pub default\_key

nova keypair-list

nova boot my-trusty --flavor m1.small --key\_name default\_key --image
Ubuntu-12.04-LTS-OVF

\
QuickStart Variations
---------------------

You may want to try running PackStack Quick Start process with other
variations in order to explore different configurations. Note that you
cannot re-run packstack so you will need to install CentOS or Red Hat
fresh in order to test another variation.

For example, this will deploy with network type vxlan instead of the
default of gre.

odk-openstack deploy --quickstart --network-type vxlan

Note that options are processes from left to right, so you should place
parameters to the right of “--quickstart” in order for them to override
the quickstart settings properly. The --quickstart option is just a
shortcut for performing these ODK commands:

> odk-set-conf deployments odk-maas ext-net-cidr=10.99.0.0/16
>
> odk-set-conf deployments odk-maas ext-netmask=255.255.0.0
>
> odk-set-conf deployments odk-maas ext-address=10.99.1.1
>
> odk-set-conf deployments odk-maas ext-gateway=10.99.255.254
>
> odk-set-conf deployments odk-maas vnc-proxy-address=10.99.1.1
>
> odk-set-conf deployments odk-maas floating-start=10.99.2.1
>
> odk-set-conf deployments odk-maas floating-end=10.99.2.255
>
> odk-set-conf deployments odk-maas ext-data-net-start=10.99.3.1
>
> odk-set-conf deployments odk-maas ext-data-net-end=10.99.3.255
>
> odk-set-conf deployments odk-maas vlan-range=1400:1429
>
> odk-set-conf deployments odk-maas CONTROL\_HOST=\`hostname -I\`
>
> odk-set-conf deployments odk-maas NETWORK\_HOST=\`hostname -I\`
>
> odk-set-conf deployments odk-maas COMPUTE\_HOST=\`hostname -I\`
>
> odk-openstack deploy --num-machines 1 --network-type gre
> --ext-net-topology combined --data-net-topology combined --ip-strategy
> single --test --no-cleanup

\
Quickstart Diagram
------------------

odk-openstack deploy --num-machines 1 --network-type gre
--ext-net-topology combined --data-net-topology combined --ip-strategy
single --test --no-cleanup

\
No Single-IP Diagram
--------------------

odk-openstack deploy --num-machines 1 --network-type gre
--ext-net-topology combined --data-net-topology combined --test
--no-cleanup

\
Multiple Machines
-----------------

odk-set-conf deployments odk-maas CONTROL\_HOST=10.144.65.43

odk-set-conf deployments odk-maas NETWORK\_HOST=10.144.65.44

odk-set-conf deployments odk-maas COMPUTE\_HOST=10.144.65.45

odk-openstack deploy --network-type gre --ext-net-topology combined
--data-net-topology combined --test --no-cleanup

\
Separate Data Network
---------------------

odk-set-conf deployments odk-maas CONTROL\_HOST=10.144.65.43

odk-set-conf deployments odk-maas NETWORK\_HOST=10.144.65.44

odk-set-conf deployments odk-maas COMPUTE\_HOST=10.144.65.45

odk-openstack deploy --network-type gre --ext-net-topology combined
--test --no-cleanup

\
No Single-IP
------------

odk-set-conf deployments odk-maas CONTROL\_HOST=10.144.65.43

odk-set-conf deployments odk-maas NETWORK\_HOST=10.144.65.44

odk-set-conf deployments odk-maas COMPUTE\_HOST=10.144.65.45

odk-openstack deploy --network-type gre --test --no-cleanup

 <span id="_Toc417462557" class="anchor"></span>PackStack with Multiple
Machines and/or Multiple Networks

This section explains how to create a more advanced configuration than
the quick start process.

The same networks and cabling scheme as MaaS/juju is used. You can
configure a NIC for OpenStack mgmt for all nodes, a NIC for the data
network for the network and compute nodes, and a NIC for the external
network on the network and Packstack controller node. Alternatively, you
can combine those networks into two or just one. Similarly to MaaS/Juju
if you wish to test VLAN based network virtualization, the NICs
connected to the OpenStack Data network should have the switch port that
they are connected to configured for VLAN support.

The Packstack instructions say that in order for Packstack to work
properly, you must provide a host name for each node that is resolvable
in DNS. We used names such as pack-ctrl-4.packstack,
node-services.packstack, node-compute-1.packstack,
node-network.packstack and populate them in the /etc/hosts file on every
host (after install and reboot completes). However, there is no need to
populate the DNS server.

If you are using the two machine configuration, then just use the names
node-network.packstack and node-compute-1.packstack.

After first boot into CentOS or Red Hat, login as root on all machines.

If you need to need to change NIC labels to match their expected usage,
then do so in the /etc/udev/rules.d/70-persistent-net.rules file and
also change corresponding /etc/sysconfig/network-scripts files to match
the correct MAC addresses. **REBOOT** right away if you change udev,
otherwise you’ll have problems if you try to restart the network later.

There are several steps that require restarting network services. You
may want to use a remote IPMI console session to avoid the occasional
lock-up that may occur if you restart the network over an SSH session.

### Configure host names

On all nodes, login as root and edit /etc/hosts to add the hostnames you
will be using, as follows:

vi /etc/hosts

127.0.0.1 localhost localhost.localdomain localhost4
localhost4.localdomain4

::1 localhost localhost.localdomain localhost6 localhost6.localdomain6

10.144.65.34 pack-ctrl-4 pack-ctrl-4.packstack

10.144.65.43 node-services node-services.packstack

10.144.65.44 node-network node-network.packstack

10.144.65.45 node-compute-1 node-compute-1.packstack

### \
Connect Data Network

*If you are using the single machine and single network configuration,
where both data net and external net are combined with the management
network (--data-net-topology combined --ext-net-topology combined), then
**skip this section**.*

If you are using tunneling, Packstack can be told which IP address
should be used for the tunnel endpoint. Packstack utilizes an interface
name, which you configure, in order to determine what IP address to use
for its tunnel endpoint. We recommend that you setup a separate data
network from the OpenStack management network for the tunnel data
network and if you do so, you will need to setup a tunnel IP address
that will communicate via a different physical interface than the one
used for management traffic. There is a complication in that when BIG-IP
virtual edition is used, it uses a “provider network” to access the
tunnel network, and OVS requires a *bridge* to implement the provider
network. Therefore, we need to place the tunnel endpoint on that bridge
so that BIG-IP can access the tunnel network. We would prefer to do this
immediately on the OVS bridge named br-data, which is where the
tunneling IP will ultimately be placed, but OVS is not yet installed and
so we cannot just create it right now. Instead, we will temporarily
place the tunnel endpoint directly on the physical interface so that
Packstack can be told which interface to use.

Therefore, on **both** the network and compute nodes, configure an IP
address on the NIC that will be used for the data network. Be sure to
pick a unique IP for each host and set IPADDR accordingly. Do that in
/etc/sysconfig/network-scripts/ifcfg-eth1 (or whatever NIC you are using
for the data network):

vi /etc/sysconfig/network-scripts/ifcfg-enp4s0f0

HWADDR=00:25:90:CA:A7:EC

TYPE=Ethernet

NAME=enp4s0f0

UUID=7736f978-0519-468f-8436-785e4a568d6e

ONBOOT=yes

BOOTPROTO=static

IPADDR=10.30.30.1

NETMASK=255.255.255.0

\[root@compute/network \~\]\# systemctl restart network

Later, we’ll move the IP address for the data network NIC to br-data
after Packstack creates br-data. For now, you can use the IP to ping the
other peers in order to ensure the data network is working.

### Update Software and Reboot

*The instructions in this section are for CentOS 7 but you can also use
Red Hat 7 with some alterations. First, you will need a Red Hat
Enterprise Linux Server subscription and RHEL OpenStack Platform
subscription. (Free evals are available for 30 days). The instructions
below will basically be the same, with some minor differences. First,
you should setup the subscription and repositories according to the
instructions in the following URL, but DO NOT RUN packstack (the last
step):*
[*https://access.redhat.com/products/red-hat-enterprise-linux-openstack-platform/get-started*](https://access.redhat.com/products/red-hat-enterprise-linux-openstack-platform/get-started)

Copy F5’s OpenStack Deployment Kit and F5 Onboard rpms to
manager@&lt;maas controller&gt;.

On Packstack **(controller) node,** run all of the following commands as
root.

rpm -i odk-0.8.1-1.noarch.rpm

rpm -i f5-onboard-0.8.0-1.noarch.rpm

odk-install

Run the following commands on **all hosts except the controller**. The
odk-install command already does this (and a bit more) for you on the
controller machine.

systemctl disable NetworkManager

echo GATEWAY=10.144.65.62 &gt;&gt; /etc/sysconfig/network

sed -i 's/42, 55, 56/42,/'
/usr/lib/python2.7/site-packages/urlgrabber/grabber.py

yum install -y <https://rdo.fedorapeople.org/rdo-release.rpm>

yum install -y deltarpm

yum update -y

Note: The sed command above fixes a bug in the file grabber that yum
uses. That bug is described here:

<https://bugzilla.redhat.com/show_bug.cgi?id=1099101>

### \
Configure ODK Toolkit

Login to Packstack controller as manager user (pw: manager).

mkdir –p \~/.f5-onboard/images/patched

scp
<manager@10.144.65.66:.f5-onboard/images/patched/BIGIP-11.6.0.0.0.401-OpenStack.qcow2>
\~/.f5-onboard/images/patched

password: manager

Put 4 VE licenses (Best, 5G with Recyclable flag set) in
config/startup.licenses

Run this command:

f5-onboard-setup

Now configure the values to represent the routable IP ranges you have
been allocated. Do not just copy the commands below. Note that the main
difference between this configuration and the Ubuntu/juju/maas
configuration is that you must tell packstack the IP address of each
node to use (CONTROL\_HOST, NETWORK\_HOST, COMPUTE\_HOST). You can set
the CONTROL\_HOST to also be the local packstack node if you want to get
down to three total machines. For the two machine configuration, you
will run packstack on the CONTROL\_HOST and you should set CONTROL\_HOST
and NETWORK\_HOST to the same value.

odk-set-conf deployments odk-maas ext-net-cidr=10.144.64.0/24

odk-set-conf deployments odk-maas ext-address=10.144.64.31

odk-set-conf deployments odk-maas ext-netmask=255.255.255.0

odk-set-conf deployments odk-maas ext-gateway=10.144.64.254

odk-set-conf deployments odk-maas floating-start=10.144.64.32

odk-set-conf deployments odk-maas floating-end=10.144.64.49

odk-set-conf deployments odk-maas vnc-proxy-address=10.144.64.31

odk-set-conf deployments odk-maas vlan-range=1400:1429

odk-set-conf deployments odk-maas ext-port=eno2

odk-set-conf deployments odk-maas data-port=enp4s0f0

odk-set-conf deployments odk-maas deployer=packstack

odk-set-conf deployments odk-maas CONTROL\_HOST=10.144.65.43

odk-set-conf deployments odk-maas NETWORK\_HOST=10.144.65.44

odk-set-conf deployments odk-maas COMPUTE\_HOST=10.144.65.45

### \
Deploy OpenStack

Now log in to the **Packstack controller host**.

Next, you will start the OpenStack deployment script.

If you are using the two machine configuration, then you will have
trouble maintaining a network connection to the script when you change
your default route on the network node (which is where you will be
running the odk and packstack). For this reason, we typically run
odk-openstack deploy in the “**screen**” program, which allows us to
detach the login session, restart the network, reconnect through the
external network, and then resume the session.

su

yum install screen -y

exit

screen –h 200000 –S test

Start the OpenStack deployment:

odk-openstack deploy --network-type gre --test

Alternatively, for a single network topology:

odk-openstack deploy --data-net-topology combined --ext-net-topology
combined --network-type gre --test

After Packstack deploys OpenStack, there are some networking steps that
need to be completed before testing can proceed. There are also steps
required to configure load balancing. These steps are described in the
next sections. You will be prompted to press return when you have
completed them.

The odk-openstack deploy command implements various workarounds to fix
bugs and other shortcomings. A chapter near the end of this section
describes these workarounds in detail.

### \
Finish Network Configuration

*If you are using the single machine and single network configuration,
where both data net and external net are combined with the management
network (--data-net-topology combined --ext-net-topology combined), then
skip the next three sections and proceed directly to the “Single Machine
Fixes” section.*

### Setup Network Bridges on Network Node

On the **network node** only, configure the IP address on the external
network. Do that in /etc/sysconfig/network-scripts/ifcfg-br-ex:

vi /etc/sysconfig/network-scripts/ifcfg-br-ex

\# Contents: (don’t include this line)

DEVICE=br-ex

DEVICETYPE=ovs

TYPE=OVSBridge

BOOTPROTO=static

IPADDR=10.44.64.31

NETMASK=255.255.255.0

ONBOOT=yes

Add the physical interface for the external network to the bridge:

\[root@network \~\]\# vi /etc/sysconfig/network-scripts/ifcfg-eno2

HWADDR=00:25:90:7B:C8:13

NAME=eno2

UUID=eb76065b-8207-467e-8ef6-6be2f633b19b

ONBOOT=yes

DEVICETYPE=ovs

BOOTPROTO=none

TYPE=OVSPort

OVS\_BRIDGE=br-ex

On the network node, now configure the IP address for the data network
which can be used for tunneling. (For configurations where the data
network is not separate, such as single network configurations, skip
this step). We need to do this manually because we asked Packstack to
create this bridge to ensure it gets into the OVS configuration for use
as a provider network (so service VMs can access the tunnel network).
Packstack doesn’t appear to support configuring the tunnel address on a
bridge it creates; perhaps that is not a common scenario.

Be sure to change IPADDR so that there is a unique IP for each host:

\[root@network \~\]\# vi /etc/sysconfig/network-scripts/ifcfg-br-data

ONBOOT=yes

PEERDNS=no

NM\_CONTROLLED=no

NOZEROCONF=yes

DEVICE=br-data

DEVICETYPE=ovs

TYPE=OVSBridge

BOOTPROTO=static

OVSBOOTPROTO=static

IPADDR=10.30.30.1

NETMASK=255.255.255.0

### Change Network Host Default Gateway

In some scenarios, it may be necessary to move the default route on the
**network host** from the management NIC (if you used it to get to the
Internet for updates) to the external network so that VMs can route to
the Internet or the local data center. Presumably, both NICs can have
default gateways, but this has caused problems in our testing that have
not been resolved yet and so we currently just reconfigure the gateway.
You can do this by changing the GATEWAY line in /etc/sysconfig/network
to the default route on the public/external network.

\[root@network \~\]\# vi /etc/sysconfig/network

\[root@network \~\]\# systemctl restart network

We had a problem in CentOS 6.5 when we restarted the network (*and after
we added a NIC to the br-data bridge*) that results in a change to the
OVS Port number of the phy-br-data interface. The OpenFlow rules already
in place are then incorrect because they refer to the wrong port number.
You can see this problem by dumping the ports and rules before and after
restarting the network with these commands:

ovs-ofctl show br-data; ovs-ofctl dump-flows br-data

To be sure the rules are correct, we run this command which will result
in updating the rules:

\[root@network \~\]\# systemctl restart neutron-openvswitch-agent

### \
Compute Node Data Network Bridge

Similar to the Network node, we must configure the tunnel IP address on
the data network bridge.

Be sure to change IPADDR so that there is a unique IP for each host:

\[root@compute \~\]\# vi /etc/sysconfig/network-scripts/ifcfg-br-data

DEVICE=br-data

DEVICETYPE=ovs

TYPE=OVSBridge

BOOTPROTO=static

IPADDR=10.30.30.2

NETMASK=255.255.255.0

ONBOOT=yes

We need to remove the address from the physical interface and put the
interface in the bridge:

\[root@compute \~\]\# vi /etc/sysconfig/network-scripts/ifcfg-enp4s0f0

DEVICE=enp4s0f0

DEVICETYPE=ovs

TYPE=OVSPort

OVS\_BRIDGE=br-data

ONBOOT=yes

BOOTPROTO=none

\[root@compute \~\]\# systemctl restart network

Verify. This should work within 30 seconds or so:

\[root@compute \~\]\# ping 10.30.30.1

\[root@network \~\]\# systemctl restart neutron-openvswitch-agent

### \
Single Machine Fixes

#### IPTables Fix for Single Machine/Network

*If you are using the Single IP configuration then skip this section and
go to the next section.*

If you are using the single machine and single network configuration,
where both data net and external net are combined with the management
network (--data-net-topology combined --ext-net-topology combined), then
there is an additional command which must be run to make that work:

systemctl stop iptables

If this command is not run, then the BIG-IPs will not be able to access
the metadata server and will not be able to retrieve their license. It
would be better to remove the specific IPtables rule that is blocking
the metadata server, instead of turning it off entirely, but the work to
identify the specific rule has not been done. (Frankly, it is not a
priority because the single machine + single network configuration is
not realistic for several reasons and turning off iptables is just a
drop in that bucket.)

#### Single-IP External Bridge and IPTables Configuration

*This section applies ONLY to the Single IP configuration.*

Run this command:

/usr/libexec/odk/openstack/packstack/setup-single-ip.sh

See the section on Work Arounds for details on what this does.

\
LBaaS BIG-IP Preparation
------------------------

Run this command:

/usr/libexec/f5-onboard/lbaas/setup-lbaas.sh

See the Work Around section for details on what this does.

Optional Testing Steps
----------------------

The F5 OpenStack Toolkit provides scripts for deploying OpenStack with
F5 technologies and running tests. To run the tests provided with the
toolkit, run the following steps.

### Optional: Setup Direct Access to Floating IPs for Testing

If you are running tests against the OpenStack deployment and you have
set up a local, non routable network and you need to access that network
from a test client machine, then you should setup an interface on the
test machine to access the floating ip range of the external network of
the OpenStack router/network gateway host. Alternatively, if you can
route to that network, you may not need to setup this interface.

This would be done on the **Packstack controller node**, for example in
/etc/sysconfig/network-scripts/ifcfg-eth2:

DEVICE=eth2

HWADDR=00:25:90:CA:A7:8A

TYPE=Ethernet

UUID=4c99b4c5-86fe-4540-9a7f-765d95bcbc7f

ONBOOT=yes

BOOTPROTO=static

IPADDR=10.144.64.30

NETMASK=255.255.255.0

NAME="System eth2"

systemctl restart network

ping 10.144.64.31 \# the network host external ip.

Ping may take 30 seconds or so to succeed.

\
Automated Workarounds
---------------------

**These workarounds are automatically executed by the appropriate ODK
commands and do not require any action on your part. These workarounds
are described here for informational purposes.**

### PackStack Patch

This patch fixes these problems:

<https://ask.openstack.org/en/question/35705/attempt-of-rdo-aio-install-icehouse-on-centos-7/>

<https://openstack.redhat.com/Workarounds#Could_not_enable_mysqld>

This workaround is implemented by the following script (which is
executed when you ran /usr/libexec/odk/openstack/packstack/install.sh on
the controller):

/usr/libexec/odk/openstack/packstack/patch-packstack.sh

### Allow Security Access to OpenStack API

<https://bugs.launchpad.net/packstack/+bug/1288447>

If you are using a OpenStack client that accesses certain OpenStack API
ports (e.g. 9292 or 9696) from IP addresses that Packstack has not been
told about, then there needs to be an iptables entry to allow access to
those services from any host. If you do not, you will get a “no route to
host” or “max retries” error. This error sounds like a networking
problem but it is actually the result of an administrative security
policy.

The following is done on the **services/control host**:

The following two ACCEPT lines are added before the existing REJECT line
(shown below) in the file:

-A INPUT -p tcp -m multiport --dports 9292 -m comment --comment "001
glance incoming" -j ACCEPT

-A INPUT -p tcp -m multiport --dports 9696 -m comment --comment "002
quantum incoming" -j ACCEPT

-A INPUT -j REJECT --reject-with icmp-host-prohibited

Then this command is run:

service iptables restart

This workaround is implemented by the following script, which is
executed **after** Packstack is launched by odk-openstack deploy:

/usr/libexec/odk/openstack/packstack/open-neutron-ports.sh

### \
Allow Hosts to Forward or Accept Packets

The **network gateway host**, which is responsible for forwarding
packets had an iptables rule that prevents forwarding. This workaround
deletes that rule.

In /etc/sysconfig/iptables, the following line is deleted:

-A FORWARD -j REJECT --reject-with icmp-host-prohibited

Then the following command is run:

service iptables restart

This workaround is implemented by the following script, which is
executed **after** Packstack is launched by odk-openstack deploy:

/usr/libexec/odk/openstack/packstack/allow-gateway-forwarding.sh

### Set Nova Release File

This workaround sets the /etc/nova/release file on the compute node to
this:

\[Nova\]

vendor = Red Hat

product = Bochs

package = RHEL 6.3.0 PC

Then:

systemctl restart openstack-nova-compute

This workaround is implemented by the following script, which is
executed after OpenStack is deployed.

/usr/libexec/f5-onboard/ve/openstack/patch-nova-release.sh

### Single IP Setup

This workaround sets up the br-ex bridge, OVS, and IP tables to operate
with OpenStack with only a single IP address on the host.

This workaround is implemented by the following script, which is
executed after OpenStack is deployed.

/usr/libexec/odk/openstack/packstack/setup-single-ip.sh

The following steps document what you would need to do manually to
accomplish what the script above does.

DO NOT PERFORM THESE STEPS.

On the **network node** only, configure the IP address on the “external”
bridge. You will set it to the same value you have configured for
“ext-address”. Do that in /etc/sysconfig/network-scripts/ifcfg-br-ex:

vi /etc/sysconfig/network-scripts/ifcfg-br-ex

\# Contents: (don’t include this line)

DEVICE=br-ex

DEVICETYPE=ovs

TYPE=OVSBridge

BOOTPROTO=static

IPADDR=10.99.65.38

NETMASK=255.255.255.224

ONBOOT=yes

Then run this command:

systemctl restart network

There seems to be an issue that prevents br-ex from picking up its IP
address. (You can run the “ip addr” command to verify that br-ex has an
IP address). Please **run the command again** to ensure br-ex has an IP
address:

systemctl restart network

In the Single IP configuration, the initial tunnel IP address that
Packstack configures would be the host address because that is what is
available when packstack is run. Now that we have setup the address on
br-ex for OpenStack purposes, we will use that address for tunneling.
(We need to do this because we are supporting the ability for service
VMs (BIG-IP VE) to connect to the tunnel network and they allocate IPs
on that network for that purpose. Since we have only one IP address at
the Host level, there are not enough addresses to allocate to those VMs.
So, we just use the private network, which we already need for
floating-ips, for that purpose.) In order to complete this
configuration, we must redefine the local tunnel address to the private
subnet address.

Change local\_ip in the following file and set it to the same value you
have configured for “ext-address”.

vi /etc/neutron/plugins/openvswitch/ovs\_neutron\_plugin.ini

systemctl restart neutron-openvswitch-agent

If you are using the single machine and single network configuration,
which has both data net and external net combined with the management
network (--data-net-topology combined --ext-net-topology combined), and
you are using the single IP address configuration, then there are
additional commands which must be run to make that work:

iptables -I FORWARD -i br-ex -j ACCEPT

iptables -I FORWARD -o br-ex -j ACCEPT

iptables -N selective-nat -t nat

iptables -t nat -I POSTROUTING -s 10.99.65.32/27 -j selective-nat

iptables -A selective-nat -t nat -s 10.99.65.38/32 -j RETURN

iptables -A selective-nat -t nat ! -d 10.99.65.32/27 -j MASQUERADE

### \
Install F5 LBaaS

This workaround is implemented by the following script, which is
executed after OpenStack is deployed.

/usr/libexec/f5-onboard/lbaas/setup-lbaas.sh

The following steps document what you would need to do manually to
accomplish what the script above does.

DO NOT PERFORM THESE STEPS.

Install python libraries on the **network host**. The F5 agent uses suds
for iControl/SOAP support:

yum install -y python-suds

Install both RPMs on the **network host**:

rpm –i f5-bigip-lbaas-agent-1.0.3-1.noarch.rpm
f5-lbaas-driver-1.0-1.noarch.rpm

Install just the driver rpm on the **control host**.

rpm –i f5-lbaas-driver-1.0.3-1.noarch.rpm

On the **network host**, configure the agent:

vi /etc/neutron/f5-bigip-lbaas-agent.ini

If you used automated VE onboarding and tunneling,
f5\_vtep\_selfip\_name should be selfip.datanet.

If you are using VLANs, f5\_vtep\_folder and f5\_vtep\_selfip\_name
should be “None” (without quotes).

Now on the **services / control (neutron server) host**, add F5 load
balancer plug in to /etc/neutron/neutron.conf:

vi /etc/neutron/neutron.conf

\[DEFAULT\]

…

service\_plugins=neutron.services.l3\_router.l3\_router\_plugin.L3RouterPlugin,neutron.services.firewall.fwaas\_plugin.FirewallPlugin,**neutron.services.loadbalancer.plugin.LoadBalancerPlugin**

\[service\_providers\]

…

service\_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin\_driver.F5PluginDriver

Note: If you do not want to use HA proxy, then **append :default to the
end of the service\_provider line** above to make F5 the default. Also,
comment out HAProxy from /usr/share/neutron/neutron-dist.conf:

\[service\_providers\]

**\#**service\_provider =
LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin\_driver.HaproxyOnHostPluginDriver:default

Finally, restart neutron:

systemctl restart neutron-server

Then on the **network host**:

systemctl restart f5-bigip-lbaas-agent

Packstack does not enable load balancing in the Horizon GUI by default.
To change that, do this on the **services host**:

vi /etc/openstack-dashboard/local\_settings

\# change the bold line below to enable load balancing in the GUI:

OPENSTACK\_NEUTRON\_NETWORK = {

**'enable\_lb': True,**

'enable\_firewall': False,

'enable\_quotas': True,

'enable\_security\_group': True,

'enable\_vpn': False,

\# The profile\_support option is used to detect if an externa lrouter
can be

\# configured via the dashboard. When using specific plugins the

\# profile\_support can be turned on if needed.

'profile\_support': None,

\#'profile\_support': 'cisco',

}

Then:

systemctl restart httpd

\
Known Issues
------------

### Lost Connectivity after Reboot

If you reboot an OpenStack node and have networking trouble, run this
command:

systemctl restart network

Additionally, on the network and compute nodes run this command:

systemctl restart neutron-openvswitch-agent

### \
VLAN Trunk Access Workaround - Alternatives

Note: This issue only applies to the deployment scenario where a special
procedure has been used to grant BIG-IP Virtual Edition running on
OpenStack Nova access to tenant networks via a VLAN trunk.

If a Tap interface corresponding to a VE interface is moved from the
integration bridge (br-int) to the data bridge (br-data) then packets
may have invalid checksums when there is communication between a BIG-IP
VE and a VM on the same Compute Host. Usually the tap interface is moved
to give BIG-IP access to all VLANs. However, these tagged packets appear
to cause problems with checksums.

There are three potential workarounds:

~~*Upgrade the kernel on the Compute Node*~~

~~The underlying problem is associated with the installed 2.6 kernel on
the compute node. Later kernel versions do not have the problem. The
natural solution is to update the kernel to the one that has the
appropriate fix. This is the default workaround which is provided in
previous instructions.~~

~~yum install -y centos-release-xen && yum update -y --disablerepo=\*
--enablerepo=Xen4CentOS kernel && reboot~~

*Dedicate the compute machine to BIG-IP VEs. *

The problem only occurs when BIG-IP VE is talking to tenant VMs on the
same compute host. You would need to create a Nova availability zone
dedicated to BIG-IP VEs and other zone(s) for non- BIG-IP VMs and ensure
that all VMs are deployed to the right compute nodes.

*Dedicate a NIC to BIG-IP VE *

If the packets from the tenant VM go out a real NIC, go to the switch,
and then come back through another NIC dedicated to VE, then the
checksums are OK. The following steps explain how to dedicate a NIC to
BIG-IP VE.

1.  Create a OVS bridge for the BIG-IPs

> ovs-vsctl add-br br-bigips

1.  Add the dedicated NIC to the data network bridge

> ovs-vsctl add-port br-bigips eth3

1.  Add the BIG-IP VE tap interface to the br-bigips bridge instead
    of br-data.

> ovs-vsctl add-port br-bigips tap8369a267-c2

\
MaaS and Juju
=============

Overview
--------

Canonical (the company that distributes Ubuntu) provides tools and
software archives for installing OpenStack. In contrast with the
generality and flexibility of Puppet and Chef, the Canonical tools are
oriented towards installing Ubuntu (using MaaS, which is an acronym for
Metal as a Service.) and then deploying services like OpenStack on top
of Ubuntu (using Juju). CentOS is currently not supported.

At the Atlanta Conference May 2014, Mark Shuttleworth in his recorded
keynote speech stated that MaaS/Juju would support CentOS “in the coming
weeks” but as of April 2015, the status of that support is unclear.

Overview of Networking for OpenStack
------------------------------------

The MaaS / Juju method of installing OpenStack works well with three
physical networks, as described in the following section.

### OpenStack-Mgmt

This network is used for installation and ongoing OpenStack management
and control plane communication between OpenStack services. It must have
routes to the Internet in order to obtain updates. This must be its own
isolated broadcast domain because it will run its own DHCP / PXE server.

### OpenStack-External

This network is used as the public address space that VMs will use (via
NAT) to access the outside world. It must have routes to the PD lab /
Internet in order for the BIG-IP® systems to access the license server.
It does not need to have an isolated broadcast domain (from other
OpenStack instances) because it uses a range of IP addresses and can
co-exist with other instances of OpenStack using other portions of the
IP range.

### OpenStack-Data

This network need not be routable but should be on its own broadcast
domain because we use hardcoded IP addresses for the compute nodes
(10.30.30.1 for the network node, 10.30.30.2 for compute-1, and so on).

### \
Network Diagram

\
Hardware and Networking
-----------------------

### Machine Requirements

Each physical machine MUST have a working IPMI interface or other power
interface supported by MaaS (most Dell machines do). It should function
with 8 GB of RAM, although we are not exactly sure how low memory can go
and still work. For multiple BIG-IPs and VMs you may want more memory.
Some of our machines have 32GB of RAM.

#### Standard

The standard configuration specifies a total of 4 physical machines
which includes the MaaS server (for DHCP and PXE) and 3 OpenStack nodes
(1 Services, 1 network gateway, 1 compute).

#### Recommended

The recommended configuration specifies a total of 5 physical machines
which includes the MaaS server (for DHCP and PXE) and 3 OpenStack nodes
(1 Services, 1 network gateway, 2 compute). It is better to test with
two compute nodes so that you test network traffic between compute
nodes.

#### Minimal:

The minimal configuration for MaaS / juju specifies a total of 3
physical machines which includes the MaaS server (for DHCP and PXE) and
2 OpenStack nodes (1 services+compute, 1 network gateway).

DO NOT USE MORE THAN 2 COMPUTE NODES. IT IS NOT SUPPORTED YET.

### Network IPs and Ports

You will need at least a /27 (32 address) IP network that can access the
Internet for the management / IPMI / DHCP network.

You will need at least 20 addresses on another IP network that can
access the Internet for the Public/External network.

You will also need another data network which need not be routable. This
network will have private IPs (10.30.30.X).

Each machine consumes an IPMI port on the mgmt network.

We’d recommend the MaaS controller have an interface on the external
network (to avoid routing test traffic through PD Lab routers). So,
that’s two ports for the MaaS controller.

The network node needs three network ports: mgmt, external, and data.

Each compute node needs two network ports: mgmt, and data.

For the minimal 1 (maas) 2 (openstack) devices setup that is 6 mgmt net
ports (3 ipmi + 3 mgmt), 2 external net ports, and 2 data net ports.

So, for the standard 1 (maas) 3 (openstack) devices setup that is 8 mgmt
net ports, 2 external net ports, and 2 data net ports.

For the recommended 1 (maas) 4 (openstack) devices setup that is 10 mgmt
net ports, 2 external net ports, and 3 data net ports.

### Procedures

Rack the servers and connect NICs and IPMI cards to the network as
described in the following table. If you are only using 2 OpenStack
machines (+1 controller totals 3), then do not setup the OpenStack
Services machine. Services will be placed on the Compute Node in that
configuration.

  -------------------------------------------------------------------
  Node Type                   Networks
  --------------------------- ---------------------------------------
  MaaS Controller             NIC1 (eth0/em1) to OpenStack-Mgmt
                              
                              NIC2 (eth1/em2) to OpenStack-External

  OpenStack Services Node     IPMI to OpenStack-Mgmt
                              
                              NIC1 (eth0/em1) to OpenStack-Mgmt

  OpenStack Network Node(s)   IPMI to OpenStack-Mgmt
                              
                              NIC1 (eth0/em1) to OpenStack-Mgmt
                              
                              NIC2 (eth1) to OpenStack-Data
                              
                              NIC3 (eth2) to OpenStack-External

  OpenStack Compute Node(s)   IPMI to OpenStack-Mgmt
                              
                              NIC1 (eth0/em1) to OpenStack-Mgmt
                              
                              NIC2 (eth1) to OpenStack-Data
  -------------------------------------------------------------------

Configure all OpenStack nodes for PXE boot (but not the MaaS
Controller).

For the Controller Node(s), the OpenStack API Network will be the same
as the OpenStack-External network. That is a design choice specific to
the Juju OpenStack charms.

There is an important issue you should be aware of with respect to the
names of NICs. The names of NICs in Linux have typically been eth0,
eth1, eth2, etc. There was an issue with this naming strategy: it was
partially based on which NIC came alive first during the boot process.
So, on one boot a NIC would be eth0, and the next boot it would be eth1.
That is not acceptable when there is automation software that is
configured to communicate over a specific NIC (by name). There is a lot
of documentation here which describes how to workaround this issue.

However, recent operating systems such as CentOS 7 and Ubuntu 14 have
adopted a new NIC naming scheme that may be enabled for your hardware
that adopts names related to the hardware location rather than the
previous sequential naming scheme (eth0, eth1, etc). This results in
interesting names such as em1 and eno1 for onboard NICs and p1p2 and
enp4s0f0 for NIC card ports. This “deterministic” naming scheme avoids
the problem describe in the previous paragraph. Unfortunately, even
these latest operating systems will revert to the old naming scheme
*depending on the specific hardware it is running on.* So, you just have
to boot the operating system on the hardware and run “ip link” to see
which naming scheme you have.

If you have the new naming scheme, then you probably will not need to
worry about this issue with NIC reordering and you can skip the section
called “Preseed Udev in MaaS for Nodes with NIC labeling/reordering
issues.

Currently the configuration scheme used by this toolkit assumes the same
NIC name will be present on all network and compute nodes. With this new
naming scheme, that requirement is much more difficult to achieve. In
the future the toolkit should be improved to allow configuring different
NIC names for each machine.

**If your NICs are coming up with the new naming scheme, then you
probably will not have to worry about this issue and can continue to the
next section.**

You MUST use the Linux interface name as shown in the table above for
the OpenStack management network. It may be that the NIC you want to
use, which should be **eth0**, is actually coming up (perhaps only
sometimes) as **eth1** or some other label. Regardless, proceed and
cable the physical NIC you want to use, even if the Linux label is not
correct. Later in this document are instructions about how to override
the default label assigned during installation and force a NIC to be
**eth0** or whatever label you want. The **em1** (or **eno1**) label is
the typical replacement label for use in newer operating systems as
described below.

In order to test VLAN based network virtualization, the NICs connected
to the OpenStack Data network should have their switch port configured
with appropriate tagged VLANs enabled. If it is a Dell switch, for
example, ports (VLAN-&gt;Port Settings in the Dell GUI) should have
their port settings set to **General** access with **AllowAll** selected
to allow both tagged and untagged packets (for GRE and VXLAN testing).
Also the VLAN membership should be changed to add the ports to the VLANs
(VLAN-&gt;VLAN Membership in the GUI). You need to complete these steps
for every port that is participating in the OpenStack Data Network.

In order to test tunnels, you MUST increase the MTU of the data network
switch ports to accommodate VXLAN and NVGRE without reducing the MTU of
guests. We have currently set the MTU of the data net switch ports to
1600 just to be sure.

Warning on the Usage of sudo
----------------------------

In some cases you are instructed to use sudo for certain commands. It is
easy to get in the habit of using sudo all the time or using “sudo su”
or equivalent to always run as root. However, you should only run as
root or use sudo when instructed. Some commands require running as a
regular user and should not be run as root.

\
MaaS Install and Setup
----------------------

### Power Off Old Nodes

If you are reinstalling MaaS to create a fresh new environment, then now
would be a good time to power down all existing nodes on the MaaS DHCP
network. If you use ipmi, the “ipmipower” command is helpful (ipmipower
–h 10.10.1.1 –u root –p manager ---off) The reason to do this is so that
these nodes are not attempting to refresh their DHCP leases with MaaS
while MaaS is still being setup and configured. These DHCP refreshes
could “taint” the process of creating a pristine new environment,
although there is no confirmation that these DHCP refreshes have caused
any problem.

### MaaS Install

Get the 14.04 Ubuntu Server ISO image here:
<http://www.ubuntu.com/download/cloud>

We start here: <https://help.ubuntu.com/14.04/clouddocs/en/Intro.html>
and will attempt to follow the linked documentation and best practices.

Install 14.04 on the MaaS machine. Follow these hints during the
install:

-   Select “Install Ubuntu Server”

-   For host name, we’ve been using names like maas-ctrl-1 or
    maas-ctrl-2 for example.

-   For domain name, use “maas”.

-   Use manager/manager for user name / password

-   No automatic updates

-   Select OpenSSH server

Now install maas and upgrade everything:

> sudo apt-get update -y
>
> sudo apt-get dist-upgrade -y
>
> &lt;Reboot here for new kernel&gt;
>
> sudo apt-get install -y maas

### MaaS Adminstrator Setup

sudo maas-region-admin createsuperuser

\# OUTDATED: sudo maas-region-admin createadmin --username=root
<--email=root@example.com>

When prompted, enter this password: manager

### Import Boot Images

Now, import images:

Go to the maas GUI and login as root/manager:

Next, click on clusters and then click the **Import Boot Images**
button.

This should also work from the command line but the gui is currently
recommended due to the failure of the following command:

maas maas node-groups import-boot-images

Symptoms include an exception in /var/log/maas/celery.log about a
CallProcess and ExternalProcess exceptions when launching
import-pxe-images and speculation that it was a sudoers problem for the
maas user. The gui seems to work. It takes so long, might as well avoid
trouble.

<https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1268713>

This may take well over an hour but if it does not finish within 2
hours, something probably went wrong. An import run on 9/25/2014 took 1
hour and 40 minutes.

You can check status at the following URL (root/manager).

The import is done when the triangle warning icon goes away and a count
of boot images is displayed. Note that it may continue to say that you
still need to initiate the download. Disregard that message. If you want
to reassure yourself that the import is running, then run “top” and you
should see “maas-import-pxe-files” actively running near the top of the
list.

You can proceed to the next few steps without waiting for this to
finish. However, the images must finish importing before you start the
“MaaS Add Nodes” step.

### MaaS Login

Now, get your login key:

sudo maas-region-admin apikey --username root

Note the Existing Doc Bug:

Instructions here are wrong:

<http://maas.ubuntu.com/docs/maascli.html#api-key>

It says do this, which doesn’t work:

\$ maas-region-admin apikey my-username

Log in substituting the appropriate maas ip (which is just the local
address on the maas server) and api key:

maas login maas &lt;api-key&gt;

The previous command creates a profile called “maas”.

### Cluster DHCP Settings

Login to the web interface of MaaS: (root/manager)

Click on the Clusters tab.

Edit Cluster Master by clicking pencil/edit icon:

Click eth0 or em1 (whichever is present, depending on your hardware)
pencil/edit icon

> Now configure the IPs and ranges. The first few IP parameters are for
> the MaaS server itself. The IP range Low and IP Range High are for the
> DHCP range that will be assigned to the OpenStack nodes. This should
> be an unused range of at least 15 addresses on the OpenStack Mgmt
> network.
>
> Management: Change to “Manage DHCP and DNS”
>
> Save Interface

Save Cluster Controller

### DNS

Login to the web interface of MaaS: (root/manager)

Click on the gear icon in the upper right.

Go the Networking Configuration near the bottom.

Change Default domain for new nodes to “maas”.

Configure the upstream DNS to use 172.27.1.1

Save

BUG: maas dns not operational after following install instructions. Juju
commands will fail later and will be accompanied with this error:

ERROR state/api: websocket.Dial wss://node-services.maas:17070/: dial
tcp: lookup node-services.maas: no such host

(Note recently I’ve been running this workaround after the import boot
images process completes, just in case restarting the network might
disrupt that process.)

Workaround:

**RUN THIS COMMAND NOW (before you add nodes):**

sudo vi /etc/network/interfaces

**Add the MaaS default IP as the first entry of dns-nameservers**.

**For the following, use em1 or eth0, whichever is present on your
hardware.**

**RUN THIS COMMAND NOW (before you add nodes):**

sudo service network-interface restart INTERFACE=em1

This may disrupt your current connection, so be prepared to reconnect.

### Get/Set OAuth token

From the command line, generate an SSH key:

ssh-keygen -b 2048 -t rsa

Accept defaults

cat \~/.ssh/id\_rsa.pub

Copy the entire string for the step below.

Login to the web interface of MaaS: (root/manager)

Go to Login Preferences. This is located in the upper right. Click on
“root”.

Click “Add SSH Key”. Paste the string from above. Click Add Key.

If you get an error about invalid SSH public key format, make sure your
copy and paste process didn’t leave an extra carriage return in the
string. It should be one single, long line.

\
MaaS IPMI Bug Workaround
------------------------

Due to the following bug in MaaS, IPMI access configuration will not be
configured properly for certain Dell models (1435, 2970) and perhaps
others:

<https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1321885>

Workaround:

Steps to perform the workaround on the maas server:

sudo vi
/etc/maas/templates/commissioning-user-data/snippets/maas\_ipmi\_autodetect.py

Change this function to comment out the last line as shown:

def apply\_ipmi\_user\_settings(user\_settings):

"""Commit and verify IPMI user settings."""

username = user\_settings\['Username'\]

ipmi\_user\_number = pick\_user\_number(username)

for key, value in user\_settings.iteritems():

bmc\_user\_set(ipmi\_user\_number, key, value)

\#verify\_ipmi\_user\_settings(ipmi\_user\_number, user\_settings)

While you are in this file, you might as well fix another bug.

<https://bugs.launchpad.net/maas/+bug/1312863>

Around line 205, you will need to replace the order that the IPMI
settings are made:

user\_settings = OrderedDict((

('Username', username),

('Password', password),

('Enable\_User', 'Yes'),

('Lan\_Privilege\_Limit', 'Administrator'),

('Lan\_Enable\_IPMI\_Msgs', 'Yes'),

))

Notice the last two lines are reversed.

FYI, MaaS Troubleshooting Tips:

<https://maas.ubuntu.com/docs/troubleshooting.html#debugging-ephemeral-image>

\
MaaS Add Nodes
--------------

Perform the following steps for each node:

Power on the node

After the node boots and runs, it will shut down.

Go to MaaS GUI.

Confirm the device is listed as “Declared”

Click on the device and Edit.

Change the name of the device from auto generated name to a name that
reflects the desired role for the machine. Currently acceptable names
are node-services.maas, node-network.maas and node-compute-N.maas (where
N is a number starting at 1).

Save

Click Save node.

Click Commission node.

The box will automatically turn on, be commissioned, and turn off.

Prep for MaaS Workarounds
-------------------------

In order to automate some workarounds for MaaS and Juju, we’ll need to
install the OpenStack Deployment Kit now.

Copy F5’s OpenStack Deployment Kit (python-odk\_0.8.0-1\_all.deb or
similar filename for other versions) to manager@&lt;maas controller&gt;:
and install it:

sudo dpkg –i python-odk\_0.8.0-1\_all.deb

Preseed Udev in MaaS for Nodes with NIC Labeling/reordering issues
------------------------------------------------------------------

There is a bug in Juju; it creates a bridge and it expects to put eth0
into it. See <https://bugs.launchpad.net/juju-core/+bug/1337091>. Juju
assumes eth0 is your primary DHCP interface, even if the Ubuntu
installer configured a different device or you experience “NIC
reordering”, as described in the next section.

The current version of Juju puts the bridge configuration in
/etc/network/eth0.config. If eth0 is not operational on first boot then
the bridge is not created and containers which subsequently rely on the
existence of br0 will not start. Also, a service running directly on the
machine may not function. For example, on a quantum-gateway the agent
remained in an “installed” state due to this problem.

The “odk-openstack deploy” command implements a workaround for this
problem which ensures that physical NICs always have the same name.

In order to prepare for this workaround, go to the MaaS GUI and “Start”
each node. If Ubuntu does not install, see the next section for possible
disk issues.

After the nodes are installed and running, you will need to retrieve the
network interface udev rules for each node as explained in the following
section. This will be used later to map the NICs to the proper device
name (eth0 or eth1). The rationale for this follows.

### NIC Reordering

As mentioned in the previous section, when you are deploying Ubuntu
12.04 to nodes, you may occasionally find that a node is not
operational. For example, a container on the device may not start. It
may give an errors such as “lxc-start failed” in juju status. The root
cause of the problem may be NIC reordering. What is happening is that
the machine booted from the BIOS via DHCP and PXE, but then when Linux
boots, the interface that did the BIOS PXE boot does not come up with
the usual “eth0” label according to Linux. You may have thought that the
NIC you attached to the DHCP/PXE network would be eth0 but it actually
came up as a different device such as eth1. This can occur because
physical PCI devices can be discovered in different order depending on
which device became operational first and it may vary from boot to boot.

The reason 14.04 *may* not have this issue is that work has been done to
consistently name network interfaces. Instead of Ethernet interface
names such as eth0 and eth1, names may be something like em1 or p1p1
corresponding to on-board management NICs or position on the PCI bus.
However this only applies to certain types of computers. And
unfortunately due to this previously mentioned bug:
<https://bugs.launchpad.net/juju-core/+bug/1337091>, juju and maas
cannot handle the new (consistent) names anyway. However, the odk does
have an “unconventional” workaround that replaces ifup with a shim
script in order to “fix” the networking for now on Ubuntu 14.04.

The solution to the problem described above, in the case of the standard
eth\* naming convention, is to establish udev rules that properly label
the NICs. A “Udev rule” is an entry in a configuration file that says
that a network device with a specific MAC address should get a specific
label such as “eth0”. Udev rules are stored in
/etc/udev/rules.d/70-persistent-net.rules. You should go to each node
and edit the copy of that file to establish the correct mapping of MAC
addresses to NIC names. After changing that file, reboot. You might want
to configure temporary IPs on the nodes to make sure they can reach each
other on all appropriate networks.

Once you have the udev files configured properly, you’ll need to
retrieve them and store them in a directory named
.odk/conf/juju/&lt;distro&gt;/nodes/&lt;nodename&gt; where distro is
“precise” or “trusty”. An example of a valid file is
“.odk/conf/juju/precise/nodes/node-services.maas”. Later, when you run
the “odk-openstack deploy” command to deploy OpenStack, that script will
set up the MaaS installer to apply the changes you have made to the udev
file during the installation process. The way the script works is that
it modifies the installation “preseed” file to run a “late command”
which populate the udev file with the correct content before the
installation completes. Furthermore, the preseed command will populate
/etc/network/interfaces to include the appropriate NIC (eth0) as the
primary DHCP NIC.

From the \~/.odk/conf/juju/&lt;distro&gt; directory, you would do
something like this:

for node in node-services.maas node-network.maas node-compute-1.maas
node-compute-2.maas

do

    mkdir –p nodes/\$node

    scp <ubuntu@$node:/etc/udev/rules.d/70-persistent-net.rules>
    nodes/\$node/

    done

Then, release the nodes. First list them:

    maas maas nodes list | grep -e host -e system\_id

Then, for each node:

    maas maas node release &lt;system\_id&gt;
    

Preseed Install Disk in MaaS Installer for Nodes with Install Issues
--------------------------------------------------------------------

Some nodes may not install Ubuntu automatically because the install
prompts for a disk, usually because the disk it finds with “list-devices
disk” is not the correct one (like a RAID leaf drive before the RAID
driver is loaded to expose the correct device). The installer will stop
and prompt for a drive because the one it determined to use using the
standard preseed rule was incorrect. To fix this, determine the correct
drive (it’s usually /dev/sdb but could be /dev/sdc) and correct the
preseed file as follows. After that, “release” the node from maas (see
previous section) and then finish the instructions from the previous
section (i.e. copy the udev file and release the node).

    sudo cp /etc/maas/preseeds/preseed\_master
    /etc/maas/preseeds/preseed\_master.orig

    cp /etc/maas/preseeds/preseed\_master \~/.odk/conf/juju/

    sudo vi \~/.odk/conf/juju/preseed\_master

Change this line:

    d-i     partman/early\_command string debconf-set partman-auto/disk
    \`list-devices disk | head -n1\`

to this:
{% raw %}
    {{if node.fqdn in {'node-compute-1.maas'} }}
       d-i     partman-auto/disk string /dev/sdb
      {{else}}
       d-i     partman/early\_command string debconf-set partman-auto/disk
        'list-devices disk | head -n1'
    {{endif}}
{% endraw %}

MAAS Add Tags
-------------

In order to identify which machines should be used for certain purposes,
you should tag the nodes.

Create Tags:

    maas maas tags new name="services" comment="services node"

    maas maas tags new name="compute" comment="compute node"

    maas maas tags new name="network" comment="network node"

Get the list of nodes and their system IDs:

    maas maas nodes list | grep -e host -e system\_id

Copy the system Id for the node you want to add a tag to.

    maas maas tag update-nodes &lt;tag&gt; add=&lt;systemID&gt;

Use the system ID from above for &lt;systemID&gt; and use “compute”,
“network”, or “services“ (without quotes) for &lt;tag&gt;

Example:

    manager@maas-ctrl-2:\~\$ maas maas nodes list |grep -e host -e
    system\_id

    "hostname": "node-services.maas",

    "system\_id": "node-daec2766-19ce-11e4-9db0-00188b7f37c1",

    "hostname": "node-network.maas",

    "system\_id": "node-9410b04a-19cf-11e4-b3b1-00188b7f37c1",

    "hostname": "node-compute-1.maas",

    "system\_id": "node-e1e71ebe-1a90-11e4-b3b1-00188b7f37c1",

    manager@maas-ctrl-2:\~\$ maas maas tag update-nodes services
    add=node-daec2766-19ce-11e4-9db0-00188b7f37c1

    {

    "removed": 0,

    "added": 1

    }

    manager@maas-ctrl-2:\~\$ maas maas tag update-nodes network
    add=node-9410b04a-19cf-11e4-b3b1-00188b7f37c1

    {

    "removed": 0,

    "added": 1

    }

    manager@maas-ctrl-2:\~\$ maas maas tag update-nodes compute
    add=node-e1e71ebe-1a90-11e4-b3b1-00188b7f37c1

    {

    "removed": 0,

    "added": 1

    }


MaaS DHCP IP Address Exhaustion
-------------------------------

CLARIFICATION: THIS SECTION IS NOT OPTIONAL.

BUGS:

<https://bugs.launchpad.net/maas/+bug/1314267>

<https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1274499>

<https://bugs.launchpad.net/maas/+bug/1321328>

If MaaS runs out of DHCP addresses, it may reissue IP addresses that are
already in use. This appears to be because it is not clearing the DHCP
leases for destroyed services. However, the lease file should probably
not be cleared for MaaS nodes because maas appears to populate DNS with
DHCP allocated IP addresses and expects those DNS names to work
indefinitely. Ideally, MaaS would allow IP addresses for nodes to be
pinned while allowing leases to be cleared for other services that are
destroyed. A workaround for this is needed in the mean time.

### Create DHCP lease seed file

The workaround is to modify /var/lib/maas/dhcp/dhcp.leases and remove
everything but one host entry and one lease entry for each of your
physical machines. Each lease entry should have a “binding state free”
line. Remove the other state settings that start with “next” or
“rewind”. Also, keep the “server-duid” line.

The deployment scripts will automatically copy the DHCP leases you have
prepared to the existing leases file, overwriting it. It then restarts
the maas dhcp service. To prepare this step, you should copy the
dhcp.leases file to \~/.odk/conf/juju and prepare it as described above.

    cp /var/lib/maas/dhcp/dhcp.leases \~/.odk/conf/juju/

    vi \~/.odk/conf/juju/dhcp.leases


### No password for sudo

The OpenStack deployments scripts will automatically reset the DHCP
lease file by copying the file in \~/.odk/conf/juju to
/var/lib/maas/dhcp. In order to automate this, you will need to remove
the password prompt requirement for sudo. This can be done by adding the
following line to the end of the /etc/sudoers file. Note that this
assumes you trust the manager user to secure their login sessions as
they will be superuser capable without a password prompt no matter how
long their login session exists.

    manager ALL=(ALL) NOPASSWD:ALL


Setup and Run ODK 
------------------

### Configure ODK Settings

Do not run these commands as root.

REPLACE WITH YOUR OWN SETTINGS!!

    odk-set-conf deployments odk-maas ext-net-cidr=10.144.64.0/24

    odk-set-conf deployments odk-maas ext-address=10.144.64.71

    odk-set-conf deployments odk-maas ext-netmask=255.255.255.0

    odk-set-conf deployments odk-maas ext-gateway=10.144.64.254

    odk-set-conf deployments odk-maas floating-start=10.144.64.72

    odk-set-conf deployments odk-maas floating-end=10.144.64.89

    odk-set-conf deployments odk-maas vnc-proxy-address=10.144.64.71

    odk-set-conf deployments odk-maas vlan-range=1200:1229

    odk-set-conf deployments odk-maas ext-port=em2

    odk-set-conf deployments odk-maas ext-port-precise=eth2

    odk-set-conf deployments odk-maas data-port=p1p1

    odk-set-conf deployments odk-maas data-port-precise=eth1

    odk-set-conf deployments odk-maas deployer=juju

    odk-set-conf singletons globals deployer=juju


Configure F5 extensions
-----------------------

    sudo dpkg -i python-f5-onboard\_0.8.0-1\_all.deb

    mkdir -p \~/.f5-onboard/conf

Put VE licenses in file:

    vi \~/.f5-onboard/conf/startup.licenses

    mkdir –p \~/.f5-onboard/images/patched

    scp <manager@10.144.65.130:.f5-onboard/images/patched>/\*
    \~/.f5-onboard/images/patched

    f5-onboard-setup


Run OpenStack Deployment
------------------------

To kick off the automation:

    odk-openstack deploy --test

> This automates deploying each charm individually and creating
> appropriate relationships. The following video shows a similar process
> done manually via the GUI:
>
> <http://www.youtube.com/watch?v=V2H3fat0K5w>

Note that by default `odk-openstack deploy` uses VLANs for network
virtualization. See the Hardware and Networking section for setup
instructions.


Description of F5’s Juju Improvements
-------------------------------------

### Overview

The Juju charms available on LaunchPad have significant limitations.
These limitations are described in this section and F5 workarounds for
some of these limitations are also described.

YOU DO NOT NEED TO DO ANYTHING ABOUT THE ISSUES THAT FOLLOW. THIS
SECTION IS ONLY DESCRIBING WHAT CUSTOMIZATIONS AND WORKAROUNDS HAVE
ALREADY BEEN RESOLVED BY AUTOMATION.

Here is a list of the provided patches:

-   Havana ML2 Support

-   ML2 Network Configuration

-   Networking Setup

-   IP sysctl variables

-   Configure VNC Console Access

-   Icehouse on Precise KVM Fix

-   Duplicate Agents Fix

### Patch: Havana ML2

This patch supports ML2 on Havana as a first-class citizen. The current
charm support for ML2 on Havana is limited.

*Configuration*

    nova-cloud-controller:

    quantum-plugin: ml2

    quantum-gateway:

    plugin: ml2

Also, in this patch, the juju charm executes the following commands due
to the referenced packaging bugs:

(Do not run these commands. This is only describing what the juju charm
does for you)

    apt-get install python-pip

    pip install --upgrade six==1.4.1

<https://bugs.launchpad.net/ubuntu/+source/python-keystoneclient/+bug/1251466>

<https://lists.fedoraproject.org/pipermail/scm-commits/Week-of-Mon-20140310/1205108.html>


### Patch: ML2 Network Configuration

This patch allows a number of ML2 configuration variables to be
specified as juju charm configuration. This allows the charms to support
different network types (e.g. vlan, gre, vxlan), to support bridge
mappings for provider networks, and it allows configuring and setting up
a dedicated VM Data network (for VM to VM traffic).

*Configuration*

    nova-compute0:

    debug: True

    ml2-type-drivers: "flat,local,vlan,gre,vxlan"

    ml2-tenant-network-types: "gre"

    ml2-agent-tunnel-types: "gre"

    ml2-network-vlan-ranges: "physnet-data:1:1000"

    ovs-bridge-mappings: "physnet-data:br-data"

    ovs-local-ip: "10.30.30.2"

    nova-cloud-controller:

    debug: True

    ml2-type-drivers: "flat,local,vlan,gre,vxlan"

    ml2-tenant-network-types: "gre"

    ml2-agent-tunnel-types: "gre"

    ml2-network-vlan-ranges: "physnet-data:1:1000"

    ovs-bridge-mappings: "physnet-data:br-data"

    ovs-local-ip: ""

    quantum-gateway:

    ml2-type-drivers: "flat,local,vlan,gre,vxlan"

    ml2-tenant-network-types: "gre"

    ml2-agent-tunnel-types: "gre"

    ml2-network-vlan-ranges: "physnet-data:1:1000"

    ovs-bridge-mappings: "physnet-data:br-data"

    ovs-local-ip: "10.30.30.1"

    send-arp-for-ha: "3"

Contrary to popular recipes such as
<https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide>, the
stock OpenStack Juju charms configure almost everything on the same
network segment. So, OpenStack management (for example, mysql and
rabbit) traffic runs over the same network as the VM “Data” network
(which is used for intra-VM communication). Also, the OpenStack GUI
(Horizon) and Keystone API endpoints run on that same network. The only
exception is that the Neutron Gateway’s external network address can be
on a separate interface. Even in that case, the stock juju charms do not
support configuring the external network address automatically; it must
be done manually.

There are major limitations to this configuration.

-   First, OpenStack management traffic will compete with VM-to-VM
    traffic for bandwidth.

-   Second, while a tenant would be able to access their VMs through
    floating IPs on a presumably Internet routable network (the
    Neutron-Gateway external network), their access to the OpenStack
    Dashboard or the API endpoints would require access to the same
    network as the OpenStack management network, which presumably should
    not be Internet routable. Frankly, that doesn’t make sense.

F5 has worked around the first limitation by customizing the charms for
Quantum/Neutron and Nova in order to break out the VM Data network onto
a different interface and subnet. The second limitation is not addressed
at this time. Administrators who use these charms will have to find a
way to expose certain endpoints on the OpenStack management network but
not others, presumably with firewall or other traffic management rules.
This is especially challenging with Juju/MaaS because the endpoint IPs
are all provisioned dynamically via DHCP.

### Patch: Networking Setup

This patch allows the juju charms to actually setup networking (create
bridges and configure IP addresses) on OpenStack network and compute
nodes. This patch works well in combination with the previous patch. The
previous patch applies to getting configuration into the OpenStack
configuration files. This patch handles actually setting up the
networking configuration to match what was placed in the configuration
file. Thus, this patch allows you to setup a bridge, for example, while
the previous patch allows you to put that bridge into the right place in
the OpenStack networking configuration so that you can use the bridge
for OpenStack networking.

    nova-compute0:

    ovs-bridge-ports: "br-data:eth1,br-bigips:eth3"

    network-ips: "br-data:10.30.30.2:255.255.255.0"

    nova-compute0:

    ovs-bridge-ports: "br-data:eth1,br-bigips:eth3"

    network-ips:
    "br-ex:10.144.64.71:255.255.255.0:10.144.64.254,br-data:10.30.30.1:255.255.255.0"

### Patch: IP sysctl variables

This sets the following sysctl variables on the network node.

    net.ipv4.ip\_forward=1

    net.ipv4.conf.default.rp\_filter=0

    net.ipv4.conf.all.rp\_filter=0

    net.ipv4.conf.br0.rp\_filter=0

These variables should be set as described in the following link, but
the stock juju charms don’t do it:

<http://docs.openstack.org/havana/install-guide/install/apt/content/neutron-install.dedicated-network-node.html>

There is no configuration for this patch.

### Patch: Configure VNC Console Access

The stock Juju OpenStack charms do not provide remote console access. A
customization has been provided by F5 that allows configuring remove
console access.

*Configuration*

    quantum-gateway:

    vnc-proxy-address: “172.2.12.200”

    nova-compute:

    vnc-proxy-address: “172.2.12.200”

The juju charm installs the following packages on the quantum-gateway:

    novnc nova-consoleauth nova-novncproxy

The quantum-gateway charm modifies /etc/nova/nova.conf on the
quantum-gateway to add the following section:

# Vnc configuration

    novnc\_enabled=true

    novncproxy\_base\_url=http://172.2.12.200:6080/vnc\_auto.html

    novncproxy\_port=6080

    vncserver\_proxyclient\_address=172.2.99.178

    vncserver\_listen=0.0.0.0

    (172.2.12.200 is an example quantum-gateway external network IP.
    172.2.99.178 is an example quantum-gateway host IP)

The nova-compute charm modifies /etc/nova/nova.conf on the nova-compute
node to add the following section:

# Vnc configuration

    novnc\_enabled=true

    novncproxy\_base\_url=http://172.2.12.200:6080/vnc\_auto.html

    novncproxy\_port=6080

    vncserver\_proxyclient\_address=172.2.99.175

    vncserver\_listen=0.0.0.0

    (172.2.12.200 is an example quantum-gateway external network IP;
    172.2.99.175 is an example nova-compute host IP.)

Workaround: VNC Does Not Work in Havana

<https://bugs.launchpad.net/ubuntu/+source/novnc/+bug/1253840>

The VNC patch fixes this by modifying
quantum\_gateway/hooks/quantum\_hooks.py:

    if config('vnc-proxy-address') != '':

    if 'havana' in config('openstack-origin'):

    cmd=\['add-apt-repository', 'cloud-archive:grizzly'\]

    subprocess.check\_call(cmd)

    cmd=\['apt-get', 'update'\]

    subprocess.check\_call(cmd)

    apt\_install(\['websockify=0.3.0-0ubuntu1\~cloud0',

    'python-novnc=2012.2\~20120906+dfsg-0ubuntu4\~cloud0',

    'novnc=2012.2\~20120906+dfsg-0ubuntu4\~cloud0'\],

    \['--force-yes'\], fatal=True)

    else:

    apt\_install(\['novnc','nova-consoleauth','nova-novncproxy'\],

    fatal=True)

    cmd=\['bash', '-c', "sysctl -w net.ipv4.conf.br-ex.rp\_filter=0 &gt;
    /dev/null;" +

    "cat /etc/rc.local | grep rp\_filter &gt; /dev/null || " +

    "(cat /etc/rc.local | sed 's/exit 0/sysctl -w
    net.ipv4.conf.br-ex.rp\_filter=0\\nexit 0/' &gt; /tmp/delme;cat
    /tmp/delme &gt; /etc/rc.local;rm /tmp/delme)"\]


### Patch: Icehouse on Precise KVM Fix

Due to the following bug, KVM is not loaded on Ubuntu 12.04 with the
Icehouse packages.

<https://bugs.launchpad.net/openstack-manuals/+bug/1313975>

This patch modifies the juju charm to perform “modprobe kvm\_intel” or
“modprobe kvm\_amd” appropriate to your architecture.

There is no configuration necessary for this patch.


### Patch: Duplicate Agents Fix

<https://bugs.launchpad.net/neutron/+bug/1254246>

There is a bug that can result in a duplicate entry for an agent in the
agent table. When this is detected the Neutron server throws an
exception which can result in bad behavior, such as aborting updates to
the ovs\_tunnel\_endpoint table, resulting in lost connectivity.

There is no configuration necessary for this patch.


### Appendix: Juju Nova-Compute Scale-Out Strategy

This section describes how we handle the configuration of Juju when
multiple compute nodes are deployed.

A key point to understand about Juju is that Juju configuration files
specify the configuration for a service, which may be composed of
multiple nodes (or units in Juju speak). But Juju does not support
independent configuration for each unit within a service. *Each unit
gets the same configuration\*.* You can use Juju “aliases” to get around
this limitation (see next section).

This limitation on per-unit configuration probably explains why the
stock OpenStack juju charms only work with configurations that work with
one network address. Also, this allows charms that use those
configurations to work in multiple environments like Amazon EC2 which
only have one IP address.

##Footnote:

<https://juju.ubuntu.com/docs/glossary.html>

“Service Unit - A running instance of a given juju Service. Simple
Services may be deployed with a single Service Unit, but it is possible
for an individual Service to have multiple Service Units running in
independent machines. **All Service Units for a given Service will share
the same Charm, the same relations, and the same user-provided
configuration**.”

The workaround for per-unit configuration is the use of Juju aliases.
The following shows the syntax for using Juju aliases.

config.yaml

-----------

nova-compute0:

openstack-origin: "cloud:precise-havana"

rabbit-user: "changeme"

rabbit-vhost: "changeme"

ovs-local-ip: "10.30.30.3"

nova-compute1:

openstack-origin: "cloud:precise-havana"

rabbit-user: "changeme"

rabbit-vhost: "changeme"

ovs-local-ip: "10.30.30.2"

*Example syntax for deploying with aliases*

    juju deploy --config config.yaml nova-compute nova-compute0

    juju deploy --config config.yaml nova-compute nova-compute1



ODK Command Reference
=====================

Manage OpenStack: `odk-openstack`

Manage OpenStack Objects: 

`odk-admin-image`

`odk-admin-tenant`

`odk-user-tenant`

`odk-network`

`odk-provider-network`

`odk-nova-instance`

`odk-floating-ip`

`odk-monitor`

`odk-pool`

`odk-pool-member`

`odk-pool-monitor`

`odk-web-server`

`odk-vip`


odk-openstack
-------------

odk-openstack

`deploy | destroy | check | diagnose`

Sub Command Descriptions:

- deploy: deploy OpenStack on bare metal

- destroy: destroy OpenStack instance

- check: quick diagnostic checks for OpenStack

- diagnose: gather detailed configurations, logs, and diagnostics

- odk-openstack deploy

 --num-machines \[ 2 to N \]

 --distro \[ precise | trusty \]

 --openstack-release \[ havana | icehouse \]

 --neutron-plugin \[ ml2 | ovs \]

 --network-type \[ vlan | gre | vxlan \]

 --lbaas-driver \[ f5 | haproxy | f5,haproxy \]

 --bigip-image \[ e.g BIGIP-11.5.0.0.0.221-OpenStack.qcow2 \]

 --ha-type \[ pair | scalen |standalone \]

 --num-bigips \[ 2, 4, 8 \] \# for scaleN

 --all

 --test


odk-admin-image
---------------

    manager@maas-ctrl-2:\~\$ odk-admin-image -h

    python /usr/lib/python2.7/dist-packages/odk/setup/admin/image.py
    10.144.65.116 --admin-password openstack -h

usage: `image.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]`

    \[--admin-username ADMIN\_USERNAME\]

    \[--admin-password ADMIN\_PASSWORD\] \[--verbose\] \[--sleep SLEEP\]

    \[--check\] \[--clean-up-only\] \[--no-clean-up\] \[--image IMAGE\]

    openstack-api-endpoint

positional arguments:

    openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

    -h, --help show this help message and exit

    --admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

    --admin-username ADMIN\_USERNAME

Admin username (default:admin).

    --admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

    --verbose 
Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--image IMAGE Path to image to import.


odk-admin-tenant 
-----------------

manager@maas-ctrl-2:\~\$ odk-admin-tenant -h

python /usr/lib/python2.7/dist-packages/odk/setup/admin/base.py
10.144.65.116 --admin-password openstack -h

usage: base.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\] \[--sleep SLEEP\]

\[--check\] \[--clean-up-only\] \[--no-clean-up\]

openstack-api-endpoint ext-net-cidr ext-net-gateway-ip

ext-net-allocation-pool-start ext-net-allocation-pool-end

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

ext-net-cidr CIDR for external network (e.g. 192.168.100.0/24).

ext-net-gateway-ip Gateway IP for external network (e.g. 192.168.100.1).

ext-net-allocation-pool-start

Floating IP pool start.

ext-net-allocation-pool-end

Floating IP pool end.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

\
odk-user-tenant 
----------------

manager@maas-ctrl-2:\~\$ odk-user-tenant -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/base.py
10.144.65.116 --admin-password openstack -h

usage: base.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\] \[--sleep SLEEP\]

\[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\] \[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

\
odk-network 
------------

manager@maas-ctrl-2:\~\$ odk-network -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/network.py
10.144.65.116 --admin-password openstack -h

usage: network.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\]

\[--network-index NETWORK\_INDEX\]

\[--network-name NETWORK\_NAME\] \[--shared\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--network-index NETWORK\_INDEX

Network index.

--network-name NETWORK\_NAME

Network name.

--shared Shared network.

odk-provider-network 
---------------------

manager@maas-ctrl-2:\~\$ odk-provider-network -h

python
/usr/lib/python2.7/dist-packages/odk/setup/admin/provider\_network.py
10.144.65.116 --admin-password openstack -h

usage: provider\_network.py \[-h\] \[--admin-tenant-name
ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\]

\[--no-clean-up\] \[--network-name NETWORK\_NAME\]

\[--network-type NETWORK\_TYPE\] --physical-network

PHYSICAL\_NETWORK

\[--segmentation-id SEGMENTATION\_ID\] --subnet-cidr

SUBNET\_CIDR --ip-pool-start IP\_POOL\_START

--ip-pool-end IP\_POOL\_END

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--network-name NETWORK\_NAME

Network name.

--network-type NETWORK\_TYPE

Network type (vlan, gre, vxlan).

--physical-network PHYSICAL\_NETWORK

Physical network as declared in config file.

--segmentation-id SEGMENTATION\_ID

Segmentation id (vlan id, gre key, or vxlan id).

--subnet-cidr SUBNET\_CIDR

Subnet cidr i.e. 10.0.0.0/24

--ip-pool-start IP\_POOL\_START

allocation pool start

--ip-pool-end IP\_POOL\_END

allocation pool end

\
odk-nova-instance
-----------------

manager@maas-ctrl-2:\~\$ odk-nova-instance -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/instance.py
10.144.65.116 --admin-password openstack -h

usage: instance.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\]

\[--network-index NETWORK\_INDEX\]

\[--network-index-list NETWORK\_INDEX\_LIST \[NETWORK\_INDEX\_LIST
...\]\]

\[--network-name NETWORK\_NAME\]

\[--instance-index INSTANCE\_INDEX\] \[--image-name IMAGE\_NAME\]

\[--flavor FLAVOR\]

\[--availability-zone-index AVAILABILITY\_ZONE\_INDEX\]

\[--no-wait-on-state\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--network-index NETWORK\_INDEX

Index of instance management network.

--network-index-list NETWORK\_INDEX\_LIST \[NETWORK\_INDEX\_LIST ...\]

List of networks for the instance.

--network-name NETWORK\_NAME

Network name.

--instance-index INSTANCE\_INDEX

Index of instance.

--image-name IMAGE\_NAME

Image to use when creating instance.

--flavor FLAVOR Flavor to use when creating instance.

--availability-zone-index AVAILABILITY\_ZONE\_INDEX

Availability zone (host aggregate) index.

--no-wait-on-state Do not wait until created instance is active or

deleted instance is removed.

\
odk-floating-ip
---------------

manager@maas-ctrl-2:\~\$ odk-floating-ip -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/floating\_ip.py
10.144.65.116 --admin-password openstack -h

usage: floating\_ip.py \[-h\] \[--admin-tenant-name
ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\]

\[--no-clean-up\] \[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\]

\[--instance-index INSTANCE\_INDEX\]

\[--instance-network-index INSTANCE\_NETWORK\_INDEX\]

\[--instance-subnet-name INSTANCE\_SUBNET\_NAME\]

\[--floating-ip-retry FLOATING\_IP\_RETRY\]

\[--no-test-connectivity\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--instance-index INSTANCE\_INDEX

Index of instance.

--instance-network-index INSTANCE\_NETWORK\_INDEX

Instance network index for floating ip access.

--instance-subnet-name INSTANCE\_SUBNET\_NAME

Instance subnet name (port reference).

--floating-ip-retry FLOATING\_IP\_RETRY

Number of retry attempts for floating ip test

--no-test-connectivity

Do not test newly associated floating ip.

\
odk-monitor 
------------

manager@maas-ctrl-2:\~\$ odk-monitor -h

python /home/manager/odk/bin/../python/odk/setup/tenant/lbaas/monitor.py
10.144.65.146 --admin-password openstack -h

usage: monitor.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

\
odk-pool 
---------

manager@maas-ctrl-2:\~\$ odk-pool -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/lbaas/pool.py
10.144.65.116 --admin-password openstack -h

usage: pool.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\] \[--sleep SLEEP\]

\[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\] \[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\] \[--pool-index POOL\_INDEX\]

\[--pool-network-index POOL\_NETWORK\_INDEX\]

\[--pool-subnet-name POOL\_SUBNET\_NAME\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--pool-index POOL\_INDEX

Load balancer pool index.

--pool-network-index POOL\_NETWORK\_INDEX

Load balancer pool network index.

--pool-subnet-name POOL\_SUBNET\_NAME

Pool subnet name.

\
odk-pool-member 
----------------

manager@maas-ctrl-2:\~\$ odk-pool-member -h

python
/usr/lib/python2.7/dist-packages/odk/setup/tenant/lbaas/pool\_member.py
10.144.65.146 --admin-password openstack -h

usage: pool\_member.py \[-h\] \[--admin-tenant-name
ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\]

\[--no-clean-up\] \[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\] \[--pool-index POOL\_INDEX\]

\[--instance-index INSTANCE\_INDEX\]

\[--instance-network-index INSTANCE\_NETWORK\_INDEX\]

\[--instance-subnet-name INSTANCE\_SUBNET\_NAME\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--pool-index POOL\_INDEX

Load balancer pool index.

--instance-index INSTANCE\_INDEX

Instance index for web server host/pool member.

--instance-network-index INSTANCE\_NETWORK\_INDEX

Instance network index for web server host/pool

member.

--instance-subnet-name INSTANCE\_SUBNET\_NAME

Instance subnet name (port reference) for host/pool

member.

\
odk-pool-monitor 
-----------------

manager@maas-ctrl-2:\~\$ odk-pool-monitor -h

python
/usr/lib/python2.7/dist-packages/odk/setup/tenant/lbaas/pool\_monitor.py
10.144.65.146 --admin-password openstack -h

usage: pool\_monitor.py \[-h\] \[--admin-tenant-name
ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\]

\[--sleep SLEEP\] \[--check\] \[--clean-up-only\]

\[--no-clean-up\] \[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\] \[--pool-index POOL\_INDEX\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--pool-index POOL\_INDEX

Load balancer pool index.

\
odk-web-server 
---------------

manager@maas-ctrl-2:\~\$ odk-web-server -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/web\_server.py
10.144.65.116 --admin-password openstack -h

usage: web\_server.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\]

\[--tenant-name TENANT\_NAME\]

\[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\] \[--verbose\] \[--sleep SLEEP\]

\[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--instance-index INSTANCE\_INDEX\]

\[--web-server-network-index WEB\_SERVER\_NETWORK\_INDEX\]

\[--web-server-subnet-name WEB\_SERVER\_SUBNET\_NAME\]

\[--web-server-instance-nic-id WEB\_SERVER\_INSTANCE\_NIC\_ID\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--instance-index INSTANCE\_INDEX

Instance index for web server host/pool member.

--web-server-network-index WEB\_SERVER\_NETWORK\_INDEX

Instance network index web server will listen on.

--web-server-subnet-name WEB\_SERVER\_SUBNET\_NAME

Instance subnet name (port reference) web server

listen on.

--web-server-instance-nic-id WEB\_SERVER\_INSTANCE\_NIC\_ID

Instance nic index web server will use (e.g. eth&lt;0&gt;)

odk-vip 
--------

manager@maas-ctrl-2:\~\$ odk-vip -h

python /usr/lib/python2.7/dist-packages/odk/setup/tenant/lbaas/vip.py
10.144.65.116 --admin-password openstack -h

usage: vip.py \[-h\] \[--admin-tenant-name ADMIN\_TENANT\_NAME\]

\[--admin-username ADMIN\_USERNAME\]

\[--admin-password ADMIN\_PASSWORD\] \[--verbose\] \[--sleep SLEEP\]

\[--check\] \[--clean-up-only\] \[--no-clean-up\]

\[--tenant-name TENANT\_NAME\] \[--tenant-username TENANT\_USERNAME\]

\[--tenant-password TENANT\_PASSWORD\]

\[--tenant-index TENANT\_INDEX\] \[--pool-index POOL\_INDEX\]

\[--vip-index VIP\_INDEX\] \[--vip-network-index VIP\_NETWORK\_INDEX\]

openstack-api-endpoint

positional arguments:

openstack-api-endpoint

Endpoint for OpenStack API calls.

optional arguments:

-h, --help show this help message and exit

--admin-tenant-name ADMIN\_TENANT\_NAME

Admin tenant name (default:admin).

--admin-username ADMIN\_USERNAME

Admin username (default:admin).

--admin-password ADMIN\_PASSWORD

Admin password (default:openstack).

--verbose Print verbose messages.

--sleep SLEEP Seconds to sleep after CRUD operations.

--check Check CRUD operations.

--clean-up-only Only clean up objects related to this test.

--no-clean-up Do not clean up objects related to this test.

--tenant-name TENANT\_NAME

Tenant name (default:None).

--tenant-username TENANT\_USERNAME

Tenant username (default:None).

--tenant-password TENANT\_PASSWORD

Tenant password (default:None).

--tenant-index TENANT\_INDEX

Tenant index (default:1).

--pool-index POOL\_INDEX

Load balancer pool index.

--vip-index VIP\_INDEX

Load balancer vip index.

--vip-network-index VIP\_NETWORK\_INDEX

Load balancer vip network index.

F5 Onboard
==========

Command Reference
-----------------

F5 Onboard documentation is available separately for the command
reference.

ODK Extension
-------------

The F5 Onboard project also has an extension for the ODK. That extension
contains the following patches.

### F5 Patch: BIG-IP KVM Detection

Creates /etc/nova/release on the compute node:

\[nova\]

vendor = Red Hat

product = Bochs

package = RHEL 6.3.0 PC

There is no configuration for this patch.

### F5 Patch: LBaaS Configuration and Bug Fixes

*Workaround: Neutron LBaaS Setup Instructions Wrong*

These instructions are wrong:

<https://wiki.openstack.org/wiki/Neutron/LBaaS/HowToRun>

Bug:

<https://bugs.launchpad.net/openstack-manuals/+bug/1257210>

For neutron, we do this instead:

\[DEFAULT\]

service\_plugins =
neutron.services.loadbalancer.plugin.LoadBalancerPlugin

\[service\_providers\]

service\_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin\_driver.HaproxyOnHostPluginDriver:default

We comment out the signing\_dir, otherwise a mysterious exception occurs
on the controller in /var/log/neutron/server.log.

\[keystone\_authtoken\]

\# signing\_dir = \$state\_path/keystone-signing

*Workaround: Neutron Exception Deleting VIP*

On Nova Cloud Controller:

/var/log/neutron/server.log:

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource Traceback
(most recent call last):

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/api/v2/resource.py", line 87,
in resource

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource result =
method(request=request, \*\*args)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/api/v2/base.py", line 287, in
index

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource return
self.\_items(request, True, parent\_id)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/api/v2/base.py", line 236, in
\_items

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource obj\_list =
obj\_getter(request.context, \*\*kwargs)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/db/loadbalancer/loadbalancer\_db.py",
line 476, in get\_vips

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource
filters=filters, fields=fields)

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/db/db\_base\_plugin\_v2.py",
line 197, in \_get\_collection

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource items =
\[dict\_func(c, fields) for c in query\]

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource File
"/usr/lib/python2.7/dist-packages/neutron/db/loadbalancer/loadbalancer\_db.py",
line 238, in \_make\_vip\_dict

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource fixed\_ip =
(vip.port.fixed\_ips or \[{}\])\[0\]

2014-08-08 22:57:56.845 13921 TRACE neutron.api.v2.resource
AttributeError: 'NoneType' object has no attribute 'fixed\_ips'

There is a patch for this in the ODK extension provided by the F5
Onboard package.

\
OpenStack Troubleshooting
=========================

### Check Horizon Dashboard

juju status openstack-dashboard/0

Using the address listed from the command above, open a browser and
check on it:

[http://172.2.99.192/horizon](http://172.27.99.192/horizon) (User admin,
pass openstack)

(User and password were set by Juju deployment config file.)

### Checking OpenStack Networking Status

maas-ctrl\$ cd

maas-ctrl\$ odk\_creds &gt; creds.sh

maas-ctrl\$ odk\_qg\_scp creds.sh

maas-ctrl\$ odk\_qg

quantum-gateway\$ source creds.sh

quantum-gateway\$ neutron agent-list

+--------------------------------------+--------------------+--------------------+-------+----------------+

| id | agent\_type | host | alive | admin\_state\_up |

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

ovsdb-client dump | grep -e iface-id -e admin\_state | cut
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

Note that while the ODK is running, you can setup the second server.
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

max\_namespaces\_per\_tenant = 5

systemctl restart f5-bigip-lbaas-agent

source keystonerc\_admin

keystone role-create --name Member

keystone user-role-list

keystone tenant-list

keystone user-role-add --user &lt;admin id&gt; --role &lt;admin role
id&gt; --tenant &lt;proj\_1 id&gt;

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
    deployment controller node? (**Note**: The hostname will be the same
    since you are expected to run Red Hat Certification back-end server
    and your OpenStack deployment which is under test on the
    same machine)

pack13.openstack

(Note: Not a public DNS name)

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

> No specific version. We tested with Kernel 3.10.0-229.1.2.el7.x86\_64

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

Answer questions. The openstack info is in the keystonerc\_admin file.
Use “admin” for user name.

Select “networking” plugin type.

Type in “load\_balancer” (without quotes) for the APIs/Extensions.

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

The packstack answer file should be provided to Red Hat.
(\~/.odk/tmp/packstack/answers.conf)

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

f5\_vtep\_selfip\_name should be selfip.datanet. Set the hostnames and
credentials near the bottom.

Now on the **neutron server host**, add F5 load balancer plug in to
/etc/neutron/neutron.conf:

vi /etc/neutron/neutron.conf

\[DEFAULT\]

…

service\_plugins=neutron.services.l3\_router.l3\_router\_plugin.L3RouterPlugin,neutron.services.firewall.fwaas\_plugin.FirewallPlugin,**neutron.services.loadbalancer.plugin.LoadBalancerPlugin**

\[service\_providers\]

…

service\_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin\_driver.F5PluginDriver

Note: If you do not want to use HA proxy, then **append :default to the
end of the service\_provider line** above to make F5 the default. Also,
comment out HAProxy from /usr/share/neutron/neutron-dist.conf:

\[service\_providers\]

**\#**service\_provider =
LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin\_driver.HaproxyOnHostPluginDriver:default

Finally, restart neutron:

systemctl restart neutron-server

Then on the **network gateway host**:

systemctl restart f5-bigip-lbaas-agent

\
ODK Dev Notes
=============

Preparing Patches
-----------------

Check-out code using separate instructions.

Then:

odk-set-conf singletons globals dev\_mode=true

f5-onboard-set-conf singletons globals dev\_mode=true

cd \~/odk/lib/juju

./updatecharms.sh

cd odk-patches/01\_ml2\_havana/

./applypatches.sh

./makepatches.sh

cd ../02\_ml2\_network\_config/

./applypatches.sh

./makepatches.sh

And so on for all patches in the odk.

Then:

cd \~/f5-onboard/lib/odk-extension/f5-onboard-odk-patches/

cd 01\_ve\_nova\_fix

./applypatches.sh

./makepatches.sh

cd ../02\_f5\_lbaas

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

### RedHat RDO

This chart explains all the methods Red Hat uses to install, HOWTO links
for each method, and the status of each install method:

<http://openstack.redhat.com/TestedSetups>

**Note:** RDO is the Fedora/Open Source OpenStack and is not supported
by Red Hat.

#### eNovance eDeploy

eNovance is the OpenStack deployment company that RedHat bought in
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
