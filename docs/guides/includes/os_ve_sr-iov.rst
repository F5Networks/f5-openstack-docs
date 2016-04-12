.. _os-ve-sr-iov:

**OPTIONAL**

If you’re using SR-IOV, you'll need to create a Neutron port to which the BIG-IP® will attach to when it launches. Make note of the port id, as you'll need it when launching the BIG-IP®.

    .. code-block:: text

        # neutron port-create [network-id] --binding:vnic-type direct

