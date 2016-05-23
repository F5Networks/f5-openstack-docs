.. _create-flat-provider-network:

Create a Flat Provider Network
``````````````````````````````

Use the command below to create a flat provider network.

.. note::

    The below command may require the use of ``sudo``.


.. code-block:: shell

    $ neutron net-create datanet --provider:network_type flat --provider:physical_network extnet

