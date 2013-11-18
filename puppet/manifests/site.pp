node 'seclab' { 	
  class { 'dnsmasq':
    interface      => 'eth1   ',
    listen_address => '192.168.55.1',
    port           => '53',
    expand_hosts   => true,
    enable_tftp    => false,
    domain_needed  => true,
    bogus_priv     => true,
    no_negcache    => true,
    no_hosts       => true,
    resolv_file    => '/etc/resolv.conf',
    cache_size     => 1000
  }

  dnsmasq::dhcp { 'dhcp': 
    paramset   => 'seclab',
    dhcp_start => '192.168.55.2',
    dhcp_end   => '192.168.55.254',
    netmask    => '255.255.255.0',
    lease_time => '1h'
  }

  dnsmasq::dhcpoption { 'option:router':
    content => '192.168.55.1',
  }

  dnsmasq::dhcpoption { 'option:dns-server':
    content => '192.168.55.1',
  }

#  ignore macaddress of own network interface
#  dnsmasq::dhcpstatic { 'host':
#    mac => 'DE:AD:BE:EF:CA:FE',
#    ip  => 'ignore',
#  }
#
#  dnsmasq::dhcpstatic { 'panda':
#    mac => 'DE:AD:BE:EF:CA:FE',
#    ip  => '192.168.55.2',
#  }

}
