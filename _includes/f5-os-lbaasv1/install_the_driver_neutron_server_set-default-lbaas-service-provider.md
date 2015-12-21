Identify F5 as the LBaaS service provider in the Neutron server's configuration file: '/etc/neutron/neutron.conf'.  

    [service_providers]
    service_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin_driver.F5PluginDriver:default
