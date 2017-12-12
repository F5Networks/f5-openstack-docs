Applying multiple ESDs
======================


| 

While it is possible to apply multiple Enhanced Service Definition(ESD) configurations
to a virtual server, the recommendation is that the user define all ESD configuration
tags in one named ESD.  When the user applies multiple Enhanced Service Definitions
to the same LBaaS Listener, and those ESDs contain
the same tag with different values, the tenant will have to be aware of
the precedence of tag application to avoid unexpected behaviors.

| 

Since the user applies ESDs by attaching LBaaS L7 Policy to LBaaS Listeners,
ESDs follow the same ‘first match’ behavior detailed for community LBaaS
L7 Policies. Each LBaaS L7 Policy has a position attribute, either
defined explicitly by the tenant or else populated automatically by the
Neutron LBaaS community plugin. When multiple ESDs containing the same
tag have conflicting values, the ESD matching the LBaaS L7 Policy with
the lowest position attribute is the one applied to the
tenant’s BIG-IP virtual service.

|

In example, given the following two ESDs:


    .. code-block:: JSON

        "esd\_demo\_1": {
            "lbaas\_ctcp": "tcp-mobile-optimized",

            "lbaas\_stcp": "tcp-lan-optimized",
        }

    .. code-block:: JSON


        "esd\_demo\_2": {
            "lbaas\_ctcp": "tcp-lan-optimized",

            "lbaas\_stcp": "tcp-lan-optimized",
        }

| which get applied by the tenant to the same LBaaS Listener

    .. code-block:: console

	    $> lbaas-l7-policy-create –name “esd_demo_1” –action REJECT
					–listener vs1 –position 1
	    $> lbaas-l7-policy-create –name “esd_demo_2” –action REJECT
					–listener vs1 –position 2


the BIG-IP virtual server would have the
**/Common/tcp-mobile-optimized** profile applied for client TCP
connections. The ESD “esd\_demo\_1” has a lower position number than the
ESD “esd\_demo\_2”, hence its “lbaas\_ctcp” tag value takes precedence.
The OpenStack agent applies its tag to the BIG-IP virtual service.

| 

If no position argument is explicitly defined when the tenant creates L7
Policies, the community LBaaS plugin follow a strict ordered process to
populate each L7 Policy’s position attribute value.

| 

The LBaaS community defines the evaluation order and assignment of policy
position using the following rules:

-  Policy position numbering starts with 1.
-  If a user creates a new policy with a position that matches that of another
   policy, then the Neutron LBaaS plugin inserts it at the given position.
-  If a user creates a new policy without specifying a position, or specifies
   a position number that is greater than the number of policies already in the
   list, the Neutron LBaaS plugin appends the policy to the end of the list.
-  When a user inserts, deletes, or appends a policy, the Neutron LBaaS plugin reorders the
   position values without skipping numbers.  For example, if policy A, B, and C
   have position values of 1, 2, and 3, respectively, if you delete policy B from
   the list, policy A will have position 1 and policy C will have position 2.

A user can check the value of an L7 Policy’s position attribute by showing
the policy via the Neutron API or CLI client.

| 

If the user repeats the above example, but this time without the tenant
explicitly defining each L7 policy’s position attribute,

    .. code-block:: console

        $> lbaas-l7-policy-create –name “esd_demo_1” –action REJECT –listener vs1
        $> lbaas-l7-policy-create –name “esd_demo_2” –action REJECT –listener vs1


the result would be the same as before because the L7 Policy
“esd\_demo\_1” gets assigned position value 1 at creation. Since
the user created L7 Policy “esd\_demo\_2” after “esd\_demo\_1” and is
also lacking an explicitly defined position value, it was assign
position value 2 according to LBaaS community rules.

| 

There is no visibility into which composition of ESD tags get applied
using the Neutron API, CLI clients, or via the Horizon dashboard. To
check the applied ESD tags on a virtual service, the user must consult
the BIG-IP virtual service configuration. This is intentional in order to
maintain the separation of concerns between the tenant and provider.
The provider knows the composition of tested ESD configurations and the
tenant is only aware that the must apply a named L7 Policy to get
the desired ADC behavior.

| 

Again, we recommend that the provider define unique sets of ESDs for
each combination of BIG-IP desired configurations for tenant virtual
services. When the user applies a single L7 Policy, referencing the
single named ESD, there is no question as to what BIG-IP configuration
apply to the tenant’s virtual service. In addition, unique ESD
application will reduce the combinations of BIG-IP configurations a
provider should test and will simplify the tenant’s role even further.
