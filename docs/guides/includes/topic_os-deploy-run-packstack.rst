.. _os-deploy-run-packstack:

Run Packstack
`````````````
Use the command shown below to deploy OpenStack using a custom answers file.

.. code-block:: shell

    $ packstack --answer-file=[answers-file].txt


The installation can take a while. If all goes well, you should eventually see the following message:

.. code-block:: text
    :emphasize-lines: 5-8

    **** Installation completed successfully ******

    Additional information:
     * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
     * File /root/keystonerc_admin has been created on OpenStack client host 10.190.4.193. To use the command line tools you need to source the file.
     * Copy of keystonerc_admin file has been created for non-root user in /home/manager.
     * To access the OpenStack Dashboard browse to http://10.190.4.193/dashboard.
    Please, find your login credentials stored in the keystonerc_admin in your home directory.
     * The installation log file is available at: /var/tmp/packstack/20160121-155701-AyFMdp/openstack-setup.log
     * The generated manifests are available at: /var/tmp/packstack/20160121-155701-AyFMdp/manifests

