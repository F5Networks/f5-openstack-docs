#Overview: Setting up OpenStack LBaaS

This document provides instructions for installing the F5 OpenStack Load Balancing as a Service (LBaaS) plug-in. Using the OpenStack LBaaS user interface, command-line interface, or REST interface, you can provision OpenStack LBaaS resources (virtual IP addresses, pools, pool members, health monitors). The plug-in leverages the BIG-IP device's load balancing capabilities to support your OpenStack LBaaS resources.

# Task summary
Installing the LBaaS plug-in for OpenStack
Before installing the F5 LBaaS plug-in, the following requirements must be met.

- Install and set up an OpenStack host environment.
- Install OpenStack software and configure it appropriately.
- Install the OpenStack Neutron service.
- Documentation for how to install and configure OpenStack components can be found at: http://docs.openstack.org/.

The system administrator must install the F5 Load Balancing as a Service (LBaaS) plug-in so that you can then provision a device on OpenStack.

1. Copy the F5 LBaaS plug-in from the BIG-IQ device. On the BIG-IQ device, the plug-in is located at /cloud-plugins/openstack/lbaas.
2. Install the plug-in driver on your OpenStack control host. Choose the driver that corresponds to your OpenStack control host operating system:
  
  - For a Red Hat derivative, install the plug-in driver by running the following command: $ rpm -i f5-lbaas-driver.rpm.
  - For a Debian derivative, install the plug-in driver by running the following command: $ dpkg -i f5-lbaas-driver.deb.
  **Tip:** The .rpm and .deb package names may differ slightly from the examples provided here.
  **Important:** You may need increased privileges to install the driver.

3. Install the plug-in driver on your OpenStack network host. Choose the driver that corresponds to your OpenStack network host operating system:
 
  - For a Red Hat derivative, install the plug-in driver by running the following command: $ rpm -i f5-lbaas-driver.rpm.
  - For a Debian derivative, install the plug-in driver by running the following command: $ dpkg -i f5-lbaas-driver.deb.
  **Tip:** The .rpm and .deb package names may differ slightly from the examples provided here.
  **Important:** You may need increased privileges to install the driver.

4. Install the plug-in agent on your OpenStack network host based on your OpenStack network host operating system:
  
  - For a Red Hat derivative, install the agent by running the following command: $ rpm -i f5-lbaas-agent.rpm
  - For a Debian derivative, install the agent by running the following command: $ dpkg -i f5-lbaas-agent.deb
  **Tip:** The .rpm and .deb package names may differ slightly from the examples provided here.
  **Important:** You may need increased privileges to install the driver.

Once the plug-in driver and agent are successfully installed, you need to configure the plug-in.

# Configuring the LBaaS plug-in for OpenStack
You must configure the F5 Load Balancing as a service (LBaaS) plugin so that you can then provision OpenStack LBaaS resources (such as virtual IP addresses, pools, pool members, or health monitors).

1. On your OpenStack control host, configure the OpenStack Neutron service to use the F5 LBaaS plug-in.

  - Use a text editor to open the OpenStack Neutron service configuration file neutron.conf. On the OpenStack network host, the configuration file is located at /etc/neutron/.
  - Locate the section where you can configure OpenStack Neutron extension services. You can find this section by searching for [service_providers].
  - Add an entry for the F5 LBaaS plug-in similar to the following: service_provider=LOADBALANCER:f5:neutron.services. loadbalancer.drivers.f5.plugin_driver.F5PluginDriver. 
  **Tip:**If you want the F5 LBaaS plug-in to provide service for OpenStack LBaaS by default, add :default to the end of the entry.

2. On your OpenStack network host, use a text editor to revise the plug-in agent configuration file f5-device-lbaas-agent.ini. On the OpenStack network host, the configuration file is located at /etc/neutron/.
Set the value of the use_unsupported_community_plugin_configuration field to False.
Revise each of the remaining settings located in the BIG-IQ Device Settings (Supported Settings) section of the configuration file. If you have questions about a particular entry, refer to the inline comments for details.
When you complete all of the revisions, save and close the configuration file.
On the OpenStack control host, edit the OpenStack Horizon service configuration file to configure the OpenStack Horizon service to display the LBaaS service in the OpenStack user interface.
Tip: The configuration file is located at /etc/openstack-dashboard/local_settings.
In the configuration file, locate the OpenStack Neutron GUI settings, by searching for OPENSTACK_NEUTRON_NETWORK.
Set the value of the enable_lb key to True.
When you complete this revision, save and close the configuration file.
On the OpenStack compute host, edit the OpenStack Nova policy file to allow for statistics to be collected for OpenStack users.
Tip: The OpenStack Nova policy file is named policy.json. This file is located at /etc/nova/.
In the policy file, locate the statistics collection section, by searching for compute_extension:server_diagnostics.
Set the value of the compute_extension:server_diagnostics key to rule:admin_or_owner.
When you complete this revision, save and close the policy file.
To reload the configuration changes just completed, restart the following services: neutron-server, f5-bigip-lbaas-agent, and httpd.
Once the plug-in is successfully configured, you need to configure the BIG-IP system instance.
Configuring the BIG-IP instance
You must create a BIG-IP instance in your OpenStack project before you can configure the BIG-IP system for use with the LBaaS plug-in.
Each BIG-IP instance you create must be configured so it can be used as part of an OpenStack LBaaS.
Note: All of the steps you perform in this task, except for one, are documented in the BIG-IP System: Initial Configuration guide. The one exception, configuring redundant device options, is documented in the BIG-IP Device Service Clustering: Administration guide.
Activate the license for the BIG-IP system.
Provision the BIG-IP modules you plan to use.
Configure the general properties.
Specify the password for the Admin account. The password must match the one specified for the bigip_management_password when you configured the LBaaS plug-in.
Configure the internal network configuration. The value you use for the internal VLAN must use the value of the fixed IP and subnet for your OpenStack internal network.
Configure the external network configuration. The value you use for the external VLAN must use the value of the fixed IP and subnet for your OpenStack external network. Once you specify the external network, you have the first BIG-IP instance configured for LBaaS use.
Configure the redundant device options to specify the BIG-IP device peers required for load balancing. Refer to the BIG-IP Device Service Clustering: Administration guide for step-by-step instruction.
Provisioning OpenStack LBaaS resources
Before you can provision LBaaS resources on OpenStack, you must have the following elements in place.
LBaaS plug-in installed and configured with credentials for the BIG-IQ system and BIG-IP devices.
BIG-IP system instance installed and configured.
Using the OpenStack user interface, you create and configure the resources needed to support LBaaS.
Log in to the OpenStack user interface and then select Load Balancers in the navigation pane.
Create a pool.
Click the Add Pool button to create an OpenStack pool.
Type in a name for the pool.
In the Provider list, select f5.
In the Subnet list, select the subnet in which your OpenStack pool members are located.
In the Protocol list, select the protocol appropriate for your network.
In the Load Balancing Method list, select the type of load balancing appropriate for your network.
Create a virtual IP server (VIP) and associate it with the just created pool.
Click the More button for the pool and then select Add VIP.
Type in a name for the VIP.
In the Protocol Port list, select the protocol appropriate for your network.
In the Load Balancing Method list, select the type of load balancing appropriate for your network.
Create a health monitor that you can associate with the pool.
Click Monitors > Add Monitors to create the new OpenStack health monitor.
Make appropriate selections for Type, Delay, Timeout, and Max Retries.
In the Protocol Port list, select the protocol appropriate for your network.
In the Load Balancing Method list, select the type of load balancing appropriate for your network.
Click Pools > More > Add Health Monitor to associate the health monitor with the pool.
Add pool members to the pool.
Click Members > Add Member.
Make appropriate selections for Pool, Member(s), and Protocol Port.
If you want the virtual server (VIP) to be publicly accessible and it is not, then after you create the virtual server you must create a floating IP address and associate it with the OpenStack port of the virtual server. Documentation for this task is available on the OpenStack website at: http://docs.openstack.org/.
Example of an OpenStack LBaaS environment
This illustration is an example of a configured LBaaS environment.