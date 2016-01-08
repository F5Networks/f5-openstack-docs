- Download the F5 OpenStack Plug-in package from [F5's DevCentral](https://devcentral.f5.com/d/openstack-neutron-lbaas-driver-and-agent).

- Install the [F5 LBaaS Plug-in Driver]({{ site.url }}{{ site.baseurl }}/lbaasv1-plugin-install-driver/) before you deploy the Agent. 
  
- Set up at least one BIG-IP cluster - or, 'device service group \(DSG\)' -  before you deploy the Agent. You'll need administrator access to the BIG-IP and all cluster members to do so.

**Tip:** Make note of the IP addresses and credentials for the devices in the cluster; you'll need to enter them in the Agent config file\(s\).

- Agent config file\(s\) \([see Table 1]({{ site.url }}{{ site.baseurl }}/{{ page.url }}#Table1)). The agent installation process creates a config file with default settings; you'll need to manually create a separate file for each Agent you deploy. 
