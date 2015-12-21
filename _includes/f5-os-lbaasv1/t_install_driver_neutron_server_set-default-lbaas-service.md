On your OpenStack host(s), edit the Neutron LBaaS configuration file to identify the F5 LBaaS Plug-in as the default load balancing service: '*/etc/neutron/neutron_lbaas.conf*'.  

1. Use a text editor to open the neutron_lbaas.conf.
2. Add `neutron.services.loadbalancer.plugin.LoadBalancerPlugin.` to the \[DEFAULT\] section, as shown below.

    `[DEFAULT]  `
    `service_plugins=neutron.services.l3_router.l3_router_plugin.L3RouterPlugin,neutron.services.firewall.fwaas_plugin.FirewallPlugin.`**`neutron.services.loadbalancer.plugin.LoadBalancerPlugin.`**`neutron.services.vpn.plugin.VPNDriverPlugin,neutron.services.metering.metering_plugin.MeteringPlugin`
