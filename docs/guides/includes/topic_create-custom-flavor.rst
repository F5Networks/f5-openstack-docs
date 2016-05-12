.. _create-custom-flavors:

Create Custom Flavors
---------------------

.. tip::

    For information regarding BIG-IP® VE image sizes and minimum requirements, see the :ref:`BIG-IP® VE Flavor Requirements <big-ip_flavors>`.

To define a custom flavor via the command line:

.. code-block:: shell

    flavor_id=$(cat /proc/sys/kernel/random/uuid) nova flavor-create f5small $flavor_id 4096 20 2

You can also create new custom flavors via the OpenStack dashboard. To do so, go to :menuselection:`System --> Flavors` and click :guilabel:`Create Flavor`.

