---
layout: docs_page
title: How To Deploy BIG-IP VE in an OpenStack Environment
url: {{ page.title | slugify }}
resource: true
---

# Overview
______________
This document describes how to deploy BIG-IP Virtual Edition within OpenStack.

# Before You Start
______________
Check to make sure you have the following:

1.  A running OpenStack installation (Juno or later) on either Red Hat/CentOS 7 or Ubuntu 12.04/14.04.

2.  Licensed BIG-IP VE software.

3.  Basic understanding of OpenStack networking concepts.

4.  An OpenStack [provider network](http://docs.openstack.org/admin-guide-cloud/content/provider_api_workflow.html) \(if using multi-tenant deployment\).

# Deploying BIG-IP VE on OpenStack 
______________
## 1. Initial Setup

1. Verify that the standard “admin” project, user, and roles are set up: 
{% comment %} need to add instructions for this here {% endcomment %}
2. Define the Neutron Security Policy 
a. Allow the ICMP protocol:
```
neutron security-group-rule-create --protocol icmp --direction ingress default
```
b.  Assign the standard ports used by BIG-IP (22, 80, and 443):
```
neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
neutron security-group-rule-create --protocol tcp --port-range-min 80 --port-range-max 80 --direction ingress default
neutron security-group-rule-create --protocol tcp --port-range-min 443 --port-range-max 443 --direction ingress default
```
c. Allow BIG-IP VE access to VXLAN packets:
```
neutron security-group-rule-create --protocol udp --port-range-min 4789 --port-range-max 4789 --direction ingress default
```
d. Allow BIG-IP VE access to GRE packets:
```
neutron security-group-rule-create --protocol 47 --direction ingress default
```
3. Set Up Nova Compute Nodes 
 The */etc/nova/release* file must be changed on every Nova compute node that may run BIG-IP. Otherwise, BIG-IP will not be able to detect that it’s running on KVM. 
```
# echo -e "[Nova]\nvendor = Red Hat\nproduct = Bochs\npackage = RHEL 6.3.0 PC" > /etc/nova/release
#
# cat /etc/nova/release
[Nova]
vendor = Red Hat
product = Bochs
package = RHEL 6.3.0 PC
```
4. Restart the Nova-Compute Service
```
service nova-compute restart
```
______________
## 2. Integrate BIG-IP VE with the OpenStack Network Infrastructure

### Single-tenant Deployment

#### Set Up External and Internal Networks 

**NOTE: If you are using a multi-tenant deployment, skip this step.**

##### External
```
neutron net-create bigip_external
neutron subnet-create --name bigip_external_subnet bigip_external 10.20.0.0/24
neutron router-interface-add admin_router_1 bigip_external_subnet
```
##### Internal
```
neutron net-create bigip_internal
neutron subnet-create --name bigip_internal_subnet bigip_internal
10.30.0.0/24
neutron router-interface-add admin_router_1 bigip_internal_subnet
```

### Multi-tenant Deployment

#### Base Networking

The goal of the base networking setup is to create the OpenStack networks, subnets, and other networking elements that are necessary to run BIG-IP within OpenStack.
 
##### Set Up the Admin Router

These are typical commands that are used to populate an initial public network attached to a router that can later be attached to private networks.

```
neutron router-create admin_router_1 neutron net-create public -- --router:external=True --provider:network_type local  
neutron subnet-create --allocation-pool start=10.144.64.92,end=10.144.64.109 --gateway=10.144.64.91 --name public_subnet public 10.144.64.0/24  
neutron router-gateway-set admin_router_1 public
```

##### Set Up the Management Network 

This network will be used for the BIG-IP management interface.

```
neutron net-create bigip_mgmt
neutron subnet-create --name bigip_mgmt_subnet bigip_mgmt 10.10.0.0/24
neutron router-interface-add admin_router_1 bigip_mgmt_subnet
```

##### Set Up High Availability and Mirroring 

**NOTE: If you’re using a standalone BIG-IP, skip this step.**

###### High Availability (HA)
```
neutron net-create bigip_ha
neutron subnet-create --name bigip_ha_subnet bigip_ha 10.40.0.0/24
neutron router-interface-add admin_router_1 bigip_ha_subnet
```

###### Mirroring
```
neutron net-create bigip\_mirror
neutron subnet-create --name bigip\_mirror\_subnet bigip\_mirror 10.50.0.0/24
neutron router-interface-add admin\_router\_1 bigip\_mirror\_subnet
```

##### Create the Data Network

###### Flat Provider Network:
```
neutron net-create datanet --provider:network_type flat --provider:physical_network physnet-data
```
###### VLAN provider network:
- Create the data network.
```
neutron net-create datanet --provider:network_type vlan --provider:physical_network physnet-data --provider:segmentation_id 4
```
- Create the subnet. Notice that a higher range of the subnet is used here. The idea is that IP addresses used for tunneling endpoints on the compute nodes can use a lower range of the subnet and service VMs like BIG-IP can use a higher range of the subnet. This separation might be necessary if the compute nodes are using static IPs or a different DHCP server.
```
neutron subnet-create --allocation-pool start=10.30.30.200,end=10.30.30.250 --name datanet_subnet datanet 10.30.30.0/24
```
______________
## 3. Create a Nova Custom Flavor for BIG-IP 

We recommend that you define a custom flavor to represent BIG-IP’s hardware requirements. For example:
 
```
flavor_id=$(cat /proc/sys/kernel/random/uuid)
nova flavor-create m1.bigip.lbaas.min $flavor_id 4096 120 2
```
______________
## 4. Import the BIG-IP Image to OpenStack 

{% comment %} instructions for getting a BIG-IP image {% endcomment %}

### Prepare the Image (optional) 

Image preparation allows you to place a boot script on the image before you import it into OpenStack. BIG-IP will run the boot script immediately upon startup. **The script must be named */config/startup*.** 

**CAUTION:** F5 does not recommend creating virtual machines for BIG-IP with a disk image that has already been booted. 

### Import the image

Example using glance:
```
glance image-create --name bigip11.5.2 --is-public true --container-format bare --disk-format qcow2 --file \[your.image.filename\]-OpenStack.qcow2
```
**Do not upload the qcow2 zip file that is generated by the build**. The qcow2 zip format isn’t compatible with OpenStack.
______________
## 5. Deploy BIG-IP
{% comment %}
### Startup Metadata Preparation

[DevCentral](#) has onboarding tools that patch a startup script into the BIG-IP image.
**WARNING:** This software is not officially supported.
{% endcomment %}
### Create an SR-IOV Neutron Port

If you’re using SR-IOV, create the port BIG-IP will attach to when it launches. Make note of the port id, as you'll need it when launching the BIG-IP.

```
neutron port-create <net-id> --binding:vnic-type direct
```

### Launch a BIG-IP Instance

To launch BIG-IP using Horizon:
1. Log in as admin.
2. Select your project. 
3. Click instances and add an instance.
4. Select the BIG-IP image added earlier, as well as the custom flavor, and provide the VM with at least 2 networks (3 if a management VLAN will be provisioned).

To launch BIG-UP using the nova command line:
1. For net in `bigip_mgmt bigip_external bigip_internal datanet bigip_ha bigip_mirror`, do
```
# this command sets environmental var "id" to the id of the network
eval neutron net-show $net -f shell --fields id
# append nic to list
nics="$nics --nic net-id=$id"
done
nova boot --image bigip11.5.2 --flavor m1.bigip.lbaas.min $nics admin_bigip1
# Wait until the instance becomes active:
nova show admin_bigip1
```
{% comment %} 
### Create a floating IP from the public network for the BIG-IP. 

add directions here {% endcomment %}

## Next Steps

Now that you have a BIG-IP installed, you’ll need to configure it. As this is well documented in the BIG-IP literature on [AskF5](http://bit.ly/1MTkM9l) and [DevCentral](http://bit.ly/22KTKwu), instructions are not provided here.

