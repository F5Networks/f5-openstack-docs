.. _os-config-set-dhcp:

Set the DHCP Domain
```````````````````

If you're using DHCP to acquire IP addresses automatically, replace the default ``dhcp_domain`` in the file :file:`/etc/neutron/dhcp_agent.ini` with your local domain.

If you're using static IP address assignment, this step shouldn't be necessary.

.. code-block:: text

    $ sudo vi /etc/neutron/dhcp_agent.ini
    ...
    # Domain to use for building the hostnames
    # dhcp_domain = openstacklocal
    dhcp_domain = [something.example.com]
    ...

