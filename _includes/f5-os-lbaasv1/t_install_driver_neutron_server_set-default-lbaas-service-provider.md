On your OpenStack control host, identify F5 as the LBaaS service provider in the Neutron configuration file: '/etc/neutron/neutron.conf'.  

1. Use a text editor to open `neutron.conf`.
2. Locate the section where the extension services are configured. \(You can find this by searching for '\[service\_providers\]\'.\)
3. Add an entry for the F5 LBaaS plug:

    `[service_providers]`
    `service_provider=LOADBALANCER:f5:neutron.services.loadbalancer.drivers.f5.plugin_driver.F5PluginDriver:default`

  **Tip:** The \":default\" identifier at the end of the string sets the F5 LBaaS Plugin as the default service provider for load balancing.
  