---
layout: docs_page
title: Install the F5 OpenStack LBaaSv1 Plug-In
tags: lbaasv1, plug-in
resource: true
---

# Overview

{% include f5-os-lbaasv1/overview.md %}

## Prerequisites

{% include f5-os-lbaasv1/prerequisites.md %}

# Tasks

## Install the F5 LBaaS Plug-in on the Neutron Server

{% include f5-os-lbaasv1/install_the_driver_neutron_server_overview-note.md %}

### RedHat/CentOS

{% include f5-os-lbaasv1/install_the_driver_neutron_server_redhat-centos.md %}

### Ubuntu

{% include f5-os-lbaasv1/install_the_driver_neutron_server_ubuntu.md %}

## Configure the Neutron Server

{% include f5-os-lbaasv1/install_the_driver_neutron_server_set-default-lbaas-service.md %}

### RedHat/CentOS

{% include f5-os-lbaasv1/install_the_driver_neutron_server_redhat-centos.md %}

### Ubuntu

{% include f5-os-lbaasv1/install_the_driver_neutron_server_ubuntu.md %}

1. Save the changes to the Neutron server config file.

## Restart the Neutron Server

{% include f5-os-lbaasv1/install_the_driver_neutron_server_restart-ubuntu.md %}

{% include f5-os-lbaasv1/install_the_driver_neutron_server_restart_redhat-centos.md %}
