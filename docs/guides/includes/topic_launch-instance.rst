Launch an Instance
``````````````````

To launch a BIG-IP® instance using the OpenStack dashboard:

1. Go to ``http://<ip_address>/dashboard`` and log in with your admin credentials.

2. Go to :menuselection:`Project --> Compute --> Instances`, then click :guilabel:`Launch Instance`.

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

        - select networks as appropriate (at least two).

   -  Click :guilabel:`Launch`.

.. warning::

    Do not select the physical external network when launching an instance. Choose the :ref:`VLANs <concept_vlans>` you set up for use with your BIG-IP®.


