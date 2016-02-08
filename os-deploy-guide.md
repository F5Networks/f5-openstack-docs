---
layout: docs_page
title: How to Deploy an OpenStack Environment Using Packstack
url: 
lbaas-version: 1
openstack-version: kilo
tags: openstack, kilo, red hat 7, centos 7, deploy, install, setup, bare metal, getting started, packstack
---

# Overview

This guide will allow a user who is largely unfamiliar with OpenStack to create an all-in-one, bare metal installation of [OpenStack RDO](https://www.rdoproject.org/). The instructions presented here will guide you through the installation of an operating system and using Packstack to simplify OpenStack deployment.

The information presented here is based on the RDO project [Quickstart guide](https://www.rdoproject.org/install/quickstart/). We've found the RDO documentation set extremely helpful and recommend consulting it for any issues you may encounter.

**WARNING: This guide describes how to deploy OpenStack Kilo. This is an open source project that is continually changing; while the instructions included here worked for us, there is no guarantee they will work exactly the same for you.**

## Prerequisites

Hardware: Machine with at least 4GB RAM, processors with hardware virtualization extensions, and at least one network adapter. For more information, see the [OpenStack Kilo Installation guide](http://docs.openstack.org/kilo/install-guide/install/yum/content/ch_overview.html#example-architecture-with-neutron-networking-hw).

Software: Red Hat Enterprise Linux (RHEL) 7 is the minimum recommended version you can use with OpenStack Kilo. You can also use any of the equivalent versions of RHEL-based Linux distributions (CentOS, Scientific Linux, etc.). x86_64 is currently the only supported architecture.

# Getting Started

First, you need to install an operating system on your hardware. We installed CentOS 7 on one machine, which will serve as the controller, compute, and network nodes (referred to in this document as an 'all-in-one' configuration). An IP address was assigned to the machine automatically via DHCP.

## Users

When installing CentOS, create a root user and a user with administrative priveleges. Our root user has the password 'default'; our admin user is 'manager', with the password 'manager'. In all command blocks shown in this guide, the assumed user is represented by the command prompt symbol:
    
    # = root
    $ = admin

## Disable Network Manager

Once the operating system is installed, you'll need to disable Network Manager. It will be replaced by the standard network service for all interfaces that will be used by OpenStack Networking. 

To verify if Network Manager is enabled:

```
# systemctl status NetworkManager
```

The system displays an error if the Network Manager service is not currently installed:

```
error reading information on service NetworkManager: No such file or directory
```

If you see this error, jump ahead to [Install Software Repositories](#install-software-repositories).

If Network Manager is running, run the following commands to disable it.

```
# systemctl stop NetworkManager
# systemctl disable NetworkManager
# systemctl enable network 
```

## Install Software Repositories

**NOTE:** You can run these commands as root or manager. If you're logged in as manager (the admin user), you will need to use `sudo`.

 -- Update your current software packages:

```
  # yum install update -y
```
 
 --  Install the software package for the OpenStack release of your choice. 
  If you want to use the latest release, run:

```
  # yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
```
  **For this guide we installed the Kilo package** using the command below, because Liberty is the latest release at the time of this doc's creation. 

```
  # yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm
```
If you want to use a different version, see http://rdoproject.org/repos/ for the full listing. 

 -- Install the software package for Packstack.

```
  # yum install -y openstack-packstack`
```

# Deploy OpenStack using Packstack

The quickest and easiest way to deploy OpenStack is via Packstack's `--allinone` option. This sets up a single machine as the controller, compute, and network node. Be aware that this configuration, while fairly simple to execute, is fairly limited. By default, the all-in-one configuration doesn't have Heat and Neutron LBaaS enabled. For this reason, **we don't recommend going with the default `--allinone` deployment**. Instead, you can customize your all-in-one deployment with an answers file.

## Custom Configuration with an Answers File 

Instead of using the `--allinone` flag, we generated an [answers file](f5-onboard_kilo-answers.txt) and edited it to enable the services we want and disable some options we don't want.

**NOTE:** The configurations in our answers file are basically equivalent to running `packstack --os-heat-install=y --os-debug-mode=y --os-neutron-lbaas-install=y --provision-demo=n`.

To generate an answers file (replace '[answers-file]' with the file name of your choice):

```
$ packstack --gen-answer-file=[answers-file].txt 
```

For our custom all-in-one Kilo installation, we changed the following entries in the answers file. You can also customize your admin user account credentials here, if desired.

```
# vi [answers-file].txt
...
# Specify 'y' to install OpenStack Orchestration (heat). ['y', 'n']
CONFIG_HEAT_INSTALL=y
...
# Specify 'y' to install Nagios to monitor OpenStack hosts. Nagios
# provides additional tools for monitoring the OpenStack environment.
# ['y', 'n']
CONFIG_NAGIOS_INSTALL=n
...
# Specify 'y' if you want to run OpenStack services in debug mode;
# otherwise, specify 'n'. ['y', 'n']
CONFIG_DEBUG_MODE=y
...
# Password to use for the Identity service 'admin' user.
CONFIG_KEYSTONE_ADMIN_PW=57a791d9e7d849b4
...
# Specify 'y' to enable the EPEL repository (Extra Packages for
# Enterprise Linux). ['y', 'n']
CONFIG_USE_EPEL=y
...
# Specify 'y' to install OpenStack Networking's Load-Balancing-
# as-a-Service (LBaaS). ['y', 'n']
CONFIG_LBAAS_INSTALL=y
...
# Specify 'y' to provision for demo usage and testing. ['y', 'n']
CONFIG_PROVISION_DEMO=n
...
```

**NOTE:** When you generate an answers file, Packstack automatically includes the IP address of the machine on which the file is generated in the CONTROLLER_HOST, COMPUTE_HOSTS, & NETWORK_HOSTS entries. If you're using additional compute and/or network nodes, you'll need to edit the answers file to add in the IP addresses for those machines. As shown in the example below, multiple values should be comma-separated, without a space in between. 

```
# vi [answers-file].txt
...
# IP address of the server on which to install OpenStack services
# specific to the controller role (for example, API servers or
# dashboard).
CONFIG_CONTROLLER_HOST=[IP_ADDRESS]

# List of IP addresses of the servers on which to install the Compute
# service.
CONFIG_COMPUTE_HOSTS=[IP_ADDRESS],[IP_ADDRESS]

# List of IP addresses of the server on which to install the network
# service such as Compute networking (nova network) or OpenStack
# Networking (neutron).
CONFIG_NETWORK_HOSTS=[IP_ADDRESS],[IP_ADDRESS]
...
```

**NOTE:** You can add more hosts **after** deploying an all-in-one environment. To do so, update the network card names for `CONFIG_NOVA_COMPUTE_PRIVIF` and `CONFIG_NOVA_NETWORK_PRIVIF`; update the IP address for the `COMPUTE_HOSTS` and `NETWORK_HOSTS`; and add the IP address of the host on which you've already run Packstack to the `EXCLUDE_SERVERS` entry. Then, run packstack again from the answer file as shown in the next section. 

```
# Comma-separated list of servers to be excluded from the
# installation. This is helpful if you are running Packstack a second
# time with the same answer file and do not want Packstack to
# overwrite these server's configurations. Leave empty if you do not
# need to exclude any servers.
EXCLUDE_SERVERS=10.190.4.193
...
# Private interface for flat DHCP on the Compute servers.
CONFIG_NOVA_COMPUTE_PRIVIF=enp2s0
...
# Private interface for flat DHCP on the Compute network server.
CONFIG_NOVA_NETWORK_PRIVIF=enp2s0
...
# List of IP addresses of the servers on which to install the Compute
# service.
CONFIG_COMPUTE_HOSTS=10.190.4.195

# List of IP addresses of the server on which to install the network
# service such as Compute networking (nova network) or OpenStack
# Networking (neutron).
CONFIG_NETWORK_HOSTS=10.190.4.195
```

**TIP:** You can find the names of your devices by running:
```
ifconfig | grep '^\S'
```

## Run Packstack 

To deploy OpenStack using your custom answers file:

```
$ packstack --answer-file=[answers-file].txt 
```

The installation can take a while. If all goes well, you should eventually see the following message:

```
**** Installation completed successfully ******

Additional information:
 * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
 * File /root/keystonerc_admin has been created on OpenStack client host 10.190.4.193. To use the command line tools you need to source the file.
 * Copy of keystonerc_admin file has been created for non-root user in /home/manager.
 * To access the OpenStack Dashboard browse to http://10.190.4.193/dashboard.
Please, find your login credentials stored in the keystonerc_admin in your home directory.
 * The installation log file is available at: /var/tmp/packstack/20160121-155701-AyFMdp/openstack-setup.log
 * The generated manifests are available at: /var/tmp/packstack/20160121-155701-AyFMdp/manifests
```

## Configure OpenStack

Congratulations! You now have an OpenStack deployment. Next, you'll need to configure your network, add projects and users, and launch instances. Please see our [OpenStack configuration guide](os-config-guide.md) for instructions.

You can log in to the Horizon dashboard at the URL provided, using the username and password found in *keystonerc_admin*. **If you change your password in Horizon, be sure to update this file with the new password.**

**TIPS:** 
- To use the openstack, nova, neutron, and glance CLI commands, you'll need to source the keystonerc_admin file.
```
$ source keystonerc_admin
```
- You may receive an authentication error when trying to log in to OpenStack Horizon after a session timeout. If this happens, clear your browser's cache and delete all cookies, then try logging in again.





