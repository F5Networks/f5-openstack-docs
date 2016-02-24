You'll need to connect the BIG-IP hardware to the OpenStack networking infrastructure. See 

### VLAN

For VLAN-based OpenStack networking, the BIG-IP should be connected to a VLAN trunk. 

### Tunneling 

For tunnel based OpenStack networking, the BIG-IP should be connected to the physical underlay network used for tunneling. Furthermore, a VLAN and self-IP address must be configured. Later in the instructions, you will configured the plug-in with the details of how you have configured the BIG-IP, such as which interface you connected to the VLAN trunk in the case of VLANs.