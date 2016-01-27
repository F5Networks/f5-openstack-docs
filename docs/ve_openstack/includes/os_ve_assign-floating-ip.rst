.. _os_ve_assign-floating-ip:

Assign a Floating IP
====================

Once the instance is running, you'll need to assign a floating IP from the external network to the BIG-IP.

 1. Go to :menuselection:`Project --> Compute --> Instances`, then choose :guilabel:`Associate Floating IP` from the drop-down menu in the :menuselection:`Actions` column.
 2. Select a :guilabel:`Floating IP` from the :guilabel:`IP Address` drop-down menu\*.
 3. In the :guilabel:`port` drop-down, select the port for your BIG-IP image that corresponds to ``bigip_external``.
 4. Click :guilabel:`Associate`.

\* If no floating IP addresses are available, click ``+`` to generate one, then click :guilabel:`Allocate`.
