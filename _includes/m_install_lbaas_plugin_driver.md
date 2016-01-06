# Overview

{% include /f5-os-lbaasv1/t_driver_overview.md %}

{% include /f5-os-lbaasv1/t_sample_environment_diagram_explained.md %}

<img src="{{ "/f5-os-lbaasv1/media/openstack_lbaas_env_example.png" | prepend: site.baseurl | prepend: site.url }}" alt="Figure 1" />

## Prerequisites

{% include /f5-os-lbaasv1/t_driver_prerequisites.md %}

# Tasks

## Install the F5 OpenStack LBaaSv1 Plugin Driver

{% include /f5-os-lbaasv1/t_install_driver_overview.md %}

### RedHat/CentOS

{% include //f5-os-lbaasv1/t_install_driver_neutron_server_redhat-centos.md %}

### Ubuntu

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_overview-note.md %}

## Configure the Neutron Service to use the F5 LBaaSv1 Plugin

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_set-default-lbaas-service.md %}

### RedHat/CentOS

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_redhat-centos.md %}

### Ubuntu

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_ubuntu.md %}

1. Save the changes to the Neutron server config file.

## Restart the Neutron Server

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_restart-ubuntu.md %}

{% include /f5-os-lbaasv1/t_install_driver_neutron_server_restart_redhat-centos.md %}
