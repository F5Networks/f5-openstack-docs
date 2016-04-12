You must have the following before proceeding:

- A functional OpenStack environment with at least one controller node, one compute node, and one network node. (Can be an :ref:`all-in-one <os_all-in-one_deployment>` deployment.)

- An OpenStack-compatible BIG-IP® VE qcow2 image\*.

- Basic understanding of OpenStack networking concepts. See the `OpenStack docs <http://docs.openstack.org/>`_ for your release for more information.

.. important::

    You can be logged in as root or as an admin user to execute the commands presented in this guide. You'll need to source your admin credentials file (e.g., ``source keystonerc_admin``) to use the ``openstack``, ``nova``, and ``neutron`` commands.


\* `F5 Networks/f5-openstack-image-prep <https://github.com/F5Networks/f5-openstack-image-prep>`_ contains scripts that can prepare an F5® VE image file to boot in OpenStack.

