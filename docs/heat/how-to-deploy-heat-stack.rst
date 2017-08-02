.. _heat-how-to-deploy:

How to Deploy OpenStack Heat Templates
======================================

.. include:: /_static/reuse/applies-to-ALL.rst

Use the instructions provided here to deploy any of the templates in F5's `heat orchestration template library </templates/openstach-heat/latest/index.html#heat-orchestration-template-index>`_.

OpenStack CLI
-------------

.. rubric:: Platform Requirements

- `python-openstackclient`_ configured with the ``python-heatclient`` plugin
- |heat-p|

The |heat| documentation extensively covers creation and management of Heat stacks.
This document describes F5's OpenStack development team's preferred means of stack creation:

- define a Heat template's required parameters in a YAML file, and
- deploy the template via the command line.

.. note::

   This example uses the F5-supported `Deploy basic load balancer`_ template.

#. Download the template you want to deploy from the `F5-Supported Heat Templates`_ library.
#. Save the definition for each of the template's required configuration parameters in an `environment file`_.

   .. literalinclude:: /_static/config_examples/deploy-lb.params.yaml
      :caption: **Example:** Environment file for the ``deploy-lb`` Heat template
      :linenos:

   Replace the following parameters with the appropriate values for your environment.

   - ``image``
   - ``flavor``
   - ``ssh-key``
   - ``security group``
   - ``network``

   .. tip::

      **Protect your BIG-IP login information.**

      Store your username and password as `environment variables`_ and reference them in your environment file.

#. Create the Heat stack.

   .. code-block:: console

      openstack stack create -f deploy-lb.yaml -e deploy-lb.params.yaml


OpenStack Horizon
-----------------

Follow the directions below to deploy a Heat stack using the `OpenStack Horizon`_ dashboard.

#. Go to :menuselection:`Orchestration --> Stacks`.

#. Click :guilabel:`Launch Stack`.

#. Choose the :guilabel:`Template File` from its location on your machine, then click :guilabel:`Next`.

#. Provide the information required for the Heat engine to build your stack.

#. Click :guilabel:`Launch`.

.. hint::

   In the :guilabel:`Stacks` table, the status changes to :guilabel:`Create complete` when the deployment finishes.


.. _python-openstackclient: https://docs.openstack.org/python-openstackclient/latest
.. _environment file: https://docs.openstack.org/heat/latest/template_guide/environment.html
.. _environment variables: https://docs.openstack.org/user-guide/common/cli-set-environment-variables-using-openstack-rc.html
.. _Deploy basic load balancer: /templates/openstack-heat/latest/f5_supported/deploy-basic-lb.html
