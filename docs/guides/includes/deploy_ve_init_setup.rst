.. _ve-initial-setup:

1. Create projects, roles, and users as needed. At minimum, create an admin project and role; then, create an admin user and assign to it the admin role and project.

    .. code-block:: text

        # openstack project create admin
        # openstack role create admin
        # openstack user create admin --project=admin --password=default --email=<email_address> --role=admin

2. Create a security group for the BIG-IP.

    .. code-block:: text

        # neutron security-group-create BIG-IP_default


3. Add incoming traffic policies to the security group.

   -  ICMP

    .. code-block:: text

        # neutron security-group-rule-create --protocol icmp --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | e589ab98-7358-41e0-988e-e54ef3b7e445 |
        | port_range_max    |                                      |
        | port_range_min    |                                      |
        | protocol          | icmp                                 |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

   -  SSH

    .. code-block:: text

        # neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | 6064fdaf-df1f-4924-b6aa-5af9c33d31f5 |
        | port_range_max    | 22                                   |
        | port_range_min    | 22                                   |
        | protocol          | tcp                                  |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

   - HTTP

    .. code-block:: text

        # neutron security-group-rule-create --protocol tcp --port-range-min 80 --port-range-max 80 --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | df34ddf2-8a63-4772-aee8-6a688f3bf0dc |
        | port_range_max    | 80                                   |
        | port_range_min    | 80                                   |
        | protocol          | tcp                                  |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

   - SSL

    .. code-block:: text

        # neutron security-group-rule-create --protocol tcp --port-range-min 443 --port-range-max 443 --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | 9cda1fcc-c403-4523-9c36-2ff0b4b0dbd8 |
        | port_range_max    | 443                                  |
        | port_range_min    | 443                                  |
        | protocol          | tcp                                  |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

   - VXLAN

    .. code-block:: text

        # neutron security-group-rule-create --protocol udp --port-range-min 4789 --port-range-max 4789 --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | 44236cb0-2f9e-4e5f-8035-f97275ceed15 |
        | port_range_max    | 4789                                 |
        | port_range_min    | 4789                                 |
        | protocol          | udp                                  |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

   - GRE

    .. code-block:: text

        # neutron security-group-rule-create --protocol 47 --direction ingress BIG-IP_default
        Created a new security_group_rule:
        +-------------------+--------------------------------------+
        | Field             | Value                                |
        +-------------------+--------------------------------------+
        | direction         | ingress                              |
        | ethertype         | IPv4                                 |
        | id                | e12dbdb2-e88b-4dd7-9f6c-3515f51db9af |
        | port_range_max    |                                      |
        | port_range_min    |                                      |
        | protocol          | 47                                   |
        | remote_group_id   |                                      |
        | remote_ip_prefix  |                                      |
        | security_group_id | ea8c4843-3704-444d-a5fe-17d5a60261fd |
        | tenant_id         | 1a35d6558b59423e83f4500f1ebc1cec     |
        +-------------------+--------------------------------------+

4. Check/Add Package Information

    BIG-IP needs to be able to detect that it’s running on a VM. Check :file:`/etc/nova/release` to make sure that the vendor, product, and package information is stored there.

    .. code-block:: text

        # cat /etc/nova/release
        [Nova]
        vendor = Fedora Project
        product = OpenStack Nova
        package = 1.el7


    If the package information isn't present, enter the appropriate information for your environment.

    Example:

    .. code-block:: text

        # echo -e "[Nova]\nvendor = Fedora Project\nproduct = OpenStack Nova\npackage = 1.el7" > /etc/nova/release


5. Restart the Nova-Compute Service

    .. code-block:: text

        # service nova-compute restart

