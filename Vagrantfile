# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  grep -q -e 'eth0 -j MASQUERADE' /etc/network/interfaces
  if [ $? -ne 0 ]; then 
    ifdown eth1
    ifdown eth2
    cat /etc/network/interfaces |perl -p -e 's:iface eth1 inet static:iface eth1 inet static\npost-up /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE && /sbin/iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT && /sbin/iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT\npre-down for i in `iptables -t nat -L -n -x -v --line-numbers |grep MASQUERADE |grep eth0 |grep -o -e \"^[0-9]*\"`; do iptables -t nat -D POSTROUTING 1; done; for i in `iptables -L -n -x -v --line-numbers |grep eth0 |grep eth1 |grep -o -e \"^[0-9]*\"`; do iptables -D FORWARD 1; done:g;s:auto eth1:allow-hotplug eth1:g;s:auto eth2:allow-hotplug eth2:g' > /etc/network/interfaces.new && mv /etc/network/interfaces.new /etc/network/interfaces
    ifup eth1
    ifup eth2
  else 
    exit 0
  fi
SCRIPT

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "seclab"
  # config.vm.box_url = "https://dev.dima.tu-berlin.de/webdav/seclab.box"
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :public_network, :bridge => 'en0: Ethernet', ip: "192.168.55.1"
  config.vm.network :private_network, ip: "192.168.56.2"

  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    #vb.gui = false

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.provision "shell", inline: $script
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
  end
end
