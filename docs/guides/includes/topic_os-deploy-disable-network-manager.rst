.. _os-deploy-disable-network-manager:

Disable Network Manager
```````````````````````

Once the operating system is installed, you'll need to disable Network Manager. It will be replaced by the standard network service for all interfaces that will be used by OpenStack Networking (Neutron).


To verify if Network Manager is enabled:

.. code-block:: shell

     $ sudo systemctl status NetworkManager


The system displays an error if the Network Manager service is not currently installed:

.. code-block:: shell

    error reading information on service NetworkManager: No such file or directory


If you see this error, jump ahead to :ref:`Install Software Repositories <os-deploy-install-software-repos>`.

If Network Manager is running, run the following commands to disable it.

.. code-block:: shell

    $ sudo systemctl stop NetworkManager
    $ sudo systemctl disable NetworkManager
    $ sudo systemctl enable network


