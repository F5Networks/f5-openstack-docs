Assign a Floating IP Address
````````````````````````````

Use the OpenStack dashboard to assign a floating IP address to the instance.

1. Go to :menuselection:`Project --> Compute --> Instances`, then choose :guilabel:`Associate Floating IP` from the drop-down menu in the :menuselection:`Actions` column.

2. Select a :guilabel:`Floating IP` from the :guilabel:`IP Address` drop-down menu.

3. In the :guilabel:`port` drop-down, select the port for your BIG-IP® image that corresponds to the external VLAN you set up for your BIG-IP®.

4. Click :guilabel:`Associate`.

.. tip::

    If no floating IP addresses are available, click ``+`` to generate one, then click :guilabel:`Allocate`.

