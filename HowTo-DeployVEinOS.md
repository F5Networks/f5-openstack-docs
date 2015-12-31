---
layout: docs_page
title: How To Deploy BIG-IP VE in an OpenStack Environment
url: {{ page.title | slugify }}
resource: true
---

How To Deploy BIG-IP VE on OpenStack


Overview


This document describes how to deploy BIG-IP Virtual Edition within
OpenStack.

(#before-you-start)Before You Start


Check to make sure you have the following:

1.  A running OpenStack installation (Juno or later) on either Red
    Hat/CentOS 7 or Ubuntu 12.04 / 14.04.

2.  Licensed BIG-IP VE software.

3.  Basic understanding of [OpenStack Networking
    Concepts](add%20link%20to%20doc%20here).

4.  An OpenStack [provider
    network](http://docs.openstack.org/admin-guide-cloud/content/provider_api_workflow.html)
    (if using multi-tenant deployment).


#How to Deploy BIG-IP VE on OpenStack 


#Initial Setup

## Verify that the standard “admin” project, user, and roles are set up: 

    manager@maas-ctrl-4:~$ keystone tenant-get admin
    +-------------+----------------------------------+
    |   Property  |              Value               |
    +-------------+----------------------------------+
    | description |         Created by Juju          |
    |   enabled   |               True               |
    |      id     | 3142ea42fd7c4ba0903f5701f88b1478 |
    |     name    |              admin               |
    +-------------+----------------------------------+

    manager@maas-ctrl-4:~$ keystone user-get admin
    +----------+----------------------------------+
    | Property |              Value               |
    +----------+----------------------------------+
    |  email   |          juju@localhost          |
    | enabled  |               True               |
    |    id    | 44ee559840444916bd02e943894c0a09 |
    |   name   |              admin               |
    | tenantId | 3142ea42fd7c4ba0903f5701f88b1478 |
    | username |              admin               |
    +----------+----------------------------------+

    manager@maas-ctrl-4:~$ keystone user-role-list
    +----------------------------------+----------+----------------------------------+----------------------------------+
    |                id                |   name   |             user_id              |            tenant_id             |
    +----------------------------------+----------+----------------------------------+----------------------------------+
    | 72d7203cdb484a60a635bcdd1b43cf65 |  Admin   | 44ee559840444916bd02e943894c0a09 | 3142ea42fd7c4ba0903f5701f88b1478 |
    | 9fe2ff9ee4384b1894a90878d3e92bab | _member_ | 44ee559840444916bd02e943894c0a09 | 3142ea42fd7c4ba0903f5701f88b1478 |
    +----------------------------------+----------+----------------------------------+----------------------------------+

## Define the Neutron Security Policy 

-   To allow the ICMP protocol:

        neutron security-group-rule-create --protocol icmp \\
            --direction ingress default

-   To assign the standard ports used by BIG-IP (22, 80, and 443):

        neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
        neutron security-group-rule-create --protocol tcp --port-range-min 80 --port-range-max 80 --direction ingress default
        neutron security-group-rule-create --protocol tcp --port-range-min 443 --port-range-max 443 --direction ingress default

-   To allow BIG-IP VE access to VXLAN packets:

        neutron security-group-rule-create --protocol udp --port-range-min 4789 --port-range-max 4789 --direction ingress default

-   To allow BIG-IP VE access to GRE packets:

        neutron security-group-rule-create --protocol 47 --direction ingress default

## Set Up Nova Compute Nodes 

The */etc/nova/release* file must be changed on every Nova compute node
that may run BIG-IP. Otherwise, BIG-IP will not be able to detect that
it’s running on KVM. 

    # echo -e "[Nova]\nvendor = Red Hat\nproduct = Bochs\npackage = RHEL 6.3.0 PC" \ > /etc/nova/release
    #
    # cat /etc/nova/release
    [Nova]
    vendor = Red Hat
    product = Bochs
    package = RHEL 6.3.0 PC

### (#4-restart-the-nova-compute-service)4. Restart the Nova-Compute Service {#4-restart-the-nova-compute-service}

`service nova-compute restart`

(#integrate-big-ip-ve-with-the-openstack-network-infrastructure)Integrate BIG-IP VE with the OpenStack Network Infrastructure
------------------------------

**NOTE:** If you have not yet decided on your integration method, you
should stop here and read the [F5 OpenStack ADC Integration Guide]().


 ~~\#\#\# Single-tenant Deployment~~\
 ~~If you’re using a single-tenant deployment, you can skip this section
and go on to **?**.~~\
 ~~\#\#\# Multi-tenant Deployment~~\
 ~~\#\#\# Base Networking~~\
 ~~The goal of the base networking setup is to create the OpenStack
networks, subnets, and other networking elements that are necessary to
run BIG-IP within OpenStack.~~\
 ~~\#\#\# Admin Router Setup~~\
 ~~If you are working with a proof-of-concept and just have an empty\
 project, these are typical commands that are used to populate an
initial\
 public network attached to a router that can later be attached to\
 private networks that we will create.~~\

~~`neutron router-create admin_router_1 neutron net-create public -- --router:external=True --provider:network_type local  neutron subnet-create --allocation-pool start=10.144.64.92,end=10.144.64.109 --gateway=10.144.64.91 --name public_subnet public 10.144.64.0/24  neutron router-gateway-set admin_router_1 public`~~

## Set Up the Management Network 

This network will be used for the BIG-IP management interface.\

    neutron net-create bigip_mgmt
    neutron subnet-create --name bigip_mgmt_subnet bigip_mgmt 10.10.0.0/24
    neutron router-interface-add admin_router_1 bigip_mgmt_subnet

## Set Up High Availability and Mirroring 

**NOTE:** Skip this step if you’re using a stand-alone BIG-IP.

-   #### (#high-availability-ha)High Availability (HA)

        neutron net-create bigip_ha
        neutron subnet-create --name bigip_ha_subnet bigip_ha 10.40.0.0/24
        neutron router-interface-add admin_router_1 bigip_ha_subnet

-   #### (#mirroring)Mirroring

          neutron net-create bigip\_mirror
          neutron subnet-create --name bigip\_mirror\_subnet bigip\_mirror 10.50.0.0/24
          neutron router-interface-add admin\_router\_1 bigip\_mirror\_subnet

## Set Up External and Internal Networks 

**NOTE:** This step is only required if you’re using BIG-IQ. It may also
be helpful to use as the external side of a load balancing service in a
single-tenant deployment.

-   #### (#external)External

        neutron net-create bigip_external
        neutron subnet-create --name bigip_external_subnet bigip_external 10.20.0.0/24
        neutron router-interface-add admin_router_1 bigip_external_subnet

-   #### (#internal)Internal

        neutron net-create bigip_internal
        neutron subnet-create --name bigip_internal_subnet bigip_internal
        10.30.0.0/24
        neutron router-interface-add admin_router_1 bigip_internal_subnet

**\[jputrino: OUTSIDE OF DOCUMENT SCOPE\]**\
 ~~\#\#\# Data Network~~\
 ~~Now create the data network. See instructions~~\
 ~~For flat Provider Network:~~\

~~`neutron net-create datanet --provider:network_type flat --provider:physical_network physnet-data`~~

~~For VLAN provider network:~~\

~~`neutron net-create datanet --provider:network_type vlan --provider:physical_network physnet-data --provider:segmentation_id 4`~~

~~After creating the network above, create the subnet:~~\

~~`neutron subnet-create --allocation-pool start=10.30.30.200,end=10.30.30.250 --name datanet_subnet datanet 10.30.30.0/24`~~

~~Notice that a higher range of the subnet is used here. The idea is
that\
 IP addresses used for tunneling endpoints on the compute nodes can use
a\
 lower range of the subnet and service VMs like BIG-IP can use a higher\
 range of the subnet. This separation might be necessary if the compute\
 nodes are using static IPs or a different DHCP server.~~

## Create a Nova Custom Flavor for BIG-IP 

We recommend that you define a custom flavor to represent BIG-IP’s
hardware requirements. For example:\
 `flavor_id=\$(cat /proc/sys/kernel/random/uuid)`\
 `nova flavor-create m1.bigip.lbaas.min \$flavor_id 4096 120 2`

## Import the BIG-IP Image to OpenStack 

F5 provides images for [BIG-IP](insert%20link) and
[BIG-IQ](insert%20link) in qcow2 disk format. These can be imported
directly into OpenStack.

### Image Preparation (optional) 

    Image preparation allows you to place a boot script on the image
    before you import it into OpenStack. Both BIG-IP and BIG-IQ will run
    the boot script is immediately upon startup. **The script must be
    named */config/startup*.**\
     **NOTE:** F5 does not recommend creating virtual machines for
    BIG-IP or BIG-IQ with a disk image that has already been booted.\
     **\[INSTRUCTIONS FOR ADDING BOOT SCRIPT TO IMAGE?\]**

### Import the image

    Example using glance:\

        glance image-create --name bigip11.5.2 --is-public true --container-format bare --disk-format qcow2 --file \[your.image.filename\]-OpenStack.qcow2

    \
     **Do not upload the qcow2 zip file that is generated by the
    build**. The qcow2 zip format isn’t compatible with OpenStack.

## Deploy BIG-IP

### Startup Metadata Preparation

    [DevCentral](link?) has onboarding tools that patch a startup script
    into the BIG-IP image.\
     **NOTE:** This software is not officially supported.

###Create an SR-IOV Neutron Port

    If you’re using SR-IOV, create the port BIG-IP will attach to it
    launches:\
     `neutron port-create &lt;net-id&gt; --binding:vnic-type direct`\
     Make note of the id of the port; you’ll need it in the next step.

### Launch a BIG-IP Instance

    To deploy BIG-IP using Horizon, login as the admin tenant and select
    the “admin” project, then click instances, and add an instance.
    Select the BIG-IP image from above as well as the custom flavor, and
    provide the VM with at least 2 networks, 3 if a management VLAN will
    be provisioned.

Using the “nova” command line, use something like:
 for net in
`bigip_mgmt bigip_external bigip_internal datanet bigip_ha bigip_mirror`,
do\

    # this command sets environmental var "id" to the id of the network
    eval `neutron net-show \$net -f shell --fields id\`
    # append nic to list
    nics="\$nics --nic net-id=\$id"
    done
    nova boot --image bigip11.5.2 --flavor m1.bigip.lbaas.min \$nics admin_bigip1

 Wait until the instance becomes active\:
 `nova show admin_bigip1\`

### Create a floating IP from the public network for the BIG-IP. 

    manager@maas-ctrl-1:~$ neutron floatingip-create public
    Created a new floatingip:
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | fixed_ip_address    |                                      |
    | floating_ip_address | 10.144.64.93                         |
    | floating_network_id | 1cb6add9-61a4-40a4-81ab-24295ad5896d |
    | id                  | 36f7b24c-f980-449d-a3c1-e45dd613c639 |
    | port_id             |                                      |
    | router_id           |                                      |
    | status              | DOWN                                 |
    | tenant_id           | 8a7e073f703b4232b126bda16e05f9d7     |
    +---------------------+--------------------------------------+
    manager@maas-ctrl-1:~$ neutron port-list | grep 10.10.0.2
    | 8d98789e-57f9-4013-b2a9-8598ba3bbb43 |      | fa:16:3e:f7:02:f2 | {"subnet_id": "016a23e0-8a6d-4c65-a2d7-bd4bc19d3487", "ip_address": "10.10.0.2"}    |
    manager@maas-ctrl-1:~$ neutron floatingip-associate 36f7b24c-f980-449d-a3c1-e45dd613c639 8d98789e-57f9-4013-b2a9-8598ba3bbb43
    Associated floatingip 36f7b24c-f980-449d-a3c1-e45dd613c639

### Next Steps
-----------------------------------------------------------

Now that you have a BIG-IP installed, you’ll need to configure it. Our
recommended resources for the setup process are listed below.

### DevCentral Community

The DevCentral F5 Onboard package contains a number of tools to ease deployment of BIG-IP and BIG-IQ. These tools can take care of setting passwords, licensing, provisioning, and setting up VLANs and IP addresses, upgrading software, and clustering multiple devices.


(#_1) {#_1}
-----------------------------------------

(#command-design)Command Design
-

These tools are provided in the form of Bash shell wrappers around\
 scripts written in python. The python code uses the REST interface of\
 TMOS. This design was chosen so that they would integrate with
existing\
 shell or python scripts with minimal effort.

### (#commands-for-tmos-openstack)Commands for TMOS - OpenStack {#commands-for-tmos-openstack}

The commands in this section are relevant to getting VE running on\
 OpenStack.

### (#tmos-startup-script-overview)TMOS Startup Script Overview

IP/DHCP, DNS, SSH keys, passwords, Licensing, Module Provisioning

#### (#metadata-format)Metadata Format

{

“bigip”: {

“ssh\_key\_inject”: “false”,

“admin\_password”: “”,

“change\_passwords”: “false”,

“root\_password”: “”,

“license”: {

“basekey”: “U1923-75960-85089-XXXXX-XXXXX”

},

“modules”: {

“auto\_provision”: “false”,

“ltm”: “nominal”,

“gtm”: “minimum”,

“avr”: “none”,

“apm”: “none”,

“afm”: “none”,

“asm”: “none”

},

“network”: {

“dhcp”: “true”,

“selfip\_prefix”: “selfip-dhcp-abc-“,

“vlan\_prefix”: “network-abc-“,

“interfaces”: {

“1.1”: {

“dhcp”: “true”,

“selfip\_allow\_service”: “default”,

“selfip\_name”: “selfip.external”,

“selfip\_description”: “Self IP address for BIG-IP External (VIP)\
 subnet”,

“vlan\_name”: “vlan.external”,

“vlan\_description”: “VLAN for BIG-IP External traffic”

},

“1.2”: {

“dhcp”: “true”,

“selfip\_allow\_service”: “default”,

“selfip\_name”: “selfip.internal”,

“selfip\_description”: “Self IP address for BIG-IP Internal (Pool)\
 subnet”,

“vlan\_name”: “vlan.internal”,

“vlan\_description”: “VLAN for BIG-IP Internal traffic”

},

“1.3”: {

“dhcp”: “true”,

“selfip\_allow\_service”: “default”,

“selfip\_name”: “selfip.datanet”,

“vlan\_name”: “vlan.datanet”,

“vlan\_description”: “VLAN for OpenStack tunneling traffic”

},

“1.4”: {

“dhcp”: “true”,

“selfip\_allow\_service”: “default”,

“selfip\_name”: “selfip.ha”,

“selfip\_description”: “Self IP address for HA subnet”,

“vlan\_name”: “vlan.ha”,

“vlan\_description”: “VLAN for BIG-IP HA traffic”

},

“1.5”: {

“dhcp”: “true”,

“selfip\_allow\_service”: “default”,

“selfip\_name”: “selfip.mirroring”,

“vlan\_name”: “vlan.mirroring”,

“vlan\_description”: “VLAN for BIG-IP Mirroring traffic”

}

}

}

}

}

### (#big-iq-image-patching-for-openstack)BIG-IQ Image Patching for OpenStack

f5-onboard-openstack patch-image |

patch-image-and-hotfix

### (#big-ip-image-patching-for-openstack)BIG-IP Image Patching for OpenStack

f5-onboard-ve-openstack patch-image

The image file name must end with .qcow2

Usage:

sudo env “PATH=\\\$PATH” f5-onboard-ve-openstack patch-image.sh\
 BIGIP-11.5.0.0.0.221.qcow2

f5-onboard-ve-openstack patch-image-and-hotfix

Example Usage:

sudo env “PATH=\\\$PATH” f5-onboard-ve-openstack patch-image-and-hotfix\
 BIGIP-11.5.0.0.0.221.qcow2 base.iso hotfix.iso

### (#deploying-big-iq-ve-on-openstack)Deploying BIG-IQ VE on OpenStack

f5-onboard-openstack deploy-admin-bigiqs |

destroy-admin-bigiqs |

deploy-tenant-bigiqs |

destroy-tenant-bigiqs

### (#deploying-big-ip-ve-on-openstack)Deploying BIG-IP VE on OpenStack

f5-onboard-openstack deploy-admin-bigips |

destroy-admin-bigips |

deploy-tenant-bigips |

destroy-tenant-bigips

f5-onboard-ve-openstack deploy-bigips

–keystone-addr &lt;addr&gt;

–admin-password &lt;pw&gt;

–bigip-image &lt;img&gt;

–ha-type \[ scalen | pair | standalone \]

–num-bigips &lt;num&gt;

–bigip-index &lt;idx&gt; (starting bigip index)

f5-onboard-ve-openstack destroy-bigips

–keystone-addr &lt;addr&gt;

–admin-password &lt;pw&gt;

–num-bigips &lt;num&gt;

–bigip-index &lt;idx&gt; (starting bigip index)

#### (#commands-for-tmos-general)Commands for TMOS - General {#commands-for-tmos-general}

These commands in this section should work with any set of BIG-IPs,\
 whether they are Virtual, Appliance, or vCMP®-based. These commands\
 presume you have already deployed BIG-IP in terms of basic setup and\
 licensing.

If you are using VE, the commands in the next section can help you\
 deploy the BIG-IP from scratch.

### (#upgrading-big-iq-software)Upgrading BIG-IQ Software

### (#upgrading-big-ip-software)Upgrading BIG-IP Software

f5-onboard-upgrade-bigips

–keystone-addr &lt;addr&gt;

–admin-password &lt;pw&gt;

–bigip-image &lt;img&gt;

–num-bigips &lt;num&gt;

### (#clustering-big-ips)Clustering BIG-IPs

f5-onboard-cluster-bigips

–keystone-addr &lt;addr&gt;

–admin-password &lt;pw&gt;

–bigip-image &lt;img&gt;

–ha-type scalen pair standalone

–num-bigips &lt;num&gt;

–bigip-floating-ip-addr-list &lt;list&gt;

–bigip-mgmt-addr-list &lt;list&gt;

–bigip-ha-addr-list’ &lt;list&gt;

–bigip-mirror-addr-list’ &lt;list&gt;

(Lists are comma separated.)

### Commands for TMOS - ODK 

The commands in this section are relevant to getting VE running on\
 OpenStack, but presume that you have used the OpenStack Deployment Kit\
 (ODK) to deploy OpenStack and are using the reference implementation\
 that the ODK deploys. The ODK is an internal F5 testing tool.

A significant difference between the commands in this section and the\
 generic OpenStack commands in the previous section is that the ODK is\
 used to get the keystone address and password. Therefore, you do not\
 need to provide those arguments in the following commands. The ODK is\
 storing your deployment information (in your \\\$HOME/.odk/conf and\
 \\\$HOME/.odk/state directories) so there is no need for you to
provide\
 those settings as arguments to these commands.

f5-onboard-ve-odk attach-bigips-to-vlan-trunk |

deploy-bigips-base |

destroy-bigips-base |

deploy-bigips |

upgrade-bigips |

cluster-bigips |

destroy-bigips

f5-onboard-ve-odk attach-bigips-to-vlan-trunk

No arguments. Uses configured cluster settings.

f5-onboard-ve-odk deploy-bigips-base

–ha-type Which High Availability type to use: standalone, pair, scalen

Default: pair

–bigip-image Which BIG-IP to use

Default: BIGIP-11.5.0.0.0.221-OpenStack.qcow2

f5-onboard-ve-odk destroy-bigips-base

–ha-type Which High Availability type to use: standalone, pair, scalen

Default: pair

–bigip-image Which BIG-IP to use

Default: BIGIP-11.5.0.0.0.221-OpenStack.qcow2

f5-onboard-ve-odk deploy-bigips

–bigip-image Which BIG-IP to use

Default: BIGIP-11.5.0.0.0.221-OpenStack.qcow2

–ha-type Which High Availability type to use: standalone, pair, scalen

Default: pair

–num-bigips Number of big-ips to deploy for scalen mode

Default: 4

–sync-mode Which Synchronization mode to use: replication or autosync

Default: replication

f5-onboard-ve-odk destroy-bigips

No arguments. Uses configured cluster settings.

f5-onboard-ve-odk upgrade-bigips

No arguments. Uses configured cluster settings.

f5-onboard-ve-odk cluster-bigips

No arguments. Uses configured cluster settings.

f5-onboard-lbaas

configure-bigip-plugin | unconfigure-bigip-plugin
