# Overview

{% include /f5-os-lbaasv1/t_agent_overview.md %}

## Prerequisites

{% include /f5-os-lbaasv1/t_agent_prerequisites.md %}

## Placement

{% include /f5-os-lbaasv1/t_agent_placement.md %}

# Installing the F5 OpenStack LBaaS Plugin Agent

Use the command set for your distribution to install the Neutron Gateway Packages for the F5 LBaaS Agent.

{% include /f5-os-lbaasv1/t_install_agent_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_agent_redhat-centos.md %}

{% include /f5-os-lbaasv1/t_install_agent_note.md %}

## Stop the Agent

{% include /f5-os-lbaasv1/t_install_agent_stop_ubuntu-redhat-centos.md %}

## Installing Additional Agents

Complete both of the installation steps \(install, then stop\) on each host on which you want the F5 LBaaS Agent to run.

# Set up the Agent

{% include /f5-os-lbaasv1/t_install_agent_setup.md %}

Table 1.<a name="Table1"></a>
{% include /f5-os-lbaasv1/r_os_lbaas_agent_config_settings.md %}

# Start the Agent

{% include /f5-os-lbaasv1/t_install_agent_start_note.md %}

{% include /f5-os-lbaasv1/t_install_agent_start_ubuntu-redhat-centos.md %}

# Check the Agent Status

{% include /f5-os-lbaasv1/t_install_agent_status_ubuntu-redhat-centos.md %}

**Figure 1.** 

<img src="{{ "/f5-os-lbaasv1/lbaas-agent-status.png" | prepend: site.baseurl | prepend: site.url }}" alt="Figure 1"/>

{% include /f5-os-lbaasv1/t_install_agent_check_status_note.md %}

# Enable LBaaS in OpenStack Horizon

{% include /f5-os-lbaasv1/t_install_agent_enable_lbaas.md %}

## Restart the web server to make the setting take effect:

{% include /f5-os-lbaasv1/t_install_agent_restart_webserver_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_agent_restart_webserver_redhat-centos.md %}

