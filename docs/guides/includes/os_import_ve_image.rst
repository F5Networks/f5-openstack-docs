.. _import-ve-image_reuse:

To import a VE image file using the command line:

.. code-block:: text

    $ glance image-create --name <name> --container-format <format> --disk-format <format> --file <your.image.filename>

Example:

.. code-block:: text

    $ glance image-create --name bigip11.6.0 --container-format bare --disk-format qcow2 --file BIGIP-11.6.0.6.146.442.LTM.Small.qcow2


.. caution::

    Do not import a qcow2 zip file; the format isn’t compatible with OpenStack.
