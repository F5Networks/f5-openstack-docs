.. _os-deploy-guide:

OpenStack Deployment Guide
==========================

Overview
--------
This guide will allow a user who is largely unfamiliar with OpenStack to create an all-in-one, bare metal installation of `OpenStack RDO <https://www.rdoproject.org/>`_. The instructions presented here guide you through installing an operating system and using `Packstack <https://wiki.openstack.org/wiki/Packstack>`_ to deploy OpenStack.

The information presented here is based on the RDO project `Quickstart guide <https://www.rdoproject.org/install/quickstart/>`_. We've found the RDO documentation set extremely helpful and recommend consulting it for any issues you may encounter.

.. caution::

    This guide describes how to deploy OpenStack using Packstack. Both are open source projects that are continually changing. You may see some variations between the commands presented here and those available in your environment.


Prerequisites
`````````````
- Hardware: Machine with at least 4GB RAM, processors with hardware virtualization extensions, and at least one network adapter. For more information, see the OpenStack installation guide for |openstack|.

- Software: Red Hat Enterprise Linux (RHEL) 7 is the minimum recommended version you can use with OpenStack |openstack|. You can also use any of the equivalent versions of RHEL-based Linux distributions (CentOS, Scientific Linux, etc.). x86\_64 is currently the only supported architecture.

Releases and Versioning
```````````````````````
See :ref:`F5 OpenStack Releases and Support Matrix <releases-and-versioning>`.

Getting Started
---------------

First, you need to install an operating system on your hardware. We installed CentOS 7 on one machine which will serve as the controller,
compute, and network nodes (referred to in this document as an 'all-in-one' configuration). Because our lab uses DHCP, the machine was able to acquire an IP address automatically. You may need to manually assign a static IP address, which can be easily done as part of the CentOS installation.

Users
`````

When installing CentOS, create a root user and a user with administrative priveleges. Our root user has the password 'default'; our admin user is 'manager', with the password 'manager'. In all command blocks shown in this guide, the assumed user is represented by the command prompt symbol:

.. code-block:: text

    # = root
    $ = admin


Disable Network Manager
```````````````````````

Once the operating system is installed, you'll need to disable Network Manager. It will be replaced by the standard network service for all interfaces that will be used by OpenStack Networking (Neutron).

To verify if Network Manager is enabled:

.. code-block:: text

     # systemctl status NetworkManager


The system displays an error if the Network Manager service is not currently installed:

.. code-block:: text

    error reading information on service NetworkManager: No such file or directory


If you see this error, jump ahead to :ref:`Install Software Repositories <install-software-repositories>`.

If Network Manager is running, run the following commands to disable it.

.. code-block:: text

    # systemctl stop NetworkManager
    # systemctl disable NetworkManager
    # systemctl enable network


.. _install-software-repositories:

Install Software Repositories
`````````````````````````````

.. note::

    You can run these commands as root or manager. If you're logged in as manager (the admin user), you will need to use ``sudo``.

1. Update your current software packages:

.. code-block:: text

    # yum install update -y


2. Install the software package for the OpenStack |openstack| release:

.. code-block:: text

    # yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-1.noarch.rpm


3. Install the software package for Packstack.

.. code-block:: text

    # yum install -y openstack-packstack


.. _os_all-in-one_deployment:

Deploy OpenStack using Packstack
--------------------------------

The quickest and easiest way to deploy OpenStack is via Packstack's ``--allinone`` option. This sets up a single machine as the controller, compute, and network node. Be aware that this configuration, while fairly simple to execute, is fairly limited. By default, the all-in-one configuration doesn't have `Heat <https://wiki.openstack.org/wiki/Heat>`_ and `Neutron LBaaS <https://wiki.openstack.org/wiki/Neutron/LBaaS>`_ enabled. For this reason, **we don't recommend** going with the default ``--allinone`` deployment. Instead, you can customize your all-in-one deployment with an answers file.

.. _answers_file:

Custom Configuration with an Answers File
`````````````````````````````````````````
Instead of using the ``--allinone`` flag, we generated an answers file -- :download:`f5-answers.txt <../_static/f5-answers.txt>` -- and edited it to enable the services we want and disable some options we don't want.

.. note::

    The configurations in our answers file are basically equivalent to running the following command:

    .. code-block:: shell

        $ packstack --os-heat-install=y --os-debug-mode=y --os-neutron-lbaas-install=y --provision-demo=n


To generate an answers file (replace ``[answers-file]`` with the file name of your choice):

.. code-block:: shell

    $ packstack --gen-answer-file=[answers-file].txt

For our custom all-in-one installation, we changed the following entries in the answers file. You can also customize your admin user account credentials here, if desired.

.. code-block:: text

    # vi [answers-file].txt
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

    When you generate an answers file, Packstack automatically includes the IP address of the machine on which the file is generated in the ``CONTROLLER_HOST``, ``COMPUTE_HOSTS``, & ``NETWORK_HOSTS`` entries. If you're using additional compute and/or network nodes, you'll need to edit the answers file to add in the IP addresses for those machines. As shown in the example below, multiple values should be comma-separated, without a space in between.

    .. code-block:: text

        # vi [answers-file].txt
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


.. _run-packstack:

Run Packstack
`````````````
To deploy OpenStack using your custom answers file:

.. code-block:: shell

    $ packstack --answer-file=[answers-file].txt


The installation can take a while. If all goes well, you should eventually see the following message:

.. code-block:: text

    **** Installation completed successfully ******

    Additional information:
     * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
     * File /root/keystonerc_admin has been created on OpenStack client host 10.190.4.193. To use the command line tools you need to source the file.
     * Copy of keystonerc_admin file has been created for non-root user in /home/manager.
     * To access the OpenStack Dashboard browse to http://10.190.4.193/dashboard.
    Please, find your login credentials stored in the keystonerc_admin in your home directory.
     * The installation log file is available at: /var/tmp/packstack/20160121-155701-AyFMdp/openstack-setup.log
     * The generated manifests are available at: /var/tmp/packstack/20160121-155701-AyFMdp/manifests


Deploy Additional Hosts
```````````````````````
You can add more hosts after deploying an all-in-one environment. To do so:

1. In the :ref:`answers file<answers_file>`:

- Update the network card names for ``CONFIG_NOVA_COMPUTE_PRIVIF`` and ``CONFIG_NOVA_NETWORK_PRIVIF``.
- Update the IP addresses for the ``COMPUTE_HOSTS`` and ``NETWORK_HOSTS``.
- Add the IP address of the host on which you've already run Packstack to the ``EXCLUDE_SERVERS`` entry.

Example:

.. code-block:: text

    # Comma-separated list of servers to be excluded from the
    # installation. This is helpful if you are running Packstack a second
    # time with the same answer file and do not want Packstack to
    # overwrite these server's configurations. Leave empty if you do not
    # need to exclude any servers.
    EXCLUDE_SERVERS=10.190.4.193
    ...
    # Private interface for flat DHCP on the Compute servers.
    CONFIG_NOVA_COMPUTE_PRIVIF=enp2s0
    ...
    # Private interface for flat DHCP on the Compute network server.
    CONFIG_NOVA_NETWORK_PRIVIF=enp2s0
    ...
    # List of IP addresses of the servers on which to install the Compute
    # service.
    CONFIG_COMPUTE_HOSTS=10.190.4.195

    # List of IP addresses of the server on which to install the network
    # service such as Compute networking (nova network) or OpenStack
    # Networking (neutron).
    CONFIG_NETWORK_HOSTS=10.190.4.195

2. :ref:`Run packstack <run-packstack>` again.

.. tip::

    Run ``ip addr show`` on the host(s) you want to add to find the interface names and IP addresses.

    .. code-block:: shell

        $ ip addr show
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
               valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host
               valid_lft forever preferred_lft forever
        2: ens2f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether 78:e3:b5:0b:61:a4 brd ff:ff:ff:ff:ff:ff
        3: ens2f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether 78:e3:b5:0b:61:a6 brd ff:ff:ff:ff:ff:ff
        4: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master ovs-system state UP qlen 1000
            link/ether b4:99:ba:a9:55:f0 brd ff:ff:ff:ff:ff:ff
            inet6 fe80::b699:baff:fea9:55f0/64 scope link
               valid_lft forever preferred_lft forever
        5: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
            link/ether b4:99:ba:a9:55:f1 brd ff:ff:ff:ff:ff:ff


Configure OpenStack
-------------------
Congratulations! You now have an OpenStack deployment. Next, you'll need to configure your network, add projects and users, and launch instances. Please see our :ref:`OpenStack configuration guide <os-config-guide>` for instructions.

You can log in to the Horizon dashboard at the URL provided in the 'successful installation' message, using the username and password found in :file:`keystonerc_admin`. **If you change your password in Horizon, be sure to update this file.**

.. tip::

    To use the ``openstack``, ``nova``, ``neutron``, and ``glance`` CLI commands, you'll need to source :file:`keystonerc_admin`.

    .. code-block:: shell

        $ source keystonerc_admin



.. note::

    You may receive an authentication error when trying to log in to OpenStack Horizon after a session timeout. If this happens, clear your browser's cache and delete all cookies, then try logging in again.


