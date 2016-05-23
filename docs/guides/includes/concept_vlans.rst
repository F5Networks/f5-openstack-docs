.. _concept_vlans:

VLANs
`````

VLANs represent a logical collection of hosts that can share network resources. At minimum, BIG-IP® needs access to two VLANs: the external network and the internal network.

For a commonly-used, basic load balancing set-up, you'll need three VLANS: the external network, the internal data subnet, and the internal management subnet.

:ref:`Device Service Clustering <ha-clustering>` requires additional VLANs.

