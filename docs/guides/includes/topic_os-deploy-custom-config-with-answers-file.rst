.. _os-deploy-with-answers_file:

Custom Configuration with an Answers File
`````````````````````````````````````````

Instead of using the ``--allinone`` flag, we generated an answers file and edited it to enable the services we want and disable some options we don't want.


.. note::

    The configurations in our answers file are basically equivalent to running the following command:

    .. code-block:: shell

        $ packstack --os-heat-install=y --os-debug-mode=y --os-neutron-lbaas-install=y --provision-demo=n


To generate an answers file (replace ``[answers-file]`` with the file name of your choice):

.. code-block:: shell

    $ packstack --gen-answer-file=[answers-file].txt

For our custom all-in-one installation, we changed the following entries in the answers file. You can also customize your admin user account credentials here, if desired.

.. code-block:: text

    $ sudo vi [answers-file].txt
    ...
    # Specify 'y' to install OpenStack Orchestration (heat). ['y', 'n']
    CONFIG_HEAT_INSTALL=y
    ...
    # Specify 'y' to install Nagios to monitor OpenStack hosts. Nagios
    # provides additional tools for monitoring the OpenStack environment.
    # ['y', 'n']
    CONFIG_NAGIOS_INSTALL=n
    ...
    # Specify 'y' if you want to run OpenStack services in debug mode;
    # otherwise, specify 'n'. ['y', 'n']
    CONFIG_DEBUG_MODE=y
    ...
    # Password to use for the Identity service 'admin' user.
    CONFIG_KEYSTONE_ADMIN_PW=57a791d9e7d849b4
    ...
    # Specify 'y' to enable the EPEL repository (Extra Packages for
    # Enterprise Linux). ['y', 'n']
    CONFIG_USE_EPEL=y
    ...
    # Specify 'y' to install OpenStack Networking's Load-Balancing-
    # as-a-Service (LBaaS). ['y', 'n']
    CONFIG_LBAAS_INSTALL=y
    ...
    # Specify 'y' to provision for demo usage and testing. ['y', 'n']
    CONFIG_PROVISION_DEMO=n
    ...

.. note::

    When you generate an answers file, Packstack automatically includes the IP address of the machine on which the file is generated in the ``CONTROLLER_HOST``, ``COMPUTE_HOSTS``, & ``NETWORK_HOSTS`` entries.

    If you'd like Packstack to configure more than one host, you'll need to add their IP addresses to the answers file. As shown in the example below, multiple values should be comma-separated, without a space in between.

    .. code-block:: text

        $ sudo vi [answers-file].txt
        ...
        # IP address of the server on which to install OpenStack services
        # specific to the controller role (for example, API servers or
        # dashboard).
        CONFIG_CONTROLLER_HOST=[IP_ADDRESS]

        # List of IP addresses of the servers on which to install the Compute
        # service.
        CONFIG_COMPUTE_HOSTS=[IP_ADDRESS],[IP_ADDRESS]

        # List of IP addresses of the server on which to install the network
        # service such as Compute networking (nova network) or OpenStack
        # Networking (neutron).
        CONFIG_NETWORK_HOSTS=[IP_ADDRESS],[IP_ADDRESS]
        ...

