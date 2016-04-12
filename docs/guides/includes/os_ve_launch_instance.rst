.. _launch_big-ip_instance_reuse:

To launch an instance using the OpenStack Horizon dashboard (easiest method):

1. Go to ``http://<ip_address>/dashboard`` and log in with your admin credentials.
2. Select :guilabel:`admin` from the :guilabel:`Projects` drop-down menu to the right of the OpenStack logo.
3. Go to :menuselection:`Project --> Compute --> Instances`, then click :guilabel:`Launch Instance`.

   -  On the :guilabel:`Project & User` tab:
        - select :guilabel:`admin` for each.
   -  On the :guilabel:`Details` tab:
        - enter a descriptive instance name;
        - choose your custom flavor;
        - select :guilabel:`boot from image` as the boot source;
        - select your BIG-IP® image.
   -  On the :guilabel:`Access & Security` tab:
        - select the :guilabel:`BIG-IP_default` security group.
   -  On the :guilabel:`Network` tab:
        - select at least 2 networks (3 if you're using SR-IOV).
   -  Click :guilabel:`Launch`.

.. warning::

    Do not select the physical external network when launching an instance. Choose the VLANs you set up for use with your BIG-IP®.
