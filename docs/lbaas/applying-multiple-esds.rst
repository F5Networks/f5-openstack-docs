:product: F5 Agent for OpenStack Neutron
:type: tutorial

.. _apply-multiple-esd:

How to define L7 policies for Virtual Servers using Multiple ESDs
=================================================================

The |agent-long| can implement L7 policy on your BIG-IP device(s) using :ref:`Enhanced Service Definitions <esd>`, or ESDs.

.. important::

   While you can apply multiple ESDs to an LBaaS Listener, you should only apply one ESD to a Listener at a time. If you apply multiple ESDs with conflicting settings to the same Listener at the same time, you may experience unexpected behaviors.

When you deploy multiple ESDs to a single Listener, the |agent| essentially overlaps the settings from each ESD into a single JSON request

**For example:**

What you define:

.. code-block:: yaml
   :caption: ESD_DEMO_1

   {
      "lbaas_ctcp": "tcp-mobile-optimized",
      "lbaas_stcp": "tcp-lan-optimized",
   }

.. code-block:: yaml
   :caption: ESD_DEMO_2

   {
      "lbaas_persist": "sourceip"
   }

What the |agent| applies to the BIG-IP virtual server:

.. code-block:: yaml
   :caption: Combined ESD

   {
     "lbaas_ctcp": "tcp-mobile-optimized",
     "lbaas_stcp": "tcp-lan-optimized",
     "lbaas_persist": "sourceip"
   }

When you apply multiple ESDs containing the same tag with different settings to a single LBaaS Listener, L7-policy's "position" setting determines which setting receives priority.

How the F5 Agent uses position to determine priority
----------------------------------------------------

When you create a new l7-policy, you can use the ``position`` argument to assign it a priority. The lower the position, the higher the priority.

.. code-block:: console
   :caption: Example: Use ``l7-policy-create`` to create two ESDs

   $ lbaas-l7-policy-create –name “esd_demo_1” –action REJECT –listener vs1 –position 1
   $ lbaas-l7-policy-create –name “esd_demo_2” –action REJECT –listener vs1 –position 2

If the |agent| encounters conflicting settings, it will select the settings from the ESD with the lower position number.

What you define:

.. code-block:: yaml
   :caption: ESD_DEMO_1 -- position 1

   {
     "lbaas_ctcp": "tcp-mobile-optimized",
     "lbaas_stcp": "tcp-lan-optimized",
   }

.. code-block:: yaml
   :caption: ESD_DEMO_2 -- position 2

   {
     "lbaas_ctcp": "tcp-mobile-optimized",
     "lbaas_stcp": "tcp-lan-optimized",
     "lbaas_persist": "sourceip"
   }

What the |agent| sees:

.. code-block:: yaml
   :emphasize-lines: 2,3

   {
     "lbaas_ctcp": "tcp-mobile-optimized",   \\ CONFLICT
     "lbaas_ctcp": "tcp-lan-optimized",      \\ CONFLICT
     "lbaas_stcp": "tcp-lan-optimized",
     "lbaas_stcp": "tcp-lan-optimized",
     "lbaas_persist": "sourceip"
   }

What the |agent| applies to the BIG-IP virtual server:

.. code-block:: yaml

   {
     "lbaas_ctcp": "tcp-mobile-optimized",   \\ Taken from ESD_DEMO_1 (priority 1)
     "lbaas_stcp": "tcp-lan-optimized",      \\ Same in both ESDs
     "lbaas_persist": "sourceip"             \\ Taken from ESD_DEMO_2
   }

As noted in the example, the |agent| encountered conflicting settings for the ``lbaas_ctcp`` field. Because ESD\_DEMO\_1 has a lower position number, the |agent| will select its ``lbaas_ctcp`` setting and discard the setting from ESD\_DEMO\_2. It is possible to assign the same position to multiple ``l7-policies``. If, for example, the |agent| finds multiple ``l7-policies`` with "position 1" assigned, it treats the most recent policy as the highest priority.

What happens if I don't assign a position?
------------------------------------------

If you don't assign a position argument, the |agent| follows the protocols defined by the LBaaS community:

"If [you create] a new policy ... without specifying a position, or specifying a position that is greater than the number of policies already in the list, the new policy will just [get] appended to the list." [#source]_

To expand on the previous example:

You define two ESDs in separate JSON files, then create an ``l7-policy`` for each in the order shown below.

.. code-block:: console
   :caption: Create L7 policies without assigning positions

   $ lbaas-l7-policy-create –name “esd_demo_1” –action REJECT –listener vs1
   $ lbaas-l7-policy-create –name “esd_demo_2” –action REJECT –listener vs1

Because you created the policy for ESD\_DEMO\_1 first, it receives "position 1". If you define ESD\_DEMO\_2 first, it would receive "position 1" and the Agent would prioritize its settings over ESD\_DEMO\_1. In that case, the |agent| would apply the ``lbaas_ctcp`` setting from ESD\_DEMO\_2 to the virtual server.

.. [#source] `Neutron/LBaaS/l7 Wiki`_

How do I check what ESDs are active on my virtual server?
---------------------------------------------------------

Because ESDs, by definition, provide L4-7 policies beyond those available in OpenStack, you won't be able to check them using any OpenStack interface. Instead, you can use either the BIG-IP configuration utility or TMSH to view the virtual server settings.

You can, however, use the Neutron API or CLI client to check an L7 Policy's position. The example command shown below uses the ``-D`` flag to return detailed information.

.. code-block:: console

   $ neutron lbaas-l7policy-show -D esd_demo_1

What's next
-----------

- Check out the `Neutron/LBaaS/l7 Wiki`_ for more information about L7 switching in OpenStack.
- View the `Neutron client lbaas-l7policy commands`_.

.. _Neutron/LBaaS/l7 Wiki: https://wiki.openstack.org/wiki/Neutron/LBaaS/l7#Policy_Position
.. _Neutron client lbaas-l7policy commands: https://docs.openstack.org/python-neutronclient/pike/cli/neutron-reference.html#lbaas-l7policy-create
