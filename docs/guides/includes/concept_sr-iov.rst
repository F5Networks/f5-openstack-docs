.. _sr-iov-overview:

SR-IOV
``````

BIG-IP® VE instances can provide improved throughput using Single root I/O virtualization (SR-IOV) to interact directly with underlying 10 gigabit Network Interface Card (NIC) adapters. See F5® Support `SOL17204 <https://support.f5.com/kb/en-us/solutions/public/17000/200/sol17204.html>`_ for more information.

If you’re using SR-IOV, use the command shown below to create a Neutron port and make note of the port ID. You will need to provide this information when launching the BIG-IP®.

    .. code-block:: text

        $ neutron port-create [network-id] --binding:vnic-type direct

