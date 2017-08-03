.. _heat-deploy-bigip-lb:

How to Deploy a BIG-IP VE instance and set up a basic load balancer
===================================================================

.. include:: /_static/reuse/applies-to-ALL.rst

This guide demonstrates how to use the `OpenStack Heat`_ orchestration service to onboard, deploy, and provision a F5 BIG-IP Virtual Edition (VE) instance. We provide instructions for deploying the Heat templates via the `OpenStack Horizon`_ dashboard.

This guide uses the following `F5-Supported Heat templates`_:

- `BIG-IP VE image patch and upload`_: Add an OpenStack-ready BIG-IP VE image to Glance.
- `BIG-IP VE Standalone, 3-nic`_: Deploy a standalone, 3-nic BIG-IP VE instance.
- `Deploy basic load balancer`_: Deploy a simple load balancer on the BIG-IP VE instance.

.. _deploy-lb_before-you-begin:

Before You Begin
----------------

In addition to the basic :ref:`F5 Heat prerequisites <heat-prereqs>`, you will need the following to follow this guide:

- An external network set up in Neutron that can access the internet.
- `F5 OpenStack Heat plugins`_ installed on the Neutron controller.
- SSH key(s) set up in OpenStack.
- (Optional) Add the :ref:`F5 flavors <add-nova-flavors>` to OpenStack.

Caveats
```````

- The Heat engine needs to access the BIG-IP VE image file via "http".
  The F5 Heat templates cannot retrieve files via "https" and do not support file uploads.

.. _add-bigip-image-glance:

Add the BIG-IP VE image to Glance
---------------------------------

Add a Ubuntu image
``````````````````

The BIG-IP image patch and upload template uses a Ubuntu server to run a patch script on the BIG-IP VE qcow image.
If you don't already have a Ubuntu image in Glance, you'll need to add one.

#. Copy the download URL for a `Ubuntu 14.04 server image`_. [#ubuntuserver]_

   .. todo:: check on version compatibility and limitations

#. Add the image to Glance:

   - In Horizon, go to :guilabel:`Compute` --> :guilabel:`Images`.
   - Click :guilabel:`Create Image` and paste the image URL in the :guilabel:`Image Location` field.
   - Enter the requested information, including the minimum requirements for your image (we used 7GB disk and 520MB RAM).
   - Click :guilabel:`Create` to add the image to Glance.

.. [#ubuntuserver] Ubuntu 14.04 is the only version verified by the OpenStack development team. Other versions may work, but deployments using unverified versions are not supported by F5.

Patch and upload the BIG-IP VE image
````````````````````````````````````

#. Download the `BIG-IP VE image patch and upload`_ heat template.

#. Define the stack parameters in a YAML file.

   .. tip::

      The sample environment file below shows the values you'll need to provide when deploying the ``BIG-IP VE image patch and upload`` heat stack.

      Before you deploy your stack, replace the example values with the correct information for your environment.

      .. literalinclude:: /_static/config_examples/patch-upload-ve-image.params.yaml

   :fonticon:`fa fa-download` :download:`Sample image patch and upload env file </_static/config_examples/patch-upload-ve-image.params.yaml>`

#. Deploy the Heat stack using the OpenStack CLI.

   .. code-block:: console

      openstack stack create -f patch_upload_ve_image.yaml -e patch-upload-ve-image.params.yaml


.. _deploy-bigip-ve-heat:

Deploy a BIG-IP VE instance
---------------------------

#. Download the `BIG-IP VE standalone, 3-nic`_ heat template.

#. Define the stack parameters in a YAML file.

   .. tip::

      The sample environment file below shows the values you'll need to provide when deploying the ``BIG-IP VE standalone, 3-nic`` heat stack.

      Before you deploy your stack, replace the example values with the correct information for your environment.

      .. literalinclude:: /_static/config_examples/f5_ve_standalone_3_nic.params.yaml

   :fonticon:`fa fa-download` :download:`Sample BIG-IP VE standalone 3-nic env file </_static/config_examples/f5_ve_standalone_3_nic.params.yaml>`

#. Deploy the Heat stack using the OpenStack CLI.

   .. code-block:: console

      openstack stack create -f f5_ve_standalone_3_nic.yaml -e f5_ve_standalone_3_nic.params.yaml


.. _assign-floating-ip:

Assign a Floating IP Address to the BIG-IP instance
```````````````````````````````````````````````````

Use the `OpenStack Horizon`_ dashboard to assign a floating IP address to the BIG-IP VE instance.

#. Go to :menuselection:`Project --> Compute --> Instances`, then choose :menuselection:`Associate Floating IP` from the drop-down menu in the :guilabel:`Actions` column.

#. Select a :guilabel:`Floating IP` from the :menuselection:`IP Address` drop-down menu.

#. In the :menuselection:`port` drop-down, select a port for your BIG-IP instance that corresponds to the external VLAN.

#. Click :guilabel:`Associate`.

   .. tip::

      If there aren't any floating IP addresses available in the drop-down menu:

      - Click :guilabel:`+` to generate a floating IP address.
      - Click :guilabel:`Allocate`.

      The availability of these actions may depend on your OpenStack user privileges.

.. _create-loadbalancer-heat:

Create a basic load balancer on the BIG-IP VE instance
------------------------------------------------------

#. Download the `Deploy basic load balancer`_ heat template.

#. Define the stack parameters in a YAML file.

   .. tip::

      The sample environment file below shows the values you'll need to provide when deploying the ``Basic Load Balancer`` heat stack.
      Before you deploy your stack, replace the example values with the correct information for your environment.

      .. literalinclude:: /_static/config_examples/deploy-lb.params.yaml

   :fonticon:`fa fa-download` :download:`Sample Deploy Basic Load Balancer env file </_static/config_examples/f5_ve_standalone_3_nic.params.yaml>`

#. Deploy the Heat stack using the OpenStack CLI.

   .. code-block:: console

   openstack stack create -f deploy_lb.yaml -e deploy_lb.params.yaml

Next Steps
----------

#. Configure your BIG-IP device.

   .. tip::

      * You can access the BIG-IP from the OpenStack dashboard via :menuselection:`System --> Instances --> Console`.
      * To log in to the BIG-IP configuration utility, copy its floating IP address from the :guilabel:`Instance` screen in the dashboard, then paste it into your browser's address bar.
        **You must use** ``https`` **to connect**.
      * You can connect to the BIG-IP instance via ssh using the floating IP address and the ssh key you provided in the environment file.

#. Set up the `F5 Neutron LBaaS`_ integration to communicate with your new BIG-IP instance.

.. _Ubuntu 14.04 server image: http://releases.ubuntu.com/trusty/
.. _F5 Neutron LBaaS: /cloud/openstack/latest/lbaas/
.. _BIG-IP VE image patch and upload: /products/templates/openstack-heat/latest/f5_supported/f5-bigip-ve_image-patch-upload.html
.. _BIG-IP VE Standalone, 3-nic: /products/templates/openstack-heat/latest/f5_supported/f5-bigip-ve_standalone-3nic.html
.. _Deploy basic load balancer: /products/templates/openstack-heat/latest/f5_supported/deploy-basic-lb.html
