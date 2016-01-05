---
layout: docs_page
title: F5 OpenStack LBaaSv1 Plugin Architecture and Design
url: {{ page.title | slugify }}
resource: true
---

# Overview

OpenStack defines standard services in terms of command line, API, and GUI interfaces. OpenStack services can be implemented via plugins. The F5 OpenStack LBaaSv1 plugin for the Neutron load balancing service uses existing OpenStack python classes to implement its primary service functions. The plugin consists of two packages -- driver and agent -- each of which contains python code, configuration scripts, and accompanying materials. The driver passes lbaas requests off to the agent, which provisions network resources. Multiple agents can run simultaneously; each agent handles requests for a specific subset of the tenants.

The F5 OpenStack LBaaSv1 Plugin is comprised of three major deliverables:

 1. driver package
 2. agent package
 3. F5 BIG-IP Application Delivery Controller

The necessary components for implementing load balancing via the F5 OpenStack LBaaSv1 plugin are:

 -  **Neutron Server**: Receives LBaaS API requests. Neutron is part of OpenStack and must be set up and working *before* the F5 LBaaSv1 plugin is installed. *F5 Networks does not sell, implement, or support OpenStack*.
 -  **F5 LBaaS Service Plugin**: Accepts F5 LBaaS requests from Neutron.
    -  **Driver** (F5PluginDriver): Handles F5 LBaaS requests; selects an agent and passes request to the agent via a messaging-based Remote Procedure Call.
    -  **Agent**: Responsible for handling the LBaaS requests for a subset of tenants. Each agent can utilize one BIG-IP Device Service Group ('DSG'; also called a cluster) to set up the service for its tenants. The agent loads an 'agent manager' to which it delegates all requests.
    -  **F5 LBaaS Agent Manager**: Runs in the F5 LBaaS agent. The agent manager loads the agent driver; handles requests from the service plugin; and passes request to the agent driver.
    -  **F5 LBaaS Agent Driver**: Runs in the F5 LBaaS agent. The agent driver takes requests from the agent manager and configures BIG-IP.
 -  **BIG-IP Device Service Group** \(DSG, or cluster\): One or more BIG-IP devices or BIG-IP VE instances.
__________________

# Configurations

## Single Agent

In a Single Agent setup \(see Figure 1\), each agent manages one BIG-IP DSG. 

<img src="{{ /f5-os-lbaasv1/architecture_single-agent-diagram.png | prepend: site.baseurl | prepend: site.url }}" alt="Figure 1"/>

## Multiple Agent

In a Multiple Agent setup \( see Figure 2\), multiple agents are installed; each agent handles a specific subset of the tenants automatically.

<img src="{{ /f5-os-lbaasv1/architecture_multi-agent-diagram.png | prepend: site.baseurl | prepend: site.url }}" alt= "Figure 2"/>

### Agent-Tenant Affinity

The F5 OpenStack LBaaSv1 service permanently maps a tenant to a particular agent \(Figure 3\).

<img src="{{ /f5-os-lbaasv1/architecture_agent-tenant-affinity.png | prepend: site.baseurl | prepend: site.url }}" alt="Figure 3"/>
__________________
# Components

## Driver

The F5 OpenStack LBaaSv1 plugin driver processes individual LBaaS API calls. It converts calls to F5 LBaaS Service Requests and passes them to the F5 LBaaS agent.

## Agent Manager

The F5 OpenStack LBaaSv1 plugin agent manager receives RPC calls and relays them to the agent driver.

## Agent Driver \(iControl\)

The F5 OpenStack LBaaSv1 plugin agent driver configures all aspects of the service. The driver leverages “Builder” classes to configure networking on BIG-IP via iControl REST API calls.

### Builder Classes

  - **Network Builder**: Used to configure all of the necessary networking for a service definition on BIG-IP.
  - **LBaaS Builder**: Creates high-level objects for the service, such as the pool, pool members, vip, and monitors. It can either deploy an iApp to BIG-IP or configure BIG-IP directly. 

## Configuration Managers

Configuration managers address object-definition conflicts that can arise from differences in terminology. 
 
 - **tenant**, **l2**, **selfip**, **snat**, **pool**, and **vip** managers: Convert OpenStack LBaaSv1 service-defined objects to their corresponding F5-defined counterparts. 
 - **vCMP manager**: Talks to the vCMP host to assign VLANs to guests.

__________________
# Service Definition

Requests come in to the F5 OpenStack LBaaSv1 plugin as full service definitions. The driver looks up networks, mac entries, segmentation info, etc., and places the information in a service object, which is a python dictionary variable. The driver then passes that service object to the agent. Figure 4 shows a simplified example of a service definition.

<img src="{{ /f5-os-lbaasv1/architecture_service-definition.png | prepend: site.baseurl | prepend: site.url }}" alt="Figure 4"/>
__________________
# Plugin Classes

The F5 OpenStack LBaaSv1 Plugin driver runs in the Neutron process and has access to all of the methods and data used by Neutron.

`F5PluginDriver` -- Called as the F5 LBaaS "provider" in the Neutron server config file. It receives the method calls for the LBaaS service. This class is derived from a Neutron class named "LoadBalancerAbstractDriver".
`LoadBalancerAgentApi` -- Interface for RPC calls to agents. 
`LoadBalancerCallbacks` -- Handles requests from the agent.
`TenantScheduler` -- Assigns an agent to handle an operation on a load-balancing pool.

## Agent Processes

The F5 OpenStack LBaaSv1 Plugin agent runs as a standalone process with its own startup, configuration, and logging files. 

 - **execution script**: */usr/bin/f5-bigip-lbaas-agent*. A short python program which imports the agent and runs the main function. 
 - **startup script**: located in */etc/init* directory. Passes all the appropriate command line options to specify the config and logging files.
 - **main agent process entry point**: *agent.py*. The main program creates an instance of LbaasAgentManager (from the agent\_manager module), which in turn creates an instance of the agent driver, which is, by default, the iControlDriver class in the icontrol\_driver module.

__________________
# RPC Classes

## Overview

The LBaaS Driver and Agents communicate using the Neutron server's RPC classes.

### Driver to Agent

The driver calls the agent for the following:

-  process all LBaaS methods.

### Agent to Driver

The agent calls the driver for the following:

-  update the status of LBaaS objects;
-  allocate a port on a Neutron network;
-  make a query to Neutron.

