# ODK Command Reference

## Manage OpenStack: 

```
odk-openstack
  deploy    #deploy OpenStack on bare metal
  destroy   #destroy OpenStack instance
  check     #quick diagnostic checks for OpenStack
  diagnose  #gather detailed configurations, logs, and diagnostics
```

```
odk-openstack deploy
 --num-machines [ 2 to N ]
 --distro [ precise | trusty ]
 --openstack-release [ havana | icehouse ]
 --neutron-plugin [ ml2 | ovs ]
 --network-type [ vlan | gre | vxlan ]
 --lbaas-driver [ f5 | haproxy | f5,haproxy ]
 --bigip-image [ e.g BIGIP-11.5.0.0.0.221-OpenStack.qcow2 ]
 --ha-type [ pair | scalen |standalone ]
 --num-bigips [ 2, 4, 8 ] # for scaleN
 --all
 --test
```

---
## Manage OpenStack Objects: 

```
odk-admin-image
odk-admin-tenant
odk-user-tenant
odk-network
odk-provider-network
odk-nova-instance
odk-floating-ip
odk-monitor
odk-pool
odk-pool-member
odk-pool-monitor
odk-web-server
odk-vip
```

### odk-admin-image

```
#usage: image.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose] [--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--image IMAGE]
#positional arguments:
    openstack-api-endpoint     #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --image <path>              #Path to image to import.
__________________________________________________________________________
```

### odk-admin-tenant 

```
#usage: base.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose] [--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
    ext-net-cidr                #CIDR for external network (e.g. 192.168.100.0/24).
    ext-net-gateway-ip          #Gateway IP for external network (e.g. 192.168.100.1).
    ext-net-allocation-pool-start#Floating IP pool start.
    ext-net-allocation-pool-end #Floating IP pool end.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --image <path>              #Path to image to import.
__________________________________________________________________________
```

### odk-user-tenant 

```
#usage: base.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose] [--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up]
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --image <path>              #Path to image to import.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
__________________________________________________________________________
```

### odk-network 

```
#usage: network.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose] [--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up]
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX]
    [--network-index NETWORK_INDEX] [--network-name NETWORK_NAME] 
    [--shared]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --network-index <index>     #Network index.
    --network-name <name>       #Network name.
    --shared                    #Shared network.
__________________________________________________________________________
```

### odk-provider-network 

```
#usage: provider_network.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--network-name NETWORK_NAME] [--network-type NETWORK_TYPE] 
    [--physical-network PHYSICAL_NETWORK] [--segmentation-id SEGMENTATION_ID] 
    [--subnet-cidr SUBNET_CIDR] [--ip-pool-start IP_POOL_START] [--ip-pool-end IP_POOL_END]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --network-name <name>       #Network name.
    --network-type <type>       #Network type (vlan, gre, vxlan).
    --physical-network <name>   #Physical network as declared in config file.
    --segmentation-id <id>      #Segmentation id (vlan id, gre key, or vxlan id).
    --subnet-cidr <cidr>        #Subnet cidr i.e. 10.0.0.0/24
    --ip-pool-start <ip_pool>   #allocation pool start
    --ip-pool-end <ip_pool>     #allocation pool end
__________________________________________________________________________
```

### odk-nova-instance

```
#usage: instance.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX]
    [--network-index NETWORK_INDEX] [--network-index-list NETWORK_INDEX_LIST]
    [--network-name NETWORK_NAME] [--instance-index INSTANCE_INDEX] 
    [--image-name IMAGE_NAME] [--flavor FLAVOR]
    [--availability-zone-index AVAILABILITY_ZONE_INDEX] [--no-wait-on-state]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --network-index <index>     #Index of instance management network.
    --network-index-list <index_list> [<index_list>]#List of networks for the instance.
    --network-name <name>       #Network name.
    --instance-index <name>     #Index of instance.
    --image-name <name>         #Image to use when creating instance.
    --flavor <flavor>           #Flavor to use when creating instance.
    --availability-zone-index <name>#Availability zone (host aggregate) index.
    --no-wait-on-state          #Do not wait until created instance is active or deleted instance is removed.
__________________________________________________________________________    
```

###odk-floating-ip

```
#usage: floating_ip.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX]
    [--instance-index INSTANCE_INDEX] [--instance-network-index INSTANCE_NETWORK_INDEX]
    [--instance-subnet-name INSTANCE_SUBNET_NAME] 
    [--floating-ip-retry FLOATING_IP_RETRY] [--no-test-connectivity]

#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --instance-index <name>     #Index of instance.
    --instance-network-index <name>#Instance network index for floating ip access.
    --instance-subnet-name <name>#Instance subnet name (port reference).
    --floating-ip-retry <number>#Number of retry attempts for floating ip test
    --no-test-connectivity      #Do not test newly associated floating ip.
__________________________________________________________________________
```

###odk-monitor 

```
#usage: monitor.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
__________________________________________________________________________

```

### odk-pool 

```
#usage: pool.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX] [--pool-index POOL_INDEX]
    [--pool-network-index POOL_NETWORK_INDEX] [--pool-subnet-name POOL_SUBNET_NAME]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --pool-index <index>        #Load balancer pool index.
    --pool-network-index <index>#Load balancer pool network index.
    --pool-subnet-name <name>   #Pool subnet name.
__________________________________________________________________________

```

### odk-pool-member 

```
#usage: pool_member.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX][--pool-index POOL_INDEX]
    [--instance-index INSTANCE_INDEX] [--instance-network-index INSTANCE_NETWORK_INDEX]
    [--instance-subnet-name INSTANCE_SUBNET_NAME]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --pool-index <index>        #Load balancer pool index.
    --instance-index <index>    #Instance index for web server host/pool member.
    --instance-network-index <index>#Instance network index for web server host/pool member.
    --instance-subnet-name <name>#Instance subnet name (port reference) for host/pool member.
__________________________________________________________________________

```

### odk-pool-monitor 

```
usage: pool_monitor.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--verbose][--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX][--pool-index POOL_INDEX]
    [--instance-index INSTANCE_INDEX] [--instance-network-index INSTANCE_NETWORK_INDEX]
    [--instance-subnet-name INSTANCE_SUBNET_NAME]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <password> #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --pool-index <index>        #Load balancer pool index.
__________________________________________________________________________

```

### odk-web-server 

```
usage: web_server.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME] 
    [--admin-username ADMIN_USERNAME] [--admin-password ADMIN_PASSWORD] 
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD] [--tenant-index TENANT_INDEX] 
    [--verbose] [--sleep SLEEP] [--check] [--clean-up-only] [--no-clean-up]
    [--instance-index INSTANCE_INDEX] 
    [--web-server-network-index WEB_SERVER_NETWORK_INDEX]
    [--web-server-subnet-name WEB_SERVER_SUBNET_NAME]
    [--web-server-instance-nic-id WEB_SERVER_INSTANCE_NIC_ID]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <word>     #Admin password (default:openstack).
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --instance-index <index>    #Instance index for web server host/pool member.
    --web-server-network-index <index>#Instance network index web server will listen on.
    --web-server-subnet-name <name>#Instance subnet name (port reference) web server listens on.
    --web-server-instance-nic-id <id>#Instance nic index web server will use (e.g. eth0)
__________________________________________________________________________

```

### odk-vip 

```
#usage: vip.py [-h] [--admin-tenant-name ADMIN_TENANT_NAME]
    [--admin-username ADMIN_USERNAME]
    [--admin-password ADMIN_PASSWORD] [--verbose] [--sleep SLEEP]
    [--check] [--clean-up-only] [--no-clean-up]
    [--tenant-name TENANT_NAME] [--tenant-username TENANT_USERNAME]
    [--tenant-password TENANT_PASSWORD]
    [--tenant-index TENANT_INDEX] [--pool-index POOL_INDEX]
    [--vip-index VIP_INDEX] [--vip-network-index VIP_NETWORK_INDEX]
#positional arguments:
    openstack-api-endpoint      #Endpoint for OpenStack API calls.
#optional arguments:
    -h, --help                  #show this help message and exit
    --admin-tenant-name <name>  #Admin tenant name (default:admin).
    --admin-username <name>     #Admin username (default:admin).
    --admin-password <word>     #Admin password (default:openstack).
    --verbose                   #Print verbose messages.
    --sleep <number>            #Seconds to sleep after CRUD operations.
    --check                     #Check CRUD operations.
    --clean-up-only             #Only clean up objects related to this test.
    --no-clean-up               #Do not clean up objects related to this test.
    --tenant-name <name>        #Tenant name (default:None).
    --tenant-username <name>    #Tenant username (default:None).
    --tenant-password <password>#Tenant password (default:None).
    --tenant-index <index>      #Tenant index (default:1).
    --pool-index <index>        #Load balancer pool index.
    --vip-index <index>         #Load balancer vip index.
    --vip-network-index <index> #Load balancer vip network index.
```