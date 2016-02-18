Overview
========

This guide will allow a user who already has an all-in-one OpenStack
deployment (in other words, one host serves as the controller, compute,
and network nodes) to configure it to attach to an existing external
network.

The instructions presented here were prepared from a Packstack
deployment on OpenStack Liberty using CentOS 7. We relied heavily on the
RDO project's [Neutron with existing external
network](https://www.rdoproject.org/networking/neutron-with-existing-external-network/)
and the Red Hat Enterprise Linux 7 [OpenStack Networking
Guide](https://access.redhat.com/documentation/en/red-hat-enterprise-linux-openstack-platform/7/networking-guide/networking-guide).
We've found both documentation sets extremely helpful and recommend
consulting them for any issues you may encounter.

Users
-----

When installing CentOS, we created a root user and a user with
administrative priveleges. Our root user has the password 'default'; our
admin user is 'manager', with the password 'manager'. In all command
blocks shown in this guide, the assumed user is represented by the
command prompt symbol:

    # = root
    $ = admin

**WARNING: This guide describes how to deploy OpenStack Liberty. This is
an open source project that is continually changing; while the
instructions included here worked for us, there is no guarantee they
will work exactly the same for you.**

Prerequisites
-------------

OpenStack: All-in-one deployment on Liberty

Software: Red Hat Enterprise Linux (RHEL) 7 is the minimum recommended
version you can use with OpenStack Liberty. You can also use any of the
equivalent versions of RHEL-based Linux distributions (CentOS,
Scientific Linux, etc.). x86\_64 is currently the only supported
architecture.

Hardware: Machine with at least 4GB RAM, processors with hardware
virtualization extensions, and at least one network adapter. For more
information, see the [OpenStack Liberty Installation
guide](http://docs.openstack.org/liberty/install-guide-rdo/overview.html#example-architecture).

Configure the Neutron Network
=============================

Before you configure Neutron to work with an existing external network,
you'll need to identify the device that's attached to the management
network via DHCP and record a few key values:

-   IPADDR
-   HWADDR
-   NETMASK
-   GATEWAY
-   DNS1

To find these values, run `ip addr show` and/or `ifconfig`. In our
example, the device connected to the management network is enp2s0; yours
may be something simpler, such as eth0. Your IP address is listed as
'inet'.

**NOTE**: Do not copy and paste the IP addresses shown in this document
when setting up your environment. Use the valid IP address(es) for your
machine(s).

    # ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ens2f0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN qlen 1000
        link/ether 78:e3:b5:0b:61:a4 brd ff:ff:ff:ff:ff:ff
    3: ens2f1: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN qlen 1000
        link/ether 78:e3:b5:0b:61:a6 brd ff:ff:ff:ff:ff:ff
    4: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether b4:99:ba:a9:55:f0 brd ff:ff:ff:ff:ff:ff
        inet 10.190.4.193/21 brd 10.190.7.255 scope global dynamic enp2s0
           valid_lft 19506sec preferred_lft 19506sec
        inet6 fe80::b699:baff:fea9:55f0/64 scope link
           valid_lft forever preferred_lft forever
    5: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
        link/ether b4:99:ba:a9:55:f1 brd ff:ff:ff:ff:ff:ff
    6: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether 5e:31:76:30:05:cb brd ff:ff:ff:ff:ff:ff
    7: br-ex: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
        link/ether 3a:c1:b2:f4:30:48 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::38c1:b2ff:fef4:3048/64 scope link
           valid_lft forever preferred_lft forever
    8: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether 2e:99:9e:a2:cc:43 brd ff:ff:ff:ff:ff:ff
    9: br-tun: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
        link/ether b2:91:a4:55:a0:4a brd ff:ff:ff:ff:ff:ff

    # ifconfig
    br-ex: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet6 fe80::38c1:b2ff:fef4:3048  prefixlen 64  scopeid 0x20<link>
            ether 3a:c1:b2:f4:30:48  txqueuelen 0  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 8  bytes 648 (648.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    enp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.190.4.193  netmask 255.255.248.0  broadcast 10.190.7.255
            inet6 fe80::b699:baff:fea9:55f0 prefixlen 64  scopeid 0x20<link>
            ether b4:99:ba:a9:55:f0  txqueuelen 1000  (Ethernet)
            RX packets 1183741  bytes 541128626 (516.0 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 130388  bytes 13634811 (13.0 MiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
            device interrupt 16  memory 0xf7ee0000-f7f00000

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 0  (Local Loopback)
            RX packets 4013798  bytes 371688922 (354.4 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 4013798  bytes 371688922 (354.4 MiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

#### Configure the bridge

-   Create/modify the file */etc/sysconfig/network-scripts/ifcfg-br-ex*
    and add the entries shown below, using the appropriate values for
    your network. This moves the IP address and netmask that were
    assigned to the device 'enp2s0' to the bridge 'br-ex'.

<!-- -->

    # vi /etc/sysconfig/network-scripts/ifcfg-br-ex
    DEVICE=br-ex
    DEVICETYPE=ovs
    TYPE=OVSBridge
    BOOTPROTO=static
    IPADDR=10.190.4.193
    NETMASK=255.255.248.0 \\ shown in the ifconfig readout
    GATEWAY=10.190.0.1 \\ you may need to get this information from your network admin if you don't know it
    DNS1=10.190.0.20 \\ you may need to get this information from your network admin if you don't know it

-   Edit the config file for the
    device (/etc/sysconfig/network-scripts/ifcfg-enp2s0) and add the
    lines shown below, using the appropriate values your network. This
    attaches the devices to the OVS bridge as a port.

**NOTE:** You will need to remove the `BOOTPROTO` entry from the top of
this file if it exists.

    # vi /etc/sysconfig/network-scripts/ifcfg-enp2s0
    ...
    DEVICE="enp2s0" 
    HWADDR="b4:99:ba:a9:55:f0" \\ shown in the ifconfig readout as 'ether'
    TYPE="OVSPort" 
    DEVICETYPE="ovs"
    OVS_BRIDGE="br-ex"
    ONBOOT="yes"

-   Run the command below to assign a name to the br-ex OVS
    bridge ('exnet'). This will show up as the
    `provider:physical_network` entry for the external networks.

<!-- -->

    # openstack-config --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs bridge_mappings extnet:br-ex

#### Configure the network types

Run the command below to make the vxlan, flat, and vlan options
available. (This is noted in the [RDO
documentation](https://www.rdoproject.org/networking/neutron-with-existing-external-network/)
as a bug workaround.)

    # openstack-config --set /etc/neutron/plugin.ini ml2 type_drivers vxlan,flat,vlan

**NOTE:** If you're assigning IP addresses from your external network
using DHCP, replace the default `dhcp_domain` in
`/etc/neutron/dhcp_agent.ini` with the name of your local domain.

    # vi /etc/neutron/dhcp_agent.ini 
    ...
    # Domain to use for building the hostnames
    # dhcp_domain = openstacklocal
    dhcp_domain = [something.example.com]
    ...

#### Reboot your machine

**NOTE:** This will terminate your connection.

    # reboot

**NOTE:** The following steps use neutron commands. You'll need to run
`source keystonerc_admin` before proceeding to ensure access to the
neutron command line tools. You can also configure the network using the
Horizon dashboard; we're not documenting it here, but trust us that it's
very intuitive and easy to figure out!

#### Set up the router gateway for the external network.

    # neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared
    Created a new network:
    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | admin_state_up            | True                                 |
    | id                        | 8fe1a243-4970-4c5a-84c0-6fef5612c844 |
    | mtu                       | 0                                    |
    | name                      | external_network                     |
    | provider:network_type     | flat                                 |
    | provider:physical_network | extnet                               |
    | provider:segmentation_id  |                                      |
    | router:external           | True                                 |
    | shared                    | True                                 |
    | status                    | ACTIVE                               |
    | subnets                   |                                      |
    | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
    +---------------------------+--------------------------------------+

#### Create a public subnet

This will allow you to assign floating IP addresses to your tenants.
**NOTE:** Be sure the subnet range is outside the external DHCP range.

    # neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=10.190.6.250,end=10.190.6.254 --gateway=10.190.0.1 external_network 10.190.0.0/21  
    Created a new subnet:
    +-------------------+--------------------------------------------------+
    | Field             | Value                                            |
    +-------------------+--------------------------------------------------+
    | allocation_pools  | {"start": "10.190.6.250", "end": "10.190.6.254"} |
    | cidr              | 10.190.0.0/21                                    |
    | dns_nameservers   |                                                  |
    | enable_dhcp       | False                                            |
    | gateway_ip        | 10.190.0.1                                       |
    | host_routes       |                                                  |
    | id                | 91baa5e9-c061-4d29-9584-c171c0c25686             |
    | ip_version        | 4                                                |
    | ipv6_address_mode |                                                  |
    | ipv6_ra_mode      |                                                  |
    | name              | public_subnet                                    |
    | network_id        | fe6b0a53-8d80-4607-96f6-89e31af0b6e6             |
    | subnetpool_id     |                                                  |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec                 |
    +-------------------+--------------------------------------------------+
    # neutron router-create router1
    Created a new router:
    +-----------------------+--------------------------------------+
    | Field                 | Value                                |
    +-----------------------+--------------------------------------+
    | admin_state_up        | True                                 |
    | distributed           | False                                |
    | external_gateway_info |                                      |
    | ha                    | False                                |
    | id                    | 9625ca6a-694b-404c-bdc3-787a92664e00 |
    | name                  | router1                              |
    | routes                |                                      |
    | status                | ACTIVE                               |
    | tenant_id             | 1a35d6558b59423e83f4500f1ebc1cec     |
    +-----------------------+--------------------------------------+
    # neutron router-gateway-set router1 external_network
    Set gateway for router router1

#### Create a private network and subnet.

A private network and subnet allow you to allocate private resources in
your cloud for various projects/users.

    # neutron net-create private_network
    Created a new network:
    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | admin_state_up            | True                                 |
    | id                        | 222840d7-4f9f-411d-a7de-6343ce71fee9 |
    | mtu                       | 0                                    |
    | name                      | private_network                      |
    | provider:network_type     | vxlan                                |
    | provider:physical_network |                                      |
    | provider:segmentation_id  | 77                                   |
    | router:external           | False                                |
    | shared                    | False                                |
    | status                    | ACTIVE                               |
    | subnets                   |                                      |
    | tenant_id                 | 1a35d6558b59423e83f4500f1ebc1cec     |
    +---------------------------+--------------------------------------+
    # neutron subnet-create --name private_subnet private_network 172.16.0.0/12 --dns-nameserver=10.190.0.20
    Created a new subnet:
    +-------------------+-------------------------------------------------+
    | Field             | Value                                           |
    +-------------------+-------------------------------------------------+
    | allocation_pools  | {"start": "172.16.0.255", "end": "172.16.16.0"} |
    |                   | {"start": "172.16.0.2", "end": "172.16.0.254"}  |
    | cidr              | 172.16.0.0/12                                   |
    | dns_nameservers   | 10.190.0.20                                     |
    | enable_dhcp       | True                                            |
    | gateway_ip        | 172.16.0.1                                      |
    | host_routes       |                                                 |
    | id                | 5528fd9e-76dc-427e-9791-2cad6c87ba06            |
    | ip_version        | 4                                               |
    | ipv6_address_mode |                                                 |
    | ipv6_ra_mode      |                                                 |
    | name              | private_subnet                                  |
    | network_id        | 99717ae6-5cfb-45fb-b846-f8e99599cd35            |
    | subnetpool_id     |                                                 |
    | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec                |
    +-------------------+-------------------------------------------------+

#### Connect the private network to the public network.

    # neutron router-interface-add router1 private_subnet
    Added interface c0173575-d3dc-4018-939c-4481f0a1c152 to router router1.

**TIP:** To check what networks are configured, run
`openstack network list`. To view details for a configured network, run
`openstack network show [network_name / network_id]`.

    # openstack network list
    +--------------------------------------+------------------+--------------------------------------+
    | ID                                   | Name             | Subnets                              |
    +--------------------------------------+------------------+--------------------------------------+
    | 222840d7-4f9f-411d-a7de-6343ce71fee9 | private_network  | 3203971c-1c58-4e29-98e9-136e4a3aff86 |
    | 8fe1a243-4970-4c5a-84c0-6fef5612c844 | external_network | 49e2802a-ed2d-4eb8-a43d-2dac053433f5 |
    +--------------------------------------+------------------+--------------------------------------+

    # openstack network show 8fe1a243-4970-4c5a-84c0-6fef5612c844
    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | id                        | 8fe1a243-4970-4c5a-84c0-6fef5612c844 |
    | mtu                       | 0                                    |
    | name                      | external_network                     |
    | project_id                | 1a35d6558b59423e83f4500f1ebc1cec     |
    | provider:network_type     | flat                                 |
    | provider:physical_network | extnet                               |
    | provider:segmentation_id  | None                                 |
    | router_type               | External                             |
    | shared                    | True                                 |
    | state                     | UP                                   |
    | status                    | ACTIVE                               |
    | subnets                   | 49e2802a-ed2d-4eb8-a43d-2dac053433f5 |
    +---------------------------+--------------------------------------+

Add Projects and Users
======================

Now that your network is configured, you'll probably want to create
projects and users.

**NOTES:** - According to the [OpenStack
documentation](http://docs.openstack.org/openstack-ops/content/projects_users.html):
"In OpenStack user interfaces and documentation, a group of users is
referred to as a project or tenant. These terms are interchangeable." -
You do not need to be logged in as root to run the below commands. You
do need to source the *keystonerc\_admin* file, though.

### Add a Project

The below command creates a project (or tenant) named 'demo1'. It's
enabled by default.

    $ openstack project create --description "My demo Project" demo1
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | My demo Project                  |
    | enabled     | True                             |
    | id          | fb76f73484554d3593964f24ec57bd05 |
    | name        | demo1                            |
    +-------------+----------------------------------+

### Add a User

The below command creates a user named demo with access to the 'demo1'
project. The new user account will be enabled by default.

    $ openstack user create --project demo1 --password foobar1 --email something@example.com demo
    +------------+----------------------------------+
    | Field      | Value                            |
    +------------+----------------------------------+
    | email      | something@example.com                   |
    | enabled    | True                             |
    | id         | c845db0c788443b4962b0717738ab0ce |
    | name       | demo                             |
    | project_id | fb76f73484554d3593964f24ec57bd05 |
    | username   | demo                             |
    +------------+----------------------------------+

**TIP:** Run `openstack project list` to view a list of configured
projects and `openstack user list` to view a list of configured users.

Install an Image from Glance
============================

OpenStack's [Glance](http://docs.openstack.org/developer/glance/)
project is a service for sharing data assets to be used with other
OpenStack services, including VM images.

To get a
[CirrOS](http://docs.openstack.org/image-guide/obtain-images.html#cirros-test-images)
image (not provisioned, without demo provisioning), run the command
shown below.

    $ curl http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img | glance image-create --name='cirros_image' --visibility=public  --container-format=bare --disk-format=qcow2
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100 12.6M  100 12.6M    0     0  1416k      0  0:00:09  0:00:09 --:--:-- 2260k
    +------------------+--------------------------------------+
    | Property         | Value                                |
    +------------------+--------------------------------------+
    | checksum         | ee1eca47dc88f4879d8a229cc70a07c6     |
    | container_format | bare                                 |
    | created_at       | 2016-02-11T16:48:50Z                 |
    | disk_format      | qcow2                                |
    | id               | 5665fc77-73a9-46cb-9f59-6ba229099ad9 |
    | min_disk         | 0                                    |
    | min_ram          | 0                                    |
    | name             | cirros_image                         |
    | owner            | 9af267dd389249cc8c8e922f8bfbd0aa     |
    | protected        | False                                |
    | size             | 13287936                             |
    | status           | active                               |
    | tags             | []                                   |
    | updated_at       | 2016-02-11T16:48:59Z                 |
    | virtual_size     | None                                 |
    | visibility       | public                               |
    +------------------+--------------------------------------+

Launch an Instance
==================

We highly recommend that you follow the RDO [Running an Instance
guide](https://www.rdoproject.org/install/running-an-instance/) from
here on out. They've done a great job presenting the information, so
we're not going to paraphrase it here. We do have a few tips, though:

-   We recommend generating a key pair on your client and importing it,
    as opposed to the other way around.
-   You already created an image as part of this guide; it will be
    available in the Images list to use when launching your instance.
-   If your private network doesn't show up in the network list when
    adding an instance, it may be misconfigured.

Further Reading
===============

Once you have successfully launched an instance in your OpenStack cloud,
you may find the [OpenStack Admin User
Guide](http://docs.openstack.org/user-guide-admin/) or the [OpenStack
Operations Guide](http://docs.openstack.org/ops/) helpful.

If you want to deploy a BIG-IP VE and manage its LTM services using the
F5 LBaaS Plugin, you may find these docs helpful: [How to Deploy a
BIG-IP VE in
OpenStack](http://f5networks.github.io/f5-openstack-docs/HowTo-DeployVEinOS/)
[How to Deploy the F5 OpenStack LBaaSv1
Plugin](http://f5networks.github.io/f5-openstack-docs/lbaasv1-plugin-deploy-guide/)
