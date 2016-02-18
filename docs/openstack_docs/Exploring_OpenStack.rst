Overview
--------

You can log in to the OpenStack dashboard with the following URL
(replacing with your IP address) and the login you configured during the
setup process: *\http://<ip_address\>/dashboard*.

**NOTE:** We’ve had better luck accessing VM remote consoles with Chrome
than with Internet Explorer.

Exploring the OpenStack CLI
---------------------------

You can use the OpenStack CLI by first sourcing the credentials:

`[manager@pack43 ~]$ source keystonerc_admin`

Check out a few commands:

    [manager@pack43 ~(keystone_admin)]$ keystone tenant-list

    id |name |enabled 
    :------|:------|:------
    ca2d148d2f004029b147084a0e58f69c |admin    | True    
    32d4cde8a9c54767883e4a3894373155 |proj_1  | True    
    b2b7599a9ba34292ab1a66a6239fc201 | proj_2  | True    
    4fbf9eddf32c41e28a40beb935e96c35 | proj_3  | True    
    18fc8dbb8d9745429e10224de01a78a3 | services | True    

More commands to try:

    [manager@pack43 ~(keystone_admin)]$ keystone user-list
    [manager@pack43 ~(keystone_admin)]$ keystone role-list
    [manager@pack43 ~(keystone_admin)]$ keystone user-role-list
    [manager@pack43 ~(keystone_admin)]$ keystone service-list
    [manager@pack43 ~(keystone_admin)]$ keystone catalog
    [manager@pack43 ~(keystone_admin)]$ nova service-list
    [manager@pack43 ~(keystone_admin)]$ neutron agent-list

{% comment %} Check out the Load Balancer Agent (be sure to use the ID
listed in the previous command): **INSERT TABLE IMAGE HERE** {%
endcomment %}

### Networks and Floating IPs

    neutron net-list
    neutron net-show <id>
    neutron subnet-list
    neutron subnet-show <id>
    neutron port-list
    neutron port-show <id>
    neutron floatingip-list

### Flavors, Images, and VMs

    nova list
    nova show bigip1
    nova hypervisor-list
    nova hypervisor-servers <hypervisor-hostname>
    nova hypervisor-stats
    nova image-list
    nova flavor-list
    nova flavor-show m1.bigip

### Security Rules

    neutron security-group-list
    neutron security-group-rule-list

### Firewall Configurations

**NOTE:** If you haven’t created a firewall, the results of these
commands will be empty.

    neutron firewall-list
    neutron firewall-policy-list
    neutron firewall-rule-list

### LBaaS Configuration

    neutron help | grep lb-
    neutron lb-vip-list
    neutron lb-pool-list
    neutron lb-member-list
    neutron lb-healthmonitor-list

Explore BIG-IP
--------------

Use `nova list` to find the address of your BIG-IP (in the following
example, it's 10.99.2.2). The BIG-IP will begin with the default
credentials. To access the BIG-IP GUI from a remote machine, run the
following IPTables commands on the CentOS host command line:

    myif=`ip route show | grep default | head -n 1 | cut -d' ' -f5`
    myip=`ip addr show dev $myif | grep "inet "| cut -d' ' -f6 | cut -d'/'
    -f1`
    iptables -t nat -A PREROUTING -i $myif -p tcp --dport 2443 -d $myip -m
    conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.2:443

If you deployed a second BIG-IP using the option `--ha-type pair` (which
is not the default), then you should also do this for the second BIG-IP:

    iptables -t nat -A PREROUTING -i \$myif -p tcp --dport 3443 -d $myip -m
    conntrack --ctstate NEW -j DNAT --to-destination 10.99.2.3:443

### Partitions and LTM Objects

Log in to the BIG-IP.

    tmsh
    list net tunnels

Type `cd /u<tab> …`, select a folder, and press return.

    list ltm virtuals
    list ltm pools

### Tunnel Configurations

Log in to the BIG-IP.

    tmsh

    list net tunnels

Type `cd /u<tab> …`, select a folder, and press return.

    list net tunnels

Launch a Nova Instance
----------------------

    curl -O http://cloud-images.ubuntu.com/releases/precise/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img
    glance image-create --name Ubuntu-12.04-LTS-OVF --is-public True --disk-format qcow2 --container-format ovf \\ --file ubuntu-12.04-server-cloudimg-amd64-disk1.img --property os_distro=ubuntu
    curl -O http://cloud-images.ubuntu.com/releases/trusty/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img
    glance image-create --name Ubuntu-14.04-LTS-OVF --is-public True --disk-format qcow2 --container-format ovf \\ --file ubuntu-14.04-server-cloudimg-amd64-disk1.img --property os_distro=ubuntu
    nova keypair-add --pub_key \~/.ssh/id_rsa.pub default_key
    nova keypair-list
    nova boot my-trusty --flavor m1.small --key_name default_key --image Ubuntu-12.04-LTS-OVF
