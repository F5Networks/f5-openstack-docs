.. _import-ve-image:

Import a VE Image
=================

**CAUTION:** Do not upload a qcow2 zip file; the qcow zip format isn’t compatible with OpenStack.

    .. code-block:: text

        glance image-create --name bigip11.6.0 --container-format bare --disk-format qcow2 --file [your.image.filename]
