[<span class="headeranchor"></span>](#how-to-deploy-big-ip-ve-on-openstack)How To Deploy BIG-IP VE on OpenStack
===============================================================================================================

[<span class="headeranchor"></span>](#overview)Overview
=======================================================

This document describes how to deploy BIG-IP Virtual Edition within
OpenStack.

[<span class="headeranchor"></span>](#before-you-start)Before You Start
=======================================================================

Check to make sure you have the following:

1.  A running OpenStack installation (Juno or later) on either Red
    Hat/CentOS 7 or Ubuntu 12.04 / 14.04.

2.  Licensed BIG-IP VE software.

3.  Basic understanding of [OpenStack Networking
    Concepts](add%20link%20to%20doc%20here).

4.  An OpenStack [provider
    network](http://docs.openstack.org/admin-guide-cloud/content/provider_api_workflow.html)
    (if using multi-tenant deployment).

5.  

[<span class="headeranchor"></span>](#how-to-deploy-big-ip-ve-on-openstack_1)How to Deploy BIG-IP VE on OpenStack {#how-to-deploy-big-ip-ve-on-openstack_1}
=================================================================================================================

[<span class="headeranchor"></span>](#initial-setup)Initial Setup
-----------------------------------------------------------------

### [<span class="headeranchor"></span>](#1-verify-that-the-standard-admin-project-user-and-roles-are-set-up)1. Verify that the standard “admin” project, user, and roles are set up: {#1-verify-that-the-standard-admin-project-user-and-roles-are-set-up}

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

### [<span class="headeranchor"></span>](#2-define-the-neutron-security-policy)2. Define the Neutron Security Policy {#2-define-the-neutron-security-policy}

-   To allow the ICMP protocol:\

        neutron security-group-rule-create --protocol icmp \\
            --direction ingress default

-   To assign the standard ports used by BIG-IP (22, 80, and 443):\

        neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
        neutron security-group-rule-create --protocol tcp --port-range-min 80 --port-range-max 80 --direction ingress default
        neutron security-group-rule-create --protocol tcp --port-range-min 443 --port-range-max 443 --direction ingress default

-   To allow BIG-IP VE access to VXLAN packets:\

        neutron security-group-rule-create --protocol udp --port-range-min 4789 --port-range-max 4789 --direction ingress default

-   To allow BIG-IP VE access to GRE packets:\

        neutron security-group-rule-create --protocol 47 --direction ingress default

### [<span class="headeranchor"></span>](#3-set-up-nova-compute-nodes)3. Set Up Nova Compute Nodes {#3-set-up-nova-compute-nodes}

The */etc/nova/release* file must be changed on every Nova compute node
that may run BIG-IP. Otherwise, BIG-IP will not be able to detect that
it’s running on KVM. **\[jputrino: IS THIS STILL TRUE??\]**

    # echo -e "[Nova]\nvendor = Red Hat\nproduct = Bochs\npackage = RHEL 6.3.0 PC" \ > /etc/nova/release
    #
    # cat /etc/nova/release
    [Nova]
    vendor = Red Hat
    product = Bochs
    package = RHEL 6.3.0 PC

### [<span class="headeranchor"></span>](#4-restart-the-nova-compute-service)4. Restart the Nova-Compute Service {#4-restart-the-nova-compute-service}

`service nova-compute restart`

[<span class="headeranchor"></span>](#integrate-big-ip-ve-with-the-openstack-network-infrastructure)Integrate BIG-IP VE with the OpenStack Network Infrastructure
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

**NOTE:** If you have not yet decided on your integration method, you
should stop here and read the [F5 OpenStack ADC Integration Guide]().

**\[jputrino: OUTSIDE OF DOCUMENT SCOPE\]**\
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

### [<span class="headeranchor"></span>](#1-set-up-the-management-network)1. Set Up the Management Network {#1-set-up-the-management-network}

This network will be used for the BIG-IP management interface.\

    neutron net-create bigip_mgmt
    neutron subnet-create --name bigip_mgmt_subnet bigip_mgmt 10.10.0.0/24
    neutron router-interface-add admin_router_1 bigip_mgmt_subnet

### [<span class="headeranchor"></span>](#2-set-up-high-availability-and-mirroring)2. Set Up High Availability and Mirroring {#2-set-up-high-availability-and-mirroring}

**NOTE:** Skip this step if you’re using a stand-alone BIG-IP.

-   #### [<span class="headeranchor"></span>](#high-availability-ha)High Availability (HA)

        neutron net-create bigip_ha
        neutron subnet-create --name bigip_ha_subnet bigip_ha 10.40.0.0/24
        neutron router-interface-add admin_router_1 bigip_ha_subnet

-   #### [<span class="headeranchor"></span>](#mirroring)Mirroring

          neutron net-create bigip\_mirror
          neutron subnet-create --name bigip\_mirror\_subnet bigip\_mirror 10.50.0.0/24
          neutron router-interface-add admin\_router\_1 bigip\_mirror\_subnet

### [<span class="headeranchor"></span>](#3-set-up-external-and-internal-networks)3. Set Up External and Internal Networks {#3-set-up-external-and-internal-networks}

**NOTE:** This step is only required if you’re using BIG-IQ. It may also
be helpful to use as the external side of a load balancing service in a
single-tenant deployment.

-   #### [<span class="headeranchor"></span>](#external)External

        neutron net-create bigip_external
        neutron subnet-create --name bigip_external_subnet bigip_external 10.20.0.0/24
        neutron router-interface-add admin_router_1 bigip_external_subnet

-   #### [<span class="headeranchor"></span>](#internal)Internal

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

### [<span class="headeranchor"></span>](#4-create-a-nova-custom-flavor-for-big-ip)4. Create a Nova Custom Flavor for BIG-IP {#4-create-a-nova-custom-flavor-for-big-ip}

We recommend that you define a custom flavor to represent BIG-IP’s
hardware requirements. For example:\
 `flavor_id=\$(cat /proc/sys/kernel/random/uuid)`\
 `nova flavor-create m1.bigip.lbaas.min \$flavor_id 4096 120 2`

### [<span class="headeranchor"></span>](#5-import-the-big-ip-image-to-openstack)5. Import the BIG-IP Image to OpenStack {#5-import-the-big-ip-image-to-openstack}

F5 provides images for [BIG-IP](insert%20link) and
[BIG-IQ](insert%20link) in qcow2 disk format. These can be imported
directly into OpenStack.

-   #### [<span class="headeranchor"></span>](#image-preparation-40optional41)Image Preparation (optional) {#image-preparation-40optional41}

    Image preparation allows you to place a boot script on the image
    before you import it into OpenStack. Both BIG-IP and BIG-IQ will run
    the boot script is immediately upon startup. **The script must be
    named */config/startup*.**\
     **NOTE:** F5 does not recommend creating virtual machines for
    BIG-IP or BIG-IQ with a disk image that has already been booted.\
     **\[INSTRUCTIONS FOR ADDING BOOT SCRIPT TO IMAGE?\]**

-   #### [<span class="headeranchor"></span>](#import-the-image)Import the image

    Example using glance:\

        glance image-create --name bigip11.5.2 --is-public true --container-format bare --disk-format qcow2 --file \[your.image.filename\]-OpenStack.qcow2

    \
     **Do not upload the qcow2 zip file that is generated by the
    build**. The qcow2 zip format isn’t compatible with OpenStack.

### [<span class="headeranchor"></span>](#6-deploy-big-ip)6. Deploy BIG-IP {#6-deploy-big-ip}

-   #### [<span class="headeranchor"></span>](#startup-metadata-preparation)Startup Metadata Preparation

    [DevCentral](link?) has onboarding tools that patch a startup script
    into the BIG-IP image.\
     **NOTE:** This software is not officially supported.

-   #### [<span class="headeranchor"></span>](#create-an-sr-iov-neutron-port)Create an SR-IOV Neutron Port

    If you’re using SR-IOV, create the port BIG-IP will attach to it
    launches:\
     `neutron port-create &lt;net-id&gt; --binding:vnic-type direct`\
     Make note of the id of the port; you’ll need it in the next step.

-   #### [<span class="headeranchor"></span>](#launch-a-big-ip-instance)Launch a BIG-IP Instance

    To deploy BIG-IP using Horizon, login as the admin tenant and select
    the “admin” project, then click instances, and add an instance.
    Select the BIG-IP image from above as well as the custom flavor, and
    provide the VM with at least 2 networks, 3 if a management VLAN will
    be provisioned.

Using the “nova” command line, use something like:\
 for net in
`bigip_mgmt bigip_external bigip_internal datanet bigip_ha bigip_mirror`,
do\

    # this command sets environmental var "id" to the id of the network
    eval `neutron net-show \$net -f shell --fields id\`
    # append nic to list
    nics="\$nics --nic net-id=\$id"
    done
    nova boot --image bigip11.5.2 --flavor m1.bigip.lbaas.min \$nics admin_bigip1

\
 Wait until the instance becomes active:\
 `nova show admin_bigip1\`

### [<span class="headeranchor"></span>](#7-create-a-floating-ip-from-the-public-network-for-the-big-ip)7. Create a floating IP from the public network for the BIG-IP. {#7-create-a-floating-ip-from-the-public-network-for-the-big-ip}

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

[<span class="headeranchor"></span>](#next-steps)Next Steps
-----------------------------------------------------------

Now that you have a BIG-IP installed, you’ll need to configure it. Our
recommended resources for the setup process are listed below.

-   ###### [<span class="headeranchor"></span>](#devcentral-community)DevCentral Community

    \
     The DevCentral F5 Onboard package contains a number of tools to
    ease deployment of BIG-IP and BIG-IQ. These tools can take care of
    setting passwords, licensing, provisioning, and setting up VLANs and
    IP addresses, upgrading software, and clustering multiple devices.

-\
 -\
 -

[<span class="headeranchor"></span>](#_1) {#_1}
-----------------------------------------

[<span class="headeranchor"></span>](#command-design)Command Design
-------------------------------------------------------------------

These tools are provided in the form of Bash shell wrappers around\
 scripts written in python. The python code uses the REST interface of\
 TMOS. This design was chosen so that they would integrate with
existing\
 shell or python scripts with minimal effort.

### [<span class="headeranchor"></span>](#commands-for-tmos-openstack)Commands for TMOS - OpenStack {#commands-for-tmos-openstack}

The commands in this section are relevant to getting VE running on\
 OpenStack.

### [<span class="headeranchor"></span>](#tmos-startup-script-overview)TMOS Startup Script Overview

IP/DHCP, DNS, SSH keys, passwords, Licensing, Module Provisioning

#### [<span class="headeranchor"></span>](#metadata-format)Metadata Format

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

### [<span class="headeranchor"></span>](#big-iq-image-patching-for-openstack)BIG-IQ Image Patching for OpenStack

f5-onboard-openstack patch-image |

patch-image-and-hotfix

### [<span class="headeranchor"></span>](#big-ip-image-patching-for-openstack)BIG-IP Image Patching for OpenStack

f5-onboard-ve-openstack patch-image

The image file name must end with .qcow2

Usage:

sudo env “PATH=\\\$PATH” f5-onboard-ve-openstack patch-image.sh\
 BIGIP-11.5.0.0.0.221.qcow2

f5-onboard-ve-openstack patch-image-and-hotfix

Example Usage:

sudo env “PATH=\\\$PATH” f5-onboard-ve-openstack patch-image-and-hotfix\
 BIGIP-11.5.0.0.0.221.qcow2 base.iso hotfix.iso

### [<span class="headeranchor"></span>](#deploying-big-iq-ve-on-openstack)Deploying BIG-IQ VE on OpenStack

f5-onboard-openstack deploy-admin-bigiqs |

destroy-admin-bigiqs |

deploy-tenant-bigiqs |

destroy-tenant-bigiqs

### [<span class="headeranchor"></span>](#deploying-big-ip-ve-on-openstack)Deploying BIG-IP VE on OpenStack

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

#### [<span class="headeranchor"></span>](#commands-for-tmos-general)Commands for TMOS - General {#commands-for-tmos-general}

These commands in this section should work with any set of BIG-IPs,\
 whether they are Virtual, Appliance, or vCMP®-based. These commands\
 presume you have already deployed BIG-IP in terms of basic setup and\
 licensing.

If you are using VE, the commands in the next section can help you\
 deploy the BIG-IP from scratch.

### [<span class="headeranchor"></span>](#upgrading-big-iq-software)Upgrading BIG-IQ Software

### [<span class="headeranchor"></span>](#upgrading-big-ip-software)Upgrading BIG-IP Software

f5-onboard-upgrade-bigips

–keystone-addr &lt;addr&gt;

–admin-password &lt;pw&gt;

–bigip-image &lt;img&gt;

–num-bigips &lt;num&gt;

### [<span class="headeranchor"></span>](#clustering-big-ips)Clustering BIG-IPs

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

### [<span class="headeranchor"></span>](#commands-for-tmos-odk)Commands for TMOS - ODK {#commands-for-tmos-odk}

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
