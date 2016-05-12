.. _os-deploy-next-steps:

Next Steps
----------

See the :ref:`F5® OpenStack configuration guide <os-config-guide>` for instructions on the following basic OpenStack configurations:

    * Neutron Network Configuration
    * Adding projects and users
    * Deploying resources

.. note::

    You can either use the command line or the OpenStack dashboard (the GUI) to configure OpenStack. The dashboard is accessible at the URL provided in the 'successful installation' message; the username and password are found in the file :file:`keystonerc_admin` (created as part of the Packstack deployment).

    If you change your password in the dashboard, be sure to update it in :file:`keystonerc_admin` as well.

.. include:: includes/topic_note-source-admin-credentials.rst
    :start-line: 3


.. warning::

    You may receive an authentication error when trying to log in to the dashboard after a session timeout. If this happens, clear your browser's cache and delete all cookies, then try logging in again.

