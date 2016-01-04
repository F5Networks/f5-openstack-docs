---
layout: docs_page
title: Deploying F5 in OpenStack with MaaS and JuJu
url: {{ page.title | slugify }}
categories: openstack, testing, tools, maas, juju, ubuntu
resource: true
---
<div class="alert alert-danger alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span>
    </button>
    <strong>Heads up!</strong> This doc is under development.
</div>


# Overview

Canonical (the company that distributes Ubuntu) provides tools and software archives for installing OpenStack. In contrast with the generality and flexibility of Puppet and Chef, the Canonical tools are oriented towards installing Ubuntu (using MaaS, which is an acronym for Metal as a Service.) and then deploying services like OpenStack on top of Ubuntu (using Juju). CentOS is currently not supported.

At the Atlanta Conference May 2014, Mark Shuttleworth in his recorded keynote speech stated that MaaS/Juju would support CentOS “in the coming weeks” but as of April 2015, the status of that support is unclear.

## Networking for OpenStack

The MaaS / Juju method of installing OpenStack works well with three physical networks, as described in the following section.

### OpenStack-Mgmt

This network is used for installation and ongoing OpenStack management and control plane communication between OpenStack services. It must have routes to the Internet in order to obtain updates. This must be its own isolated broadcast domain because it will run its own DHCP / PXE server.

### OpenStack-External

This network is used as the public address space that VMs will use (via NAT) to access the outside world. It must have routes to the PD lab/Internet in order for the BIG-IP® systems to access the license server. It does not need to have an isolated broadcast domain (from other OpenStack instances) because it uses a range of IP addresses and can co-exist with other instances of OpenStack using other portions of the IP range.

### OpenStack-Data

This network need not be routable but should be on its own broadcast domain because we use hardcoded IP addresses for the compute nodes (10.30.30.1 for the network node, 10.30.30.2 for compute-1, and so on).

## Hardware and Networking

### Machine Requirements

Each physical machine MUST have a working IPMI interface or other power interface supported by MaaS (most Dell machines do). It should function with 8 GB of RAM, although we are not exactly sure how low memory can go and still work. For multiple BIG-IPs and VMs you may want more memory. Some of our machines have 32GB of RAM.

{% comment %}make into table --JP{% endcomment %}

#### Minimal

The minimal configuration for MaaS / juju specifies a total of 3 physical machines which includes the MaaS server (for DHCP and PXE) and 2 OpenStack nodes (1 services+compute, 1 network gateway). DO NOT USE MORE THAN 2 COMPUTE NODES. IT IS NOT SUPPORTED YET.

#### Standard

The standard configuration specifies a total of 4 physical machines which includes the MaaS server (for DHCP and PXE) and 3 OpenStack nodes (1 Services, 1 network gateway, 1 compute).

#### Recommended

The recommended configuration specifies a total of 5 physical machines which includes the MaaS server (for DHCP and PXE) and 3 OpenStack nodes (1 Services, 1 network gateway, 2 compute). It is better to test with two compute nodes so that you test network traffic between compute nodes.

### Network IPs and Ports

- You will need at least a /27 (32 address) IP network that can access the Internet for the management / IPMI / DHCP network.
- You will need at least 20 addresses on another IP network that can access the Internet for the Public/External network.
- You will also need another data network which need not be routable. This network will have private IPs (10.30.30.X).

Each machine consumes an IPMI port on the mgmt network. We’d recommend the MaaS controller have an interface on the external network (to avoid routing test traffic through PD Lab routers). So, that’s two ports for the MaaS controller. The network node needs three network ports: mgmt, external, and data. Each compute node needs two network ports: mgmt, and data. 

{% comment %}make into table --JP{% endcomment %}

#### Minimal

For the minimal 1-maas-2-openstack-devices setup, you'll need 6 mgmt net ports (3 ipmi + 3 mgmt), 2 external net ports, and 2 data net ports.

#### Standard

For the standard 1-maas-3-openstack-devices setup, you'll need 8 mgmt net ports, 2 external net ports, and 2 data net ports.

#### Recommended

For the recommended 1-maas-4-openstack-devices setup, you'll need 10 mgmt net ports, 2 external net ports, and 3 data net ports.

### Procedures

Rack the servers and connect NICs and IPMI cards to the network as described in the following table. If you are only using 2 OpenStack machines (+1 controller totals 3), then do not setup the OpenStack Services machine. Services will be placed on the Compute Node in that configuration.

Node Type | Networks
:----|:----
MaaS Controller| NIC1 (eth0/em1) to OpenStack-Mgmt
 | NIC2 (eth1/em2) to OpenStack-External
OpenStack Services Node | IPMI to OpenStack-Mgmt
 | NIC1 (eth0/em1) to OpenStack-Mgmt  
OpenStack Network Node(s) | IPMI to OpenStack-Mgmt
 | NIC1 (eth0/em1) to OpenStack-Mgmt
 | NIC2 (eth1) to OpenStack-Data
 | NIC3 (eth2) to OpenStack-External
OpenStack Compute Node(s) | IPMI to OpenStack-Mgmt
 | NIC1 (eth0/em1) to OpenStack-Mgmt
 | NIC2 (eth1) to OpenStack-Data

Configure all OpenStack nodes - but not the MaaS Controller - for PXE boot.

For the Controller Node(s), the OpenStack API Network will be the same as the OpenStack-External network. That is a design choice specific to the Juju OpenStack charms.

There is an important issue you should be aware of with respect to the names of NICs. The names of NICs in Linux have typically been eth0, eth1, eth2, etc. There was an issue with this naming strategy: it was partially based on which NIC came alive first during the boot process. So, on one boot a NIC would be eth0, and the next boot it would be eth1. That is not acceptable when there is automation software that is configured to communicate over a specific NIC (by name). There is a lot of documentation here which describes how to work around this issue.

Newer operating systems such as CentOS 7 and Ubuntu 14 have adopted a new NIC naming scheme that may be enabled for your hardware that adopts names related to the hardware location rather than the previous sequential naming scheme (eth0, eth1, etc). This results in interesting names such as em1 and eno1 for onboard NICs and p1p2 and enp4s0f0 for NIC card ports. This “deterministic” naming scheme avoids the problem describe in the previous paragraph. Unfortunately, even these latest operating systems will revert to the old naming scheme *depending on the specific hardware it is running on.* So, you just have
to boot the operating system on the hardware and run “ip link” to see which naming scheme you have.

If you have the new naming scheme, then you probably will not need to worry about this issue with NIC reordering and you can skip the section called “Preseed Udev in MaaS for Nodes with NIC labeling/reordering issues.

Currently the configuration scheme used by this toolkit assumes the same NIC name will be present on all network and compute nodes. With this new naming scheme, that requirement is much more difficult to achieve. In the future the toolkit should be improved to allow configuring different NIC names for each machine.

**If your NICs are coming up with the new naming scheme, then you probably will not have to worry about this issue and can continue to the next section.**

You MUST use the Linux interface name as shown in the table above for the OpenStack management network. It may be that the NIC you want to use, which should be **eth0**, is actually coming up (perhaps only sometimes) as **eth1** or some other label. Regardless, proceed and cable the physical NIC you want to use, even if the Linux label is not correct. Later in this document are instructions about how to override the default label assigned during installation and force a NIC to be **eth0** or whatever label you want. The **em1** (or **eno1**) label is the typical replacement label for use in newer operating systems as described below.

In order to test VLAN based network virtualization, the NICs connected to the OpenStack Data network should have their switch port configured with appropriate tagged VLANs enabled. If it is a Dell switch, for example, ports should have their port settings set to **General** access with **AllowAll** selected to allow both tagged and untagged packets (for GRE and VXLAN testing) (VLAN->Port Settings in the Dell GUI). Also the VLAN membership should be changed to add the ports to the VLANs (VLAN->VLAN Membership in the GUI). You need to complete these steps for every port that is participating in the OpenStack Data Network.

In order to test tunnels, you MUST increase the MTU of the data network switch ports to accommodate VXLAN and NVGRE without reducing the MTU of guests. We have currently set the MTU of the data net switch ports to 1600 just to be sure.

**Warning on the usage of `sudo`**
In some cases you are instructed to use `sudo` for certain commands. It is  easy to get in the habit of using sudo all the time or using `sudo su`, or equivalent, to always run as root. However, *you should only run as root or use sudo when instructed*. Some commands require running as a regular user and should not be run as root.

## MaaS Install and Setup

### Power Off Old Nodes

If you are reinstalling MaaS to create a fresh new environment, then now would be a good time to power down all existing nodes on the MaaS DHCP network. If you use ipmi, the “ipmipower” command is helpful (`ipmipower –h 10.10.1.1 –u root –p manager ---off`). The reason to do this is so that these nodes are not attempting to refresh their DHCP leases with MaaS while MaaS is still being setup and configured. These DHCP refreshes could “taint” the process of creating a pristine new environment, although there is no confirmation that these DHCP refreshes have caused any problem.

### MaaS Install

Get the 14.04 Ubuntu Server ISO image here: http://www.ubuntu.com/download/cloud.

We start here - https://help.ubuntu.com/14.04/clouddocs/en/Intro.html - and will attempt to follow the linked documentation and best practices.

Install 14.04 on the MaaS machine. Follow these hints during the install:

 - Select “Install Ubuntu Server”
 - For host name, we’ve been using names like maas-ctrl-1 or maas-ctrl-2 for our examples.
 - For domain name, use “maas”.
 - Use manager/manager for username/password.
 - Don't turn on automatic updates.
 - Select OpenSSH server.

Now, install maas and upgrade everything:

```
sudo apt-get update -y
sudo apt-get dist-upgrade -y
#Reboot here for new kernel>
sudo apt-get install -y maas
```

#### MaaS Adminstrator Setup

`sudo maas-region-admin createsuperuser`

When prompted, enter this password: manager

#### Import Boot Images

Now, import images:

 1. Go to the maas GUI and log in as root/manager.
 2. Click on the Clusters tab.
 3. Click the **Import Boot Images** button.

This should also work from the command line but the gui is currently recommended due to the failure of the following command: `maas maas node-groups import-boot-images`. Symptoms include an exception in /var/log/maas/celery.log about a CallProcess and ExternalProcess exceptions when launching import-pxe-images and speculation that it was a sudoers problem for the maas user. The gui seems to work. It takes so long, might as well avoid trouble. (See https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1268713.)

This may take well over an hour;  if it does not finish within 2 hours, something probably went wrong. An import run on 9/25/2014 took 1 hour and 40 minutes.

The import is done when the triangle warning icon goes away and a count of boot images is displayed. NOTE that it may continue to say that you still need to initiate the download. Disregard that message. If you want to reassure yourself that the import is running, then run `top`; you should see “maas-import-pxe-files” actively running near the top of the list.

You can proceed to the next few steps without waiting for this to finish. However, the images must finish importing before you start the “MaaS Add Nodes” step.

#### MaaS Login

Get your login key:
`sudo maas-region-admin apikey --username root`

**NOTE:** The MaaS instructions here are wrong: http://maas.ubuntu.com/docs/maascli.html#api-key.

It says to run `$ maas-region-admin apikey my-username`, which doesn’t work. Instead, log in substituting the appropriate maas ip (which is just the local address on the maas server) and api key: `maas login maas <api-key>`. This creates a profile called “maas”.

#### Cluster DHCP Settings

 1. Log in to the web interface of MaaS: (root/manager)
 2. Click on the Clusters tab.
 3. Edit Cluster Master by clicking the pencil/edit icon for eth0 or em1 (whichever is present, depending on your hardware).
 4. Configure the IPs and ranges. 
 The first few IP parameters are for the MaaS server itself. The IP range Low and IP Range High are for the DHCP range that will be assigned to the OpenStack nodes. This should be an unused range of at least 15 addresses on the OpenStack Mgmt network.
 5. Management: Change to “Manage DHCP and DNS”
 6. Save Interface
 7. Save Cluster Controller.

#### DNS

 1. Login to the web interface of MaaS: (root/manager)
 2. Click on the gear icon in the upper right.
 3. Go the Networking Configuration near the bottom.
 4. Change the default domain for new nodes to “maas”.
 5. Configure the upstream DNS to use "172.27.1.1".
 6. Save your changes.

**BUG:** maas dns not operational after following install instructions. Juju commands will fail later and will be accompanied with this error:

```
 ERROR state/api: websocket.Dial wss://node-services.maas:17070/: dial tcp: lookup node-services.maas: no such host
```
**NOTE:** Try running the workaround after the import boot images process completes, just in case restarting the network might disrupt that process.

**Workaround:**
 1. **Run this command before you add nodes:** 
     `sudo vi /etc/network/interfaces`
 2. Add the MaaS default IP as the first entry of dns-nameservers.
 3. **Run this command before you add nodes:** 
     `sudo service network-interface restart INTERFACE=em1`
     (Use em1 or eth0, whichever is present on your hardware.) This may disrupt your current connection, so be prepared to reconnect.

#### Get/Set OAuth token

 1. From the command line, generate an SSH key:
  - `ssh-keygen -b 2048 -t rsa`
  - Accept defaults
  - `cat \~/.ssh/id_rsa.pub`
 2. Copy the entire string for the step below.
 3. Login to the web interface of MaaS: (root/manager)
 4. Go to Login Preferences (located in the upper right of the console). 
 5. Click on “root”.
 6. Click “Add SSH Key”. 
 7. Paste the string from above. 
 8. Click "Add Key".

**Tip:** If you get an error about invalid SSH public key format, make sure your copy and paste process didn’t leave an extra carriage return in the string. It should be one single, long line.

#### MaaS IPMI Bug Workaround

Due to the following bug in MaaS, IPMI access configuration will not be configured properly for certain Dell models (1435, 2970) and perhaps others: https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1321885.

**Workaround:**
Perform these steps on the maas server:

 - `sudo vi /etc/maas/templates/commissioning-user-data/snippets/maas_ipmi_autodetect.py`
 - Change this function to comment out the last line, as shown below:
```
def apply_ipmi_user_settings(user_settings):
"""Commit and verify IPMI user settings."""
username = user_settings['Username']
ipmi_user_number = pick_user_number(username)
for key, value in user_settings.iteritems():
bmc_user_set(ipmi_user_number, key, value)
#verify_ipmi_user_settings(ipmi_user_number, user_settings)
```

While you are in this file, you might as well fix another bug: https://bugs.launchpad.net/maas/+bug/1312863. Around line 205, you will need to replace the order in which the IPMI settings are configured:

```
user_settings = OrderedDict((
('Username', username),
('Password', password),
('Enable_User', 'Yes'),
('Lan_Privilege_Limit', 'Administrator'),
('Lan_Enable_IPMI_Msgs', 'Yes'),
))
```
**NOTE that the last two lines are reversed.**

MaaS Troubleshooting Tips: https://maas.ubuntu.com/docs/troubleshooting.html#debugging-ephemeral-image.

#### MaaS Add Nodes

Perform the following steps for each node:
 1. Power on the node. After the node boots and runs, it will shut down.
 2. Go to MaaS GUI.
 3. Confirm the device is listed as “Declared”.
 4. Click on the device and Edit.
 5. Change the name of the device from the auto-generated name to one that reflects the desired role for the machine. Examples of acceptable names are "node-services.maas", "node-network.maas", and "node-compute-N.maas" (where N is a number starting at 1).
 6. Save your changes.
 7. Click "Save node".
 8. Click "Commission node". The box will automatically turn on, be commissioned, and turn off.

#### Prep for MaaS Workarounds

In order to automate some workarounds for MaaS and Juju, we’ll need to install the OpenStack Deployment Kit now.

Copy F5’s OpenStack Deployment Kit (python-odk_0.8.0-1_all.deb, or similar filename depending on the version) to "manager@<maas controller>:" and install it:
`sudo dpkg –i python-odk_0.8.0-1_all.deb`

#### Preseed Udev in MaaS for Nodes with NIC Labeling/reordering issues

There is a bug in Juju that creates a bridge and it expects to put eth0 into it (see https://bugs.launchpad.net/juju-core/+bug/1337091). Juju assumes eth0 is your primary DHCP interface, even if the Ubuntu installer configured a different device or you experience “NIC reordering”, as described in the next section.

The current version of Juju puts the bridge configuration in */etc/network/eth0.config*. If eth0 is not operational on first boot then the bridge is not created and containers which subsequently rely on the existence of br0 will not start. Also, a service running directly on the machine may not function. For example, on a quantum-gateway the agent remained in an “installed” state due to this problem.

The “odk-openstack deploy” command implements a workaround for this problem which ensures that physical NICs always have the same name.

In order to prepare for this workaround, go to the MaaS GUI and “Start” each node. If Ubuntu does not install, see the next section for possible disk issues.

After the nodes are installed and running, you will need to retrieve the network interface udev rules for each node as explained in the following section. This will be used later to map the NICs to the proper device name (eth0 or eth1). The rationale for this follows.

#### NIC Reordering

As mentioned in the previous section, when you are deploying Ubuntu 12.04 to nodes, you may occasionally find that a node is not operational. For example, a container on the device may not start. It may give an errors such as “lxc-start failed” in juju status. The root cause of the problem may be NIC reordering. What is happening is that the machine booted from the BIOS via DHCP and PXE, but then when Linux boots, the interface that did the BIOS PXE boot does not come up with the usual “eth0” label according to Linux. You may have thought that the NIC you attached to the DHCP/PXE network would be eth0 but it actually came up as a different device such as eth1. This can occur because
physical PCI devices can be discovered in different order depending on which device became operational first and it may vary from boot to boot.

The reason 14.04 *may* not have this issue is that work has been done to consistently name network interfaces. Instead of Ethernet interface names such as eth0 and eth1, names may be something like em1 or p1p1 corresponding to on-board management NICs or position on the PCI bus. However, this only applies to certain types of computers. Unfortunately, due to this previously mentioned bug (https://bugs.launchpad.net/juju-core/+bug/1337091), juju and maas cannot handle the new (consistent) names anyway. The odk does have an “unconventional” workaround that replaces ifup with a shim script in order to “fix” the networking for now on Ubuntu 14.04.

The solution to the problem described above, in the case of the standard "eth\*" naming convention, is to establish udev rules that properly label the NICs. A “Udev rule” is an entry in a configuration file that says that a network device with a specific MAC address should get a specific label such as “eth0”. Udev rules are stored in */etc/udev/rules.d/70-persistent-net.rules*. You should go to each node and edit the copy of that file to establish the correct mapping of MAC addresses to NIC names. After changing that file, reboot. You might want to configure temporary IPs on the nodes to make sure they can reach each other on all appropriate networks.

Once you have the udev files configured properly, you’ll need to retrieve them and store them in a directory named *.odk/conf/juju/<distro>/nodes/<nodename>*, where distro is “precise” or “trusty”. An example of a valid file is “.odk/conf/juju/precise/nodes/node-services.maas”. Later, when you run the “odk-openstack deploy” command to deploy OpenStack, that script will set up the MaaS installer to apply the changes you have made to the udev file during the installation process. The way the script works is that it modifies the installation “preseed” file to run a “late command” which populate the udev file with the correct content before the installation completes. Furthermore, the preseed command will populate */etc/network/interfaces* to include the appropriate NIC (eth0) as the primary DHCP NIC.

From the *~/.odk/conf/juju/<distro>* directory, you would do something like this:

for node in node-services.maas node-network.maas node-compute-1.maas
node-compute-2.maas

do

    mkdir –p nodes/$node
    scp <ubuntu@$node:/etc/udev/rules.d/70-persistent-net.rules>
    nodes/$node/
    done

Then, list the nodes and run the release command for each node. 

```
maas maas nodes list | grep -e host -e system_id
maas maas node release <system_id>
```   

#### Preseed Install Disk in MaaS Installer for Nodes with Install Issues

Some nodes may not install Ubuntu automatically because the install prompts for a disk, usually because the disk it finds with “list-devices disk” is not the correct one (like a RAID leaf drive before the RAID driver is loaded to expose the correct device). The installer will stop and prompt for a drive because the one it determined to use using the standard preseed rule was incorrect. To fix this, determine the correct drive (it’s usually /dev/sdb but could be /dev/sdc) and correct the preseed file as follows. After that, “release” the node from maas (see previous section) and then finish the instructions from the previous section (i.e., copy the udev file and release the node).

```
sudo cp /etc/maas/preseeds/preseed_master /etc/maas/preseeds/preseed_master.orig
cp /etc/maas/preseeds/preseed_master ~/.odk/conf/juju/
sudo vi ~/.odk/conf/juju/preseed_master
```
Change this line:

```
d-i partman/early_command string debconf-set partman-auto/disk list-devices disk | head -n1\
```
to this:
{% raw %}

```
    {{if node.fqdn in {'node-compute-1.maas'} }}
       d-i     partman-auto/disk string /dev/sdb
      {{else}}
       d-i     partman/early_command string debconf-set partman-auto/disk
        'list-devices disk | head -n1'
    {{endif}}
```
{% endraw %}

#### MAAS Add Tags

In order to identify which machines should be used for certain purposes,
you should tag the nodes.

Create Tags:

```
maas maas tags new name="services" comment="services node"
maas maas tags new name="compute" comment="compute node"
maas maas tags new name="network" comment="network node"
```

Get the list of nodes and their system IDs:
`maas maas nodes list | grep -e host -e system_id`

Copy the system Id for the node you want to add a tag to.
`maas maas tag update-nodes <tag> add=<systemID>`

Use the system ID from above for \<systemID\> and use “compute”,
“network”, or “services“ (without quotes) for \<tag\>.

Example:

```
manager@maas-ctrl-2:\~\$ maas maas nodes list |grep -e host -e system_id
"hostname": "node-services.maas",
"system_id": "node-daec2766-19ce-11e4-9db0-00188b7f37c1",
"hostname": "node-network.maas",
"system_id": "node-9410b04a-19cf-11e4-b3b1-00188b7f37c1",
"hostname": "node-compute-1.maas",
"system_id": "node-e1e71ebe-1a90-11e4-b3b1-00188b7f37c1",
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
```

#### MaaS DHCP IP Address Exhaustion

**BUGS:**
 
 - https://bugs.launchpad.net/maas/+bug/1314267
 - https://bugs.launchpad.net/ubuntu/+source/maas/+bug/1274499>
 - https://bugs.launchpad.net/maas/+bug/1321328

If MaaS runs out of DHCP addresses, it may reissue IP addresses that are already in use. This appears to be because it is not clearing the DHCP leases for destroyed services. However, the lease file should probably not be cleared for MaaS nodes because maas appears to populate DNS with DHCP allocated IP addresses and expects those DNS names to work indefinitely. Ideally, MaaS would allow IP addresses for nodes to be pinned while allowing leases to be cleared for other services that are destroyed. A workaround for this is needed in the mean time.

##### Create DHCP lease seed file

The workaround is to modify */var/lib/maas/dhcp/dhcp.leases* and remove everything but one host entry and one lease entry for each of your physical machines. 
 - Each lease entry should have a “binding state free” line. 
 - Remove the other state settings that start with “next” or “rewind”. 
 - Keep the “server-duid” line.

The deployment scripts will automatically copy the DHCP leases you have prepared to the existing leases file, overwriting it. It then restarts the maas dhcp service. To prepare this step, you should copy the dhcp.leases file to *~/.odk/conf/juju* and prepare it as described above.

```
cp /var/lib/maas/dhcp/dhcp.leases \~/.odk/conf/juju/
vi \~/.odk/conf/juju/dhcp.leases
```

##### No password for sudo

The OpenStack deployments scripts will automatically reset the DHCP lease file by copying the file in *~/.odk/conf/juju* to */var/lib/maas/dhcp*. In order to automate this, you will need to remove the password prompt requirement for sudo. This can be done by adding the following line to the end of the /etc/sudoers file. NOTE that this assumes you trust the manager user to secure their login sessions as they will be superuser capable without a password prompt no matter how long their login session exists.
`manager ALL=(ALL) NOPASSWD:ALL`

## Set up and Run ODK 

### Configure ODK Settings

**Important:** Do not run these commands as root. Be sure to replace these placeholder IP addresses with your own IP addresses. 

```
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
```

### Configure F5 extensions

```
sudo dpkg -i python-f5-onboard_0.8.0-1_all.deb
mkdir -p ~/.f5-onboard/conf
```

### Put VE licenses in file:

```
vi ~/.f5-onboard/conf/startup.licenses
mkdir –p ~/.f5-onboard/images/patched
scp <manager@10.144.65.130:.f5-onboard/images/patched>/* ~/.f5-onboard/images/patched
f5-onboard-setup
```

### Run OpenStack Deployment

To kick off the automation:
`odk-openstack deploy --test`

This automates deploying each charm individually and creating appropriate relationships. The following video shows a similar process done manually via the GUI: http://www.youtube.com/watch?v=V2H3fat0K5w.

NOTE that by default, `odk-openstack deploy` uses VLANs for network virtualization. See the Hardware and Networking section for setup instructions.

## Description of F5’s Juju Improvements

### Overview

The Juju charms available on LaunchPad have significant limitations. These limitations are described in this section and F5 workarounds for some of these limitations are also described.

YOU DO NOT NEED TO DO ANYTHING ABOUT THE ISSUES THAT FOLLOW. THIS SECTION IS ONLY DESCRIBING WHAT CUSTOMIZATIONS AND WORKAROUNDS HAVE ALREADY BEEN RESOLVED BY AUTOMATION.

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
   
```    
nova-cloud-controller:
quantum-plugin: ml2
quantum-gateway:
plugin: ml2
```
Also, in this patch, the juju charm executes the following commands due to the referenced packaging bugs:

```
apt-get install python-pip
pip install --upgrade six==1.4.1
```
**Important:** **Do not run these commands.** This is only a description of what the juju charm does for you.

https://bugs.launchpad.net/ubuntu/+source/python-keystoneclient/+bug/1251466
https://lists.fedoraproject.org/pipermail/scm-commits/Week-of-Mon-20140310/1205108.html


### Patch: ML2 Network Configuration

This patch allows a number of ML2 configuration variables to be specified as juju charm configuration. This allows the charms to support different network types (e.g. vlan, gre, vxlan), to support bridge mappings for provider networks, and it allows configuring and setting up a dedicated VM Data network (for VM to VM traffic).

*Configuration*

```
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
```

Contrary to popular recipes such as [Openstack Grizzly Install Guide](https://github.com/mseknibilel/OpenStack-Grizzly-Install-Guide), the stock OpenStack Juju charms configure almost everything on the same network segment. So, OpenStack management (for example, mysql and rabbit) traffic runs over the same network as the VM “Data” network (which is used for intra-VM communication). Also, the OpenStack GUI (Horizon) and Keystone API endpoints run on that same network. The only exception is that the Neutron Gateway’s external network address can be on a separate interface. Even in that case, the stock juju charms do not support configuring the external network address automatically; it must
be done manually.

There are major limitations to this configuration.

-  OpenStack management traffic will compete with VM-to-VM traffic for bandwidth.
-  While a tenant would be able to access VMs through floating IPs on a presumably Internet-routable network (the Neutron-Gateway external network), access to the OpenStack Dashboard or to the API endpoints would require access to the same network as the OpenStack management network, which presumably should **not** be Internet-routable. (Frankly, that doesn’t make sense.)

F5 has worked around the first limitation by customizing the charms for Quantum/Neutron and Nova to break out the VM Data network onto a different interface and subnet. 
**The second limitation is not addressed at this time.** 

Administrators who use these charms will have to find a way to expose certain endpoints on the OpenStack management network but not others, presumably with firewall or other traffic management rules. This is especially challenging with Juju/MaaS because the endpoint IPs are all provisioned dynamically via DHCP.

### Patch: Networking Setup

This patch allows the juju charms to actually setup networking (create bridges and configure IP addresses) on OpenStack network and compute nodes. This patch works well in combination with the previous patch. The previous patch applies to getting configuration into the OpenStack configuration files. This patch handles actually setting up the networking configuration to match what was placed in the configuration file. Thus, this patch allows you to setup a bridge, for example, while the previous patch allows you to put that bridge into the right place in the OpenStack networking configuration so that you can use the bridge for OpenStack networking.

```
nova-compute0:
ovs-bridge-ports: "br-data:eth1,br-bigips:eth3"
network-ips: "br-data:10.30.30.2:255.255.255.0"
nova-compute0:
ovs-bridge-ports: "br-data:eth1,br-bigips:eth3"
network-ips:
"br-ex:10.144.64.71:255.255.255.0:10.144.64.254,br-data:10.30.30.1:255.255.255.0"
```

### Patch: IP sysctl variables

This sets the following sysctl variables on the network node.
    
```
net.ipv4.ip_forward=1
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.br0.rp_filter=0
```

These variables should be set as described in the following link, but the stock juju charms don’t do it: http://docs.openstack.org/havana/install-guide/install/apt/content/neutron-install.dedicated-network-node.html. 

There is no configuration for this patch.

### Patch: Configure VNC Console Access

The stock Juju OpenStack charms do not provide remote console access. A customization has been provided by F5 that allows configuring remote console access.

*Configuration*

```
quantum-gateway:
vnc-proxy-address: “172.2.12.200”
nova-compute:
vnc-proxy-address: “172.2.12.200”
```
The juju charm installs the following packages on the quantum-gateway:
`novnc nova-consoleauth nova-novncproxy`.

The quantum-gateway charm modifies */etc/nova/nova.conf* on the quantum-gateway to add the following section:

```
# Vnc configuration
    novnc_enabled=true
    novncproxy_base_url=http://172.2.12.200:6080/vnc_auto.html
    novncproxy_port=6080
    vncserver_proxyclient_address=172.2.99.178
    vncserver_listen=0.0.0.0
```   
(172.2.12.200 is an example quantum-gateway external network IP. 172.2.99.178 is an example quantum-gateway host IP.)

The nova-compute charm modifies */etc/nova/nova.conf* on the nova-compute node to add the following section:

```
# Vnc configuration
    novnc_enabled=true
    novncproxy_base_url=http://172.2.12.200:6080/vnc_auto.html
    novncproxy_port=6080
    vncserver_proxyclient_address=172.2.99.175
    vncserver_listen=0.0.0.0
```
(172.2.12.200 is an example quantum-gateway external network IP; 172.2.99.175 is an example nova-compute host IP.)

**Workaround:** VNC Does Not Work in Havana
https://bugs.launchpad.net/ubuntu/+source/novnc/+bug/1253840

The VNC patch fixes this by modifying *quantum_gateway/hooks/quantum_hooks.py*:

```
if config('vnc-proxy-address') != '':
 if 'havana' in config('openstack-origin'):
  cmd=['add-apt-repository', 'cloud-archive:grizzly']
   subprocess.check_call(cmd)
  cmd=['apt-get', 'update']
   subprocess.check_call(cmd)
  apt_install(['websockify=0.3.0-0ubuntu1\~cloud0', 'python-novnc=2012.2\~20120906+dfsg-0ubuntu4\~cloud0', 'novnc=2012.2\~20120906+dfsg-0ubuntu4\~cloud0'], ['--force-yes'], fatal=True)
else:
  apt_install(['novnc','nova-consoleauth','nova-novncproxy'], fatal=True)
  cmd=['bash', '-c', "sysctl -w net.ipv4.conf.br-ex.rp_filter=0 > /dev/null;" +
    "cat /etc/rc.local | grep rp_filter &gt; /dev/null || " +
    "(cat /etc/rc.local | sed 's/exit 0/sysctl -w net.ipv4.conf.br-ex.rp_filter=0\\nexit 0/' > /tmp/delme;cat /tmp/delme > /etc/rc.local;rm /tmp/delme)"]
```

### Patch: Icehouse on Precise KVM Fix

Due to the following bug, KVM is not loaded on Ubuntu 12.04 with the Icehouse packages.
https://bugs.launchpad.net/openstack-manuals/+bug/1313975

This patch modifies the juju charm to perform `modprobe kvm_intel` or `modprobe kvm_amd`, as appropriate to your architecture.

There is no configuration necessary for this patch.

### Patch: Duplicate Agents Fix

<https://bugs.launchpad.net/neutron/+bug/1254246>

There is a bug that can result in a duplicate entry for an agent in the agent table. When this is detected the Neutron server throws an exception which can result in bad behavior, such as aborting updates to the ovs_tunnel_endpoint table, resulting in lost connectivity.

There is no configuration necessary for this patch.


## Appendix: Juju Nova-Compute Scale-Out Strategy

This section describes how we handle the configuration of Juju when multiple compute nodes are deployed.

A key point to understand about Juju is that Juju configuration files specify the configuration for a service, which may be composed of multiple nodes (or units in Juju speak). But Juju does not support independent configuration for each unit within a service. *Each unit gets the same configuration\*.* You can use Juju “aliases” to get around this limitation (see next section).

This limitation on per-unit configuration probably explains why the stock OpenStack juju charms only work with configurations that work with one network address. Also, this allows charms that use those configurations to work in multiple environments like Amazon EC2 which only have one IP address.

\*Footnote:
<https://juju.ubuntu.com/docs/glossary.html>
“Service Unit - A running instance of a given juju Service. Simple Services may be deployed with a single Service Unit, but it is possible for an individual Service to have multiple Service Units running in independent machines. **All Service Units for a given Service will share the same Charm, the same relations, and the same user-provided configuration**.”

The workaround for per-unit configuration is the use of Juju aliases. The following shows the syntax for using Juju aliases.

```
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
```

Example syntax for deploying with aliases

```
juju deploy --config config.yaml nova-compute nova-compute0
juju deploy --config config.yaml nova-compute nova-compute1
```