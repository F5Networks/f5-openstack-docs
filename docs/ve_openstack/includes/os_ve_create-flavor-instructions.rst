.. _ve_create_flavor_instructions:

How to Create a Flavor in OpenStack
===================================

To define a custom flavor via the command line:

    .. code-block:: text

        flavor_id=$(cat /proc/sys/kernel/random/uuid) nova flavor-create f5small $flavor_id 4096 20 2

You can also create new custom flavors via the Horizon dashboard. To do so, go to :menuselection:`System --> Flavors` and click :guilabel:`Create Flavor`.

