.. _lbaas-l7-content-switching:

L7 Routing
==========

.. sidebar:: Applies to:

   ====================    ===========================
   F5 LBaaS version(s)     OpenStack version(s)
   ====================    ===========================
   v9.2+                   Mitaka
   --------------------    ---------------------------
   v10.x.x                 Newton
   ====================    ===========================


L7 routing takes its name from layer 7 of the OSI Model, also called the application layer. [#l7]_
The |agent-long| passes L7 content switching policies and rules from OpenStack Neutron to a BIG-IP device.
The BIG-IP device then processes the application data of request traffic as it passes through a virtual server and applies corresponding Local Traffic Manager (LTM) policies and rules to make routing decisions.
You can use the OpenStack API to define the content conditions and the actions that they should trigger. 

.. important::

   See the OpenStack Neutron `LBaaS Layer 7 rules documentation <http://specs.openstack.org/openstack/neutron-specs/specs/mitaka/lbaas-l7-rules.html>`_ for a full explanation of the `L7 rules`_ and `L7 policies`_.

   It is essential to understand these concepts before proceeding with this document.

Neutron LBaaSv2 API L7 Policies and Rules
`````````````````````````````````````````

In Neutron, an L7 Policy is a collection of L7 rules associated with a Listener; it may also have an association to a back-end pool.
Policies describe actions that the load balancing software should take if all of the rules in the policy return "true" (or, in other words, they match).

OpenStack Policy/Rules versus BIG-IP Local Traffic Manager Policy/Rules
```````````````````````````````````````````````````````````````````````

The Neutron L7 terminology does not directly align with the common vocabulary of BIG-IP Local Traffic Manager (LTM).
Keep the following key differences in mind:

- BIG-IP LTM policies also have a set of rules; in LTM, it is the rules, not the policies, that specify what action to take.
- BIG-IP devices evaluate policies attached to a virtual server regardless of whether the associated rules are true.
- BIG-IP LTM rules, not policies, have an ordinal.

The table below shows how the terms from each software domain correspond.

.. table:: L7 policies/rules in OpenStack Neutron and BIG-IP LTM

   +-----------------------+-------------------------------+
   | Neutron LBaaS L7 term | BIG-IP LTM equivalent         |
   +=======================+===============================+
   | Policy                | Policy Rules (wrapper_policy) |
   +-----------------------+-------------------------------+
   | Policy Action         | Rule Action                   |
   +-----------------------+-------------------------------+
   | Policy Position       | Rule Ordinal                  |
   +-----------------------+-------------------------------+
   | Rule                  | Rule Conditions               |
   +-----------------------+-------------------------------+


The BIG-IP LTM policy has a name, description, set of rules, and a strategy defining how to evaluate the rules.
OpenStack L7 policies in are similar to a collection BIG-IP LTM policy rules evaluated using the ‘First match’ strategy.

BIG-IP LTM rules have conditions, actions, and an ordinal.
The |agent| creates the LTM rules based on the OpenStack L7 policy and rule attributes.

Neutron LBaaSv2 API L7 rules to BIG-IP LTM policy mapping
---------------------------------------------------------

The |agent| maps a combination of :code:`L7Policy` and :code:`L7Rule` elements to TMOS traffic policies (and, in the case of specific :code:`L7Rule compare_types`, iRules).

All L7 Rule types map directly to TMOS traffic policy match conditions:

+--------------+-------------------------------------+
| L7 Rule Type | TMOS Traffic Policy Match Condition |
+==============+=====================================+
| Hostname     | HTTP Host                           |
+--------------+-------------------------------------+
| Path         | HTTP URI + path                     |
+--------------+-------------------------------------+
| FileType     | HTTP URI + extension                |
+--------------+-------------------------------------+
| Header       | HTTP Header                         |
+--------------+-------------------------------------+
| Cookie       | HTTP Cookie                         |
+--------------+-------------------------------------+

The LBaaS L7 Rules requirement to "execute the first L7Policy that returns a match" directly maps to the TMOS "first-match" traffic policy execution strategy.

Four of the five :code:`L7Rule compare_type` values map directly to TMOS traffic policy rule conditions:.

+----------------------+-------------------------+------------------------------------------+
| L7 Rule Compare Type | L7 '--invert' Specified | TMOS Traffic Policy Rule Match Condition |
+======================+=========================+==========================================+
| STARTS_WITH          | No                      | Begins with                              |
+----------------------+-------------------------+------------------------------------------+
| STARTS_WITH          | Yes                     | Does not begin with                      |
+----------------------+-------------------------+------------------------------------------+
| ENDS_WITH            | No                      | Ends with                                |
+----------------------+-------------------------+------------------------------------------+
| ENDS_WITH            | Yes                     | Does not end with                        |
+----------------------+-------------------------+------------------------------------------+
| EQUAL_TO             | No                      | Is                                       |
+----------------------+-------------------------+------------------------------------------+
| EQUAL_TO             | Yes                     | Is not                                   |
+----------------------+-------------------------+------------------------------------------+
| CONTAINS             | No                      | Contains                                 |
+----------------------+-------------------------+------------------------------------------+
| CONTAINS             | Yes                     | Does not contain                         |
+----------------------+-------------------------+------------------------------------------+
| REGEX                | X                       | No direct mapping                        |
+----------------------+-------------------------+------------------------------------------+

All :code:`L7Policy` actions map directly to TMOS traffic policy rule actions:

+------------------+---------------------------------+
| L7 Policy Action | TMOS Traffic Policy Rule Action |
+==================+=================================+
| Reject           | Reset traffic                   |
+------------------+---------------------------------+
| RedirectToUrl    | Redirect                        |
+------------------+---------------------------------+
| RedirectToPool   | Forward traffic to pool         |
+------------------+---------------------------------+

Caveats
-------

- The REGEX comparison type is not supported in this release.

Usage
-----

L7 Routing doesn't require any |agent| configuration changes.
Rather, you define L7 switching policies and rules when creating or updating a Neutron LBaaS listener.

The `CLI example`_ below from the OpenStack Neutron Wiki demonstrates how to define rules and policies using the OpenStack CLI. [#copyright]_

.. code-block:: console
   :emphasize-lines: 2,4,6,11,13

   # Create a listener
   neutron lbaas-create-listener listener1
   # Create a pool
   neutron lbaas-create-pool pool1
   # Create a policy
   neutron --policy policy1 lbaas-create-l7policy --name "policy1" --listener "listener1" --action redirect_to_pool --pool "pool1" --position 1
   # Create a rule for this policy
   # Once the below operation has completed, a new policy will exist on the device called 'wrapper_policy'.
   # It will have a single rule called redirect_to_pool_1.
   # A single condition and a single action will exist.
   neutron lbaas-create-l7rule rule1 --rule-type path --compare-type contains --value "i_t" --policy policy1
   # Create a second rule for the above policy
   neutron lbaas-create-l7rule rule2 --rule-type cookie --compare-type ends_with --key "cky" --value "i" --invert --policy policy1

The |agent| implements the above Neutron LBaaS policies and rules on the BIG-IP device as follows.

.. code-block:: console

   ltm policy wrapper_policy {
      controls { forwarding }
      last-modified 2016-12-05:09:19:05
      partition Project_9065d69e806a4b4894a47fed7484a006
      requires { http }
      rules {
          reject_1 {
              actions {
                  0 {
                      forward
                      reset
                  }
              }
              conditions {
                  0 {
                      http-uri
                      path
                      contains
                      values { i_t }
                  }
                  1 {
                      http-cookie
                      name cky
                      ends-with
                      values { i }
                  }
              }
              ordinal 1
          }
      }
      status legacy
      strategy /Common/first-match
   }

Learn more
----------

* OpenStack Neutron `LBaaS Layer 7 rules documentation <http://specs.openstack.org/openstack/neutron-specs/specs/mitaka/lbaas-l7-rules.html>`_
* OpenStack Neutron `LBaaSv2 l7 Wiki <https://wiki.openstack.org/wiki/Neutron/LBaaS/l7>`_
* `BIG-IP Local Traffic Management -- Getting Started with Policies <https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/local-traffic-policies-getting-started-12-1-0.html?sr=59376207>`_

.. rubric:: Footnotes
.. [#l7] https://wiki.openstack.org/wiki/Neutron/LBaaS/l7 
.. [#copyright] :fonticon:`fa fa-copyright` OpenStack Foundation

.. _L7 rules: https://wiki.openstack.org/wiki/Neutron/LBaaS/l7#L7_Rules
.. _L7 policies: https://wiki.openstack.org/wiki/Neutron/LBaaS/l7#L7_Policies
.. _CLI example: https://wiki.openstack.org/wiki/Neutron/LBaaS/l7#CLI_Example
