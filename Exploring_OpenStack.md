---
layout: docs_page
title: Exploring OpenStack
url: {{ page.title | slugify }}
categories: openstack, testing, tools, misc_docs
resource: true
---

# Overview

You can log in to the OpenStack dashboard with the following URL (replacing with your IP address): *http://<ip_address\>/dashboard*.

**NOTE:** We’ve had better luck accessing VM remote consoles with Chrome than with Internet Explorer.

If you've used the [QuickStart configuration](#), you can log in into the admin project using the username “admin” and password from the *keystonerc_admin* file which is placed in your local directory.

# Projects
You can also log in as a regular tenant using the username “user_1” and password “user_1”; this will log you into the “proj_1” tenant project. You can also explore proj_2 and proj_3 using credentials “user_2” and “user_3”, respectively.

# Exploring the OpenStack CLI

You can use the OpenStack CLI by first sourcing the credentials:

`[manager@pack43 ~]$ source keystonerc_admin`

Check out a few commands:

`[manager@pack43 ~(keystone_admin)]$ keystone tenant-list`

id |name |enabled 
:------|:------|:------
ca2d148d2f004029b147084a0e58f69c |admin    | True    
32d4cde8a9c54767883e4a3894373155 |proj_1  | True    
b2b7599a9ba34292ab1a66a6239fc201 | proj_2  | True    
4fbf9eddf32c41e28a40beb935e96c35 | proj_3  | True    
18fc8dbb8d9745429e10224de01a78a3 | services | True    


More commands to try:

```
[manager@pack43 ~(keystone_admin)]$ keystone user-list
[manager@pack43 ~(keystone_admin)]$ keystone role-list
[manager@pack43 ~(keystone_admin)]$ keystone user-role-list
[manager@pack43 ~(keystone_admin)]$ keystone service-list
[manager@pack43 ~(keystone_admin)]$ keystone catalog
[manager@pack43 ~(keystone_admin)]$ nova service-list
[manager@pack43 ~(keystone_admin)]$ neutron agent-list
```

Check out the Load Balancer Agent (be sure to use the ID listed in the previous command):

**INSERT TABLE IMAGE HERE**

### Explore Networks and Floating IPs

```
neutron net-list
neutron net-show <id>
neutron subnet-list
neutron subnet-show <id>
neutron port-list
neutron port-show <id>
neutron floatingip-list
```

## Explore Flavors, Images, and VMs

```
nova list
nova show bigip1
nova hypervisor-list
nova hypervisor-servers <hypervisor-hostname>
nova hypervisor-stats
nova image-list
nova flavor-list
nova flavor-show m1.bigip
```

## Explore Security Rules

```
neutron security-group-list
neutron security-group-rule-list
```

## Explore Firewall Configuration

**NOTE:** If you haven’t created a firewall, the results of these commands will be empty.

```
neutron firewall-list
neutron firewall-policy-list
neutron firewall-rule-list
```

## Explore LBaaS Configuration

```
neutron help | grep lb-
neutron lb-vip-list
neutron lb-pool-list
neutron lb-member-list
neutron lb-healthmonitor-list
```

## Explore BIG-IP 

Use `nova list` to find the address of your BIG-IP (in the following example, it's 10.99.2.2). The BIG-IP will begin with the default credentials. To access the BIG-IP GUI from a remote machine, run the following IPTables commands on the CentOS host command line:

```
myif=`ip route show | grep default | head -n 1 | cut -d' ' -f5`
myip=`ip addr show dev $myif | grep "inet "| cut -d' ' -f6 | cut -d'/'
-f1`
iptables -t nat -A PREROUTING -i $myif -p tcp --dport 2443 -d $myip -m
conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.2:443
```
If you deployed a second BIG-IP using the option “--ha-type pair” (which is not the default), then you should also do this for the second BIG-IP:

```
iptables -t nat -A PREROUTING -i \$myif -p tcp --dport 3443 -d $myip -m
conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.3:443
```

### Explore BIG-IP Partitions and LTM Objects

Log in to the BIG-IP.

```
tmsh
list net tunnels
```
Type `cd /u<tab> …`, select a folder, and press return.

```
list ltm virtuals
list ltm pools
```

### Explore Tunnel Config

Log in to the BIG-IP.

```
tmsh

list net tunnels
```
Type `cd /u<tab> …`, select a folder, and press return.

```
list net tunnels
```

### Launch a Nova Instance

```
curl -O http://cloud-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img
glance image-create --name Ubuntu-12.04-LTS-OVF --is-public True --disk-format qcow2 --container-format ovf \\ --file ubuntu-12.04-server-cloudimg-amd64-disk1.img --property os_distro=ubuntu
curl -O http://cloud-images.ubuntu.com/releases/trusty/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img
glance image-create --name Ubuntu-14.04-LTS-OVF --is-public True --disk-format qcow2 --container-format ovf \\ --file ubuntu-14.04-server-cloudimg-amd64-disk1.img --property os_distro=ubuntu
nova keypair-add --pub_key \~/.ssh/id_rsa.pub default_key
nova keypair-list
nova boot my-trusty --flavor m1.small --key_name default_key --image Ubuntu-12.04-LTS-OVF
```