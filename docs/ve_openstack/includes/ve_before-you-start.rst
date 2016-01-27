.. _ve-before-you-start:

Before You Start
================

You must have the following before proceeding:

1. A functional OpenStack environment.
2. An OpenStack-compatible BIG-IP VE qcow2 image (**NOTE:** this cannot be a qcow2 zip file).
3. Basic understanding of OpenStack networking concepts (see the `OpenStack docs <http://docs.openstack.org/>`_ for your release for more information).

**IMPORTANT:** You can be logged in as root or as an admin user to execute the commands presented in this guide. You'll need to source your
admin credentials file (e.g., ``source keystonerc_admin``) to use the ``openstack``, ``nova``, and ``neutron`` commands.