---

---

#F5 LBaaS Plug-in Architecture and Design

##Overview

OpenStack defines standard services in terms of command line, API, and
GUI interfaces. Services can be implemented via plug-ins. 

The F5 LBaaS plug-in for the Neutron load balancing service uses existing OpenStack python classes to implement its primary service functions.

The F5 LBaaS plug-in is delivered as two packages, each of which contains python code, configuration scripts, and accompanying materials: 

-   the Plug-in; 
-   the Agent. 

The F5 LBaaS Plug-in passes LBaaS requests off to the F5 LBaaS Agent, which provisions network resources. 

Multiple agents can run simultaneously; each agent handles requests for a specific subset of the tenants.
_____________

## Components

The F5 LBaaS solution is comprised of three major deliverables:

 1. F5 LBaaS Plug-in Package

 2. F5 LBaaS Agent Package

 3. F5 BIG-IP Application Delivery Controller

The deliverables can be broken down into the following major solution
components:

 -   **Neutron Server**: Receives LBaaS API requests. Neutron is part of OpenStack and must be set up and working *before* the F5 LBaaS solution is installed. *F5 Networks does not sell, implement, or support OpenStack*.

 -   **F5 LBaaS Service Plug-in**: Accepts F5 LBaaS requests from Neutron.

 -   **F5 LBaaS Service Plug-in Driver (F5PluginDriver)** \(loaded by the F5 service plug-in\): Handles F5 LBaaS requests on behalf of the Plug-in; selects an Agent; passes request to the Agent via a messaging-based Remote Procedure Call.

 -   **F5 LBaaS Agent**: Responsible for handling the LBaaS requests for a subset of tenants. Each agent can utilize one BIG-IQ and/or one BIG-IP Device Service Group ('DSG'; also called a cluster) to set up the service for its tenants. The Agent loads an Agent Manager, to which it delegates all requests.

 -   **F5 LBaaS Agent Manager**: Runs in the F5 LBaaS Agent. The Agent Manager loads the F5 Agent Driver; handles  requests from the Service Plug-in; and passes request to the F5 Agent Driver.

 -   **F5 LBaaS Agent Driver**: Runs in the F5 Agent. The Agent Driver takes requests from the Agent Manager and configures BIG-IP or passes them to BIG-IQ \(depending on the setup being used\).

 -   **BIG-IP Device Service Group** \(DSG, or cluster\): One or more BIG-IP devices or BIG-IP VE instances.
__________________

## Configurations

### Single Agent

In a Single Agent setup \(Figure 1\), each agent manages one BIG-IP DSG. 

![](architecture_single-agent-diagram.png "Figure 1")

### Multiple Agent

In a Multiple Agent setup \(Figure 2\), multiple agents are installed; each agent automatically handles a specific subset of the tenants.

![](architecture_multi-agent-diagram.png "Figure 2")

### Agent-Tenant Affinity

The F5 LBaaS solution permanently maps a tenant to a particular agent \(Figure 3\).

![](architecture_agent-tenant-affinity.png "Figure 3")
_____________

## Components

### Plug-in Driver

The plug-in driver processes individual LBaaS API calls. It converts calls to F5 LBaaS Service Requests and passes them to the F5 LBaaS agent.

### Agent Manager

The agent manager receives RPC calls and relays them to the agent driver.

### Agent Driver \(iControl\)

The agent driver configures all aspects of the service. The driver leverages  “Builder” classes to configure networking on BIG-IP.

#### Builder Classes

  - **Network Builder**: Used to configure all of the necessary networking for a service definition on BIG-IP.

  - **LBaaS Builder**: Creates high-level objects for the service, such as the pool, pool members, vip, and monitors. It can either deploy an iApp to BIG-IP or configure BIG-IP directly. 

### Configuration Managers

Configuration managers address object-definition conflicts that can arise from differences in terminology. 
 
 - **tenant**, **l2**, **selfip**, **snat**, **pool**, and **vip** managers: Convert OpenStack LBaaS service-defined objects to their corresponding F5-defined counterparts. 
 - **vCMP manager**: Talks to the vCMP host to assign VLANs to a guest.
_____________

## Service Definition

Requests come in to the F5 LBaaS agent as full service definitions. The driver looks up networks, mac entries, segmentation info, etc., and places the information in a service object (which is a python dictionary variable). It then passes that service object to the agent.

Figure 4 is a simplified example of a service definition.

![](architecture_service-definition.png "Figure 4")


## Plug-in Classes

The F5 LBaaS Plug-in Driver runs in the Neutron process and has access
to all the methods and data that Neutron uses.

 - F5PluginDriver: Called as the F5 LBaaS "provider" in the Neutron server config file. It receives the method calls for the LBaaS service. This class is derived from a Neutron class named "LoadBalancerAbstractDriver".

 - LoadBalancerAgentApi: Interface for RPC calls to agents. 

 - LoadBalancerCallbacks: Handles requests from the agent.

 - TenantScheduler: Assigns an agent to handle an operation on a load-balancing pool.

### Agent Processes

The agent runs as a standalone process with its own startup, configuration, and logging files. 

The **execution script** -- a short python program which imports the agent and runs the main function -- is */usr/bin/f5-bigip-lbaas-agent*. 

The **startup script** -- which passes all the appropriate command line options to specify the config and logging files -- is in the */etc/init* directory.

The **main agent process entry point** is in *agent.py*. The main program
creates an instance of LbaasAgentManager (from the agent\_manager
module), which in turn creates an instance of the agent driver, which
is, by default, the iControlDriver class in the icontrol\_driver module.
_________________

## RPC Classes

### Overview

The LBaaS Driver and Agents communicate using the Neutron server's RPC classes.

#### Driver to Agent

The driver calls the agent for the following:

-  process all LBaaS methods.

#### Agent to Driver

The agent calls the driver for the following:

-  update the status of LBaaS objects;

-  allocate a port on a Neutron network;

-  make a query to Neutron.

# Additional Resources

-
-
-
