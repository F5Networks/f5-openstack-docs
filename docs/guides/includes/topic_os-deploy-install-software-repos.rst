.. _os-deploy-install-software-repos:

Install Software Repositories
`````````````````````````````

.. note::

    You can run these commands as root or manager. If you're logged in as an admin user, you may need to use ``sudo``.

1. Update your current software packages:

    .. code-block:: shell

        $ sudo yum install update -y


2. Install the software package for the OpenStack |openstack| release.

    .. code-block:: shell

        $ sudo install -y https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm


3. Install the software package for Packstack.

    .. code-block:: shell

        $ sudo install -y openstack-packstack
