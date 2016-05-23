.. _os-config-guide-next-steps:

Next Steps
----------

We highly recommend using OpenStack dashboard to add images to Glance, launch instances, and/or use Heat stacks to deploy and configure resources. See the `OpenStack dashboard user guide <http://docs.openstack.org/user-guide/dashboard.html>`_ for instructions.

.. tip::

    Here are a few helpful tips:

    - If your private network doesn't show up in the network list when `launching an instance <http://docs.openstack.org/user-guide/dashboard_launch_instances.html>`_, the network may be misconfigured.

    - If you want to be able to use SSH to authenticate to tenants in your cloud, you'll need to create or add SSH key pairs. We recommend generating your own key pair and :ref:`adding it to OpenStack <heat:add-ssh-key-horizon>`.

    - :ref:`Adding images to Glance <heat:add-ubuntu-image-glance>` in advance makes it easy to :ref:`deploy resources using Heat <heat:heat-user-guide>`.



