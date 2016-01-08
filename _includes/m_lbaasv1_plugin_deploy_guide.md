## Overview

{% include /f5-os-lbaasv1/t_driver_overview.md %}

{% comment %}# Prerequisites

 tbd {% endcomment %}

## Deploying BIG-IPs

{% include /f5-os-lbaasv1/m_deploy_big-ip.md %}

### Licensing

{% include /f5-os-lbaasv1/t_big-ip_licensing.md %}

### Provisioning

{% include /f5-os-lbaasv1/t_big-ip_provisioning.md %}

### Data Network Connectivity

{% include /f5-os-lbaasv1/t_big-ip_data_network_connectivity.md %}

## Deploying the F5 OpenStack LBaaSv1 Plugin

{% comment %} tbd {% endcomment %}

### Install the F5 OpenStack LBaaSv1 Plugin Driver

{% include /f5-os-lbaasv1/t_sample_environment_diagram_explained.md %}

<img src="{{ "/f5-os-lbaasv1/openstack_lbaas_env_example.png" | prepend: site.baseurl | prepend: site.url }}" alt="Figure 1" width="500">

#### RedHat/CentOS

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_redhat-centos.md %}

#### Ubuntu

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_overview-note.md %}

### Install the Plugin Agent

{% include /f5-os-lbaasv1/t_agent_overview.md %}

#### Placement

{% include /f5-os-lbaasv1/t_agent_placement.md %}

### Install the F5 OpenStack LBaaS Plug-in Agent

Use the command set for your distribution to install the Neutron Gateway Packages for the F5 LBaaS Agent.

{% include /f5-os-lbaasv1/t_install_agent_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_agent_redhat-centos.md %}

{% include /f5-os-lbaasv1/t_install_agent_note.md %}

#### Installing Additional Agents

Complete both of the installation steps \(install, then stop\) on each host on which you want the F5 LBaaS Agent to run.

#### Set up the Agent

{% include /f5-os-lbaasv1/t_install_agent_setup.md %}

**Table 1**
{% include /f5-os-lbaasv1/r_os_lbaas_agent_config_settings.md %}

#### Start the Agent

{% include /f5-os-lbaasv1/t_install_agent_start_note.md %}

{% include /f5-os-lbaasv1/t_install_agent_start_ubuntu-redhat-centos.md %}

#### Check the Agent Status

{% include /f5-os-lbaasv1/t_install_agent_status_ubuntu-redhat-centos.md %}

Figure 2. 

<img src="{{ "/f5-os-lbaasv1/lbaas-agent-status.png" | prepend: site.baseurl | prepend: site.url }}" alt="Figure 2" width="500">

{% include /f5-os-lbaasv1/t_install_agent_check_status_note.md %}

### Configure the Neutron Service to use the F5 LBaaSv1 Plugin

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_set-default-lbaas-service.md %}

#### RedHat/CentOS

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_redhat-centos.md %}

#### Ubuntu

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_ubuntu.md %}

1. Save the changes to the Neutron server config file.

### Restart the Neutron Server

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_restart-ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_restart_redhat-centos.md %}

### Enable LBaaS in OpenStack Horizon

{% include /f5-os-lbaasv1/t_install_agent_enable_lbaas.md %}

### Restart the web server to make the setting take effect:

{% include /f5-os-lbaasv1/t_install_agent_restart_webserver_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_agent_restart_webserver_redhat-centos.md %}

## Additional Information
{% comment %}
### BIG-IP Cluster Scope
{% endcomment %}

### BIG-IP Tenant Scheduler 

{% include /f5-os-lbaasv1/t_f5-lbaasv1-plugin_tenant-scheduler.md %}

{% comment %}
# See Also 

[Troubleshooting](#)
[Limitations](#)
[Openstack Deployment Tips](#)
{% endcomment %}