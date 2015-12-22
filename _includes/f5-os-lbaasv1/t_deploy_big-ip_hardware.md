# Deploying BIG-IP Hardware

The first thing to do is the basic hardware setup, which includes:

-   Rack the device and connect the power cables.

-   Connect the BIG-IP to your switch.

-   Turn on the BIG-IP.

-   Go through the setup process, including licensing and provisioning.

We assume that if you are using BIG-IP hardware then you intend to use
the device for multitenant networking. 

## Licensing

In order to use multitenancy with tunneling support, you will need a
BIG-IP License with “SDN Services” feature.

`tmsh show sys license | grep SDN`

## Provisioning

We also recommend that you provision for extra management memory to
support many route domains:

`tmsh modify sys db provision.extramb { value 500 }`

## Data network connectivity

You'll need to connect the BIG-IP hardware to the OpenStack networking infrastructure. 

### VLAN

For VLAN based OpenStack networking, the BIG-IP should be connected to a VLAN trunk. 

### Tunneling 

For tunnel based OpenStack networking, the BIG-IP should be connected to the physical underlay network used for tunneling. Furthermore, a VLAN and self-IP address must be configured. Later in the instructions, you will configured the plug-in with the details of how you have configured the BIG-IP, such as which interface you connected to the VLAN trunk in the case of VLANs.
