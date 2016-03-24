Exploring OpenStack and BIG-IP® via the CLI
==========================================

Overview
--------

You can log in to the OpenStack dashboard with the following URL - replacing with your IP address - and the login you configured during the
setup process.

 **http://<ip_address>/dashboard**

**NOTE:** We’ve had better luck accessing the OpenStack and BIG-IP® GUIs with Chrome or Firefox than with Internet Explorer.

Explore OpenStack CLI Commands
------------------------------

The first thing you'll want to do when using the OpenStack CLI is sourcing the credentials for an account with admin privileges.

    .. code-block:: shell

        [manager@pack43 ~]$ source keystonerc_admin


Project and Service-Related Commands
````````````````````````````````````

List all tenants/projects (these terms are interchangeable in OpenStack lingo):

    .. code-block:: shell

        $ openstack project list
        +----------------------------------+----------+
        | ID                               | Name     |
        +----------------------------------+----------+
        | 1a35d6558b59423e83f4500f1ebc1cec | admin    |
        | 297815eb7ccb4f74a9972a2328ea04de | internal |
        | 3eb3499b9ef14cb7b58f82150f73ca42 | demo2    |
        | 7e9eca13aef84ff3acaa714f5b33533d | services |
        | fb76f73484554d3593964f24ec57bd05 | demo1    |
        +----------------------------------+----------+


List all configured user accounts:

    .. code-block:: shell

        $ openstack user list
        +----------------------------------+------------+
        | ID                               | Name       |
        +----------------------------------+------------+
        | 16011d270ca74922a709546027f7cc84 | swift      |
        | 35310766229846da8dd99cb2ee86393f | glance     |
        | 41edace75fe14f3993b4011bbe88b870 | heat       |
        | 8d9ee43f420f47bf8d57d678e02d3de3 | neutron    |
        | 978754f96970423bb284413743189a1b | cinder     |
        | 9ab6485d5fd64d81a7c1ca2c67cb6bb4 | nova       |
        | c845db0c788443b4962b0717738ab0ce | demo       |
        | e1793dcf2c6b49a8a5c2e0f4ed625d4c | ceilometer |
        | f1129e0637ac4276809de3ba97bc5de2 | admin      |
        +----------------------------------+------------+


List all configured user roles:

    .. code-block:: shell

        $ openstack role list
        +----------------------------------+------------------+
        | ID                               | Name             |
        +----------------------------------+------------------+
        | 197a3a5efd844761a44a9ad735610486 | user             |
        | 3c24b84ba2df4c5397eeb03ca8324813 | heat_stack_owner |
        | 9fe2ff9ee4384b1894a90878d3e92bab | _member_         |
        | ae2261474e984f228c99349a9ad99737 | ResellerAdmin    |
        | bb7c957d380140438821ac0ede07b8ef | admin            |
        | d95f839f26f74cf4bd663a18be4f033b | heat_stack_user  |
        | eeb2cddd1c144bb2b4f79ec4531c20cf | SwiftOperator    |
        +----------------------------------+------------------+


List all configured user-role assignments:

    .. code-block:: shell

        $ openstack user role list
        +----------------------------------+------------------+---------+-------+
        | ID                               | Name             | Project | User  |
        +----------------------------------+------------------+---------+-------+
        | 9fe2ff9ee4384b1894a90878d3e92bab | _member_         | admin   | admin |
        | bb7c957d380140438821ac0ede07b8ef | admin            | admin   | admin |
        | 3c24b84ba2df4c5397eeb03ca8324813 | heat_stack_owner | admin   | admin |
        +----------------------------------+------------------+---------+-------+


List all OpenStack services:

    .. code-block:: shell

        $ openstack service list
        +----------------------------------+------------+---------------+
        | ID                               | Name       | Type          |
        +----------------------------------+------------+---------------+
        | 04daa8f96c844b858c7e52c80768ce1e | novav3     | computev3     |
        | 4890ea3d2a314146985006a356f0748b | heat       | orchestration |
        | 4a51afa62910420a981b8d100d3cace5 | nova       | compute       |
        | 4ba2aa3b8c9c4ddc82ec1274325cb027 | swift_s3   | s3            |
        | 5bec7d40b85e409ebd1dd2b41793e81a | keystone   | identity      |
        | 7d03f56621b8405aab26b7ff5270b930 | ceilometer | metering      |
        | 8c505412976449f682f4e492410a8d00 | nova_ec2   | ec2           |
        | a4c8bdd941db40af8a3078de31f11a4b | glance     | image         |
        | a6a1d95d18854299bf3e1de0fe91535c | neutron    | network       |
        | aec9c18d3d994b7085c1f9f8a041dbc0 | cinder     | volume        |
        | be5673337fa94b4ba7d987078c8cefe5 | cinderv2   | volumev2      |
        | c3c6dbaa6d594c1c99c9bff647ffa327 | swift      | object-store  |
        +----------------------------------+------------+---------------+


List services in the OpenStack service catalog:

    .. code-block:: shell

        $ openstack catalog list
        +------------+---------------+----------------------------------------------------------------------------------+
        | Name       | Type          | Endpoints                                                                        |
        +------------+---------------+----------------------------------------------------------------------------------+
        | nova       | compute       | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:8774/v2/1a35d6558b59423e83f4500f1ebc1cec        |
        |            |               |   internalURL: http://10.190.4.193:8774/v2/1a35d6558b59423e83f4500f1ebc1cec      |
        |            |               |   adminURL: http://10.190.4.193:8774/v2/1a35d6558b59423e83f4500f1ebc1cec         |
        |            |               |                                                                                  |
        | neutron    | network       | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:9696                                            |
        |            |               |   internalURL: http://10.190.4.193:9696                                          |
        |            |               |   adminURL: http://10.190.4.193:9696                                             |
        |            |               |                                                                                  |
        |...         | ...           | ...                                                                              |
        |            |               |                                                                                  |
        | novav3     | computev3     | RegionOne                                                                        |
        |            |               |   publicURL: http://127.0.0.1:8774/v3                                            |
        |            |               |   internalURL: http://127.0.0.1:8774/v3                                          |
        |            |               |   adminURL: http://127.0.0.1:8774/v3                                             |
        |            |               |                                                                                  |
        |...         | ...           | ...                                                                              |
        |            |               |                                                                                  |
        | glance     | image         | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:9292                                            |
        |            |               |   internalURL: http://10.190.4.193:9292                                          |
        |            |               |   adminURL: http://10.190.4.193:9292                                             |
        |            |               |                                                                                  |
        | ceilometer | metering      | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:8777                                            |
        |            |               |   internalURL: http://10.190.4.193:8777                                          |
        |            |               |   adminURL: http://10.190.4.193:8777                                             |
        |            |               |                                                                                  |
        |...         | ...           | ...                                                                              |
        |            |               |                                                                                  |
        | nova_ec2   | ec2           | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:8773/services/Cloud                             |
        |            |               |   internalURL: http://10.190.4.193:8773/services/Cloud                           |
        |            |               |   adminURL: http://10.190.4.193:8773/services/Cloud                              |
        |            |               |                                                                                  |
        | heat       | orchestration | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:8004/v1/1a35d6558b59423e83f4500f1ebc1cec        |
        |            |               |   internalURL: http://10.190.4.193:8004/v1/1a35d6558b59423e83f4500f1ebc1cec      |
        |            |               |   adminURL: http://10.190.4.193:8004/v1/1a35d6558b59423e83f4500f1ebc1cec         |
        |            |               |                                                                                  |
        |...         | ...           | ...                                                                              |
        |            |               |                                                                                  |
        | keystone   | identity      | RegionOne                                                                        |
        |            |               |   publicURL: http://10.190.4.193:5000/v2.0                                       |
        |            |               |   internalURL: http://10.190.4.193:5000/v2.0                                     |
        |            |               |   adminURL: http://10.190.4.193:5000/v2.0                                        |
        |            |               |                                                                                  |
        +------------+---------------+----------------------------------------------------------------------------------+


List all running Nova services:

    .. code-block:: shell

        $ nova service-list
        +----+------------------+---------+----------+---------+-------+----------------------------+-----------------+
        | Id | Binary           | Host    | Zone     | Status  | State | Updated_at                 | Disabled Reason |
        +----+------------------+---------+----------+---------+-------+----------------------------+-----------------+
        | 1  | nova-consoleauth | host-29 | internal | enabled | up    | 2016-02-22T20:46:58.000000 | -               |
        | 2  | nova-scheduler   | host-29 | internal | enabled | up    | 2016-02-22T20:46:58.000000 | -               |
        | 3  | nova-conductor   | host-29 | internal | enabled | up    | 2016-02-22T20:47:04.000000 | -               |
        | 4  | nova-compute     | host-29 | nova     | enabled | up    | 2016-02-22T20:47:00.000000 | -               |
        | 5  | nova-cert        | host-29 | internal | enabled | up    | 2016-02-22T20:47:00.000000 | -               |
        +----+------------------+---------+----------+---------+-------+----------------------------+-----------------+


List configured Neutron agents, **including the f5-oslbaas agent**:

    .. code-block:: shell

        $ neutron agent-list
        +--------------------------------------+--------------------+----------------------------------------------+-------+----------------+---------------------------+
        | id                                   | agent_type         | host                                         | alive | admin_state_up | binary                    |
        +--------------------------------------+--------------------+----------------------------------------------+-------+----------------+---------------------------+
        | 11b4c7ca-aaf9-4ac8-8b9f-2003e021cf23 | Metadata agent     | host-29                                      | :-)   | True           | neutron-metadata-agent    |
        | 13c25ea9-ca58-4b69-af27-fb1ea8824f65 | L3 agent           | host-29                                      | :-)   | True           | neutron-l3-agent          |
        | 4c71878e-ac49-4a60-81d3-af3793705460 | Open vSwitch agent | host-29                                      | :-)   | True           | neutron-openvswitch-agent |
        | 4e9df1b2-4fb7-4d01-8758-ca139038b0c8 | Loadbalancer agent | host-29                                      | xxx   | True           | neutron-lbaas-agent       |
        | 640c19de-4362-4c4e-88b1-650092e62169 | DHCP agent         | host-29                                      | :-)   | True           | neutron-dhcp-agent        |
        | e4921123-000c-4172-8a79-72e8f0d357e2 | Loadbalancer agent | host-29:3eb793cb-fa51-549d-a15b-253ce5405fcf | :-)   | True           | f5-oslbaasv1-agent        |
        +--------------------------------------+--------------------+----------------------------------------------+-------+----------------+---------------------------+


View details for a given agent:

    .. code-block:: shell

        $ neutron agent-show <agent_id>
        +---------------------+--------------------------------------------------------------------------+
        | Field               | Value                                                                    |
        +---------------------+--------------------------------------------------------------------------+
        | admin_state_up      | True                                                                     |
        | agent_type          | Loadbalancer agent                                                       |
        | alive               | True                                                                     |
        | binary              | f5-oslbaasv1-agent                                                       |
        | configurations      | {                                                                        |
        |                     |      "icontrol_endpoints": {                                             |
        |                     |           "10.190.6.253": {                                              |
        |                     |                "device_name": "host-10-20-0-4.int.lineratesystems.com",  |
        |                     |                "platform": "Virtual Edition",                            |
        |                     |                "version": "BIG-IP_v11.6.0",                              |
        |                     |                "serial_number": "65d1af65-d236-407a-779a9e02c4d9"        |
        |                     |           }                                                              |
        |                     |      },                                                                  |
        |                     |      "request_queue_depth": 0,                                           |
        |                     |      "environment_prefix": "",                                           |
        |                     |      "tunneling_ips": [],                                                |
        |                     |      "common_networks": {},                                              |
        |                     |      "services": 0,                                                      |
        |                     |      "environment_capacity_score": 0,                                    |
        |                     |      "tunnel_types": [                                                   |
        |                     |           "gre",                                                         |
        |                     |           "vlan",                                                        |
        |                     |           "vxlan"                                                        |
        |                     |      ],                                                                  |
        |                     |      "environment_group_number": 1,                                      |
        |                     |      "bridge_mappings": {                                                |
        |                     |           "default": "1.1"                                               |
        |                     |      },                                                                  |
        |                     |      "global_routed_mode": false                                         |
        |                     | }                                                                        |
        | created_at          | 2016-02-12 23:13:40                                                      |
        | description         |                                                                          |
        | heartbeat_timestamp | 2016-02-22 20:50:19                                                      |
        | host                | host-29:3eb793cb-fa51-549d-a15b-253ce5405fcf                             |
        | id                  | e4921123-000c-4172-8a79-72e8f0d357e2                                     |
        | started_at          | 2016-02-16 21:28:18                                                      |
        | topic               | f5-lbaas-process-on-agent                                                |
        +---------------------+--------------------------------------------------------------------------+


Network and Floating IP Commands
````````````````````````````````
    .. code-block:: shell

        $ neutron net-list
        $ neutron net-show <id>
        $ neutron subnet-list
        $ neutron subnet-show <id>
        $ neutron port-list
        $ neutron port-show <id>
        $ neutron floatingip-list


Flavor, Image, and VM Commands
``````````````````````````````

    .. code-block:: shell

        $ nova list
        $ nova show bigip1
        $ nova hypervisor-list
        $ nova hypervisor-servers <hypervisor-hostname>
        $ nova hypervisor-stats
        $ nova image-list
        $ nova flavor-list
        $ nova flavor-show m1.bigip


Security Rule Commands
``````````````````````

    .. code-block:: shell

        $ neutron security-group-list
        $ neutron security-group-rule-list


Firewall Configuration Commands
```````````````````````````````

**NOTE:** If you haven’t created a firewall, the results of these commands will be empty.

    .. code-block:: shell

        $ neutron firewall-list
        $ neutron firewall-policy-list
        $ neutron firewall-rule-list


LBaaSv1 Configuration Commands
``````````````````````````````

    .. code-block:: shell

        $ neutron help | grep lb-
        $ neutron lb-vip-list
        $ neutron lb-pool-list
        $ neutron lb-member-list
        $ neutron lb-healthmonitor-list


Explore BIG-IP® CLI Commands
---------------------------

Use `nova list` to find the address of your BIG-IP® (in the following example, it's 10.190.4.193). The BIG-IP® will begin with the default
credentials [#f1]_. To access the BIG-IP® GUI from a remote machine, run the following IPTables commands on the CentOS host command line:

    .. code-block:: shell

        $ myif=`ip route show | grep default | head -n 1 | cut -d' ' -f5`
        $ myip=`ip addr show dev $myif | grep "inet "| cut -d' ' -f6 | cut -d'/' -f1`
        $ sudo iptables -t nat -A PREROUTING -i $myif -p tcp --dport 2443 -d $myip -m conntrack --ctstate NEW -j DNAT --to-destination 10.190.4.193:443

If you deployed a second BIG-IP® using the option `--ha-type pair` (which is not the default), then you should also do this for the second BIG-IP®:

    .. code-block:: shell

        $ sudo iptables -t nat -A PREROUTING -i \$myif -p tcp --dport 3443 -d $myip -m conntrack --ctstate NEW -j DNAT --to-destination 10.190.4.193:443

**To use any of the commands shown below, log in to the BIG-IP® CLI as a user with admin privileges.**

Partition and LTM Object Configuration Commands
```````````````````````````````````````````````

    .. code-block:: shell

        # tmsh
        root@(host-10-20-0-4)(cfg-sync Standalone)(Active)(/Common)(tmos)# list net tunnels
        net tunnels gre uuid_gre_ovs {
            app-service none
            defaults-from gre
            encapsulation transparent-ethernet-bridging
            flooding-type multipoint
        }
        net tunnels tunnel http-tunnel {
            description "Tunnel for http-explicit profile"
            profile tcp-forward
        }
        net tunnels tunnel socks-tunnel {
            description "Tunnel for socks profile"
            profile tcp-forward
        }
        net tunnels vxlan uuid_vxlan_ovs {
            app-service none
            defaults-from vxlan
            flooding-type multipoint
            port 4789
        }


    .. code-block:: shell

        # root@(host-10-20-0-4)(cfg-sync Standalone)(Active)(/Common)(tmos)# list ltm <tab>
        Options:
          all-properties           current-module           non-default-properties   one-line                 recursive                |
        Modules:
          auth                     dns                      html-rule                monitor                  profile
          data-group               global-settings          message-routing          persistence
        Components:
          default-node-monitor     nat                      policy-strategy          snat                     traffic-class
          eviction-policy          node                     pool                     snat-translation         virtual
          ifile                    policy                   rule                     snatpool                 virtual-address


    .. code-block:: shell

        root@(host-10-20-0-4)(cfg-sync Standalone)(Active)(/Common)(tmos)# show ltm <tab>
        Options:
          current-module     recursive          |
        Modules:
          auth               clientssl-proxy    dns                message-routing    monitor            persistence        profile
        Components:
          eviction-policy    nat                policy             pool               snat               snatpool           virtual-address
          ifile              node               policy-strategy    rule               snat-translation   virtual


Tunnel Commands
```````````````

    .. code-block:: shell

        # root@(host-10-20-0-4)(cfg-sync Standalone)(Active)(/Common)(tmos)# list net <tab>
        Options:
          all-properties           current-module           non-default-properties   one-line                 recursive                |
        Modules:
          cos                      fdb                      ipsec                    rate-shaping             tunnels
        Components:
          arp                      lldp-globals             port-mirror              self                     trunk
          bwc-policy               ndp                      route                    self-allow               vlan
          dns-resolver             packet-filter            route-domain             stp                      vlan-group
          interface                packet-filter-trusted    router-advertisement     stp-globals              wccp


    .. code-block:: shell

        $ list net tunnels
        net tunnels gre uuid_gre_ovs {
            app-service none
            defaults-from gre
            encapsulation transparent-ethernet-bridging
            flooding-type multipoint
        }
        net tunnels tunnel http-tunnel {
            description "Tunnel for http-explicit profile"
            profile tcp-forward
        }
        net tunnels tunnel socks-tunnel {
            description "Tunnel for socks profile"
            profile tcp-forward
        }
        net tunnels vxlan uuid_vxlan_ovs {
            app-service none
            defaults-from vxlan
            flooding-type multipoint
            port 4789
        }


    .. code-block:: shell

        root@(host-10-20-0-4)(cfg-sync Standalone)(Active)(/Common)(tmos)# show net
        Options:
          current-module   recursive        |
        Modules:
          cos              fdb              ipsec            rate-shaping     tunnels
        Components:
          arp              dns-resolver     interface        lldp-neighbors   route            self             vlan
          bwc-policy       ike-evt-stat     interface-cos    ndp              route-domain     stp              vlan-allowed
          cmetrics         ike-msg-stat     ipsec-stat       packet-filter    rst-cause        trunk            vlan-group


    .. code-block:: shell

        # show net self

        -----------------------
        Net::Self IP: 10.30.0.6
        -----------------------

          ---------------------------------------
          | Net::Vlan: openstack-network-1.1
          ---------------------------------------
          | Interface Name      openstack-net~1
          | Mac Address (True)  fa:16:3e:b3:66:f6
          | MTU                 1400
          | Tag                 4094
          | Customer-Tag

             -----------------------
             | Net::Vlan-Member: 1.1
             -----------------------
             | Tagged    yes
             | Tag-Mode  none

                -------------------------------------------------------------
                | Net::Interface
                | Name  Status    Bits   Bits  Pkts  Pkts  Drops  Errs  Media
                |                   In    Out    In   Out
                -------------------------------------------------------------
                | 1.1       up  129.3K  17.4K   382    34      0     0   none


Further Reading
---------------

The command examples shown here are a very small subset of the available ``openstack``, ``neutron``, ``nova``, and ``tmos`` commands. More information can be found in the `OpenStack <http://docs.openstack.org/>`_ and `F5 BIG-IP® LTM <https://support.f5.com/kb/en-us/products/big-ip_ltm.html>`_ documentation.


.. rubric:: Footnotes

<<<<<<< HEAD
.. [#f1] BIG-IP VE images created using the F5 OpenStack onboarding script will not use the default credentials. Instead, the randomly-generated passwords for the root (r) and admin (a) users are shown at first boot, as in the below example:

    .. code-block:: shell

        BIG-IP 11.6.0 Build 0.0.401
        Kernel 2.6.23-358.23.2.e16.f5.x86_64 on an x86_64
        r: ZBYLYQIGZJ   a: MKYBLGHLTB
