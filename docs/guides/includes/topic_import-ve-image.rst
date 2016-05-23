Import OpenStack-Ready VE Image
```````````````````````````````

To import an OpenStack-ready BIG-IP® VE image file using the command line:

.. code-block:: shell

    $ glance image-create --name <name> --container-format <format> --disk-format <format> --file <your.image.filename>

.. topic:: Example:

    .. code-block:: shell

        $ glance image-create --name bigip11.6.0 --container-format bare --disk-format qcow2 --file BIGIP-11.6.0.6.146.442.LTM.Small.qcow2


.. caution::

    The standard BIG-IP® VE image -- the image you download from f5.com -- must be patched to be OpenStack-ready. You can use the OpenStack Heat orchestration service to import a standard VE image and make it OpenStack-ready. See the :ref:`F5® Heat User Guide <heat:heat-user-guide>` for instructions.
