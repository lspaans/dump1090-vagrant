# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "debian/jessie64"

  # The VM hostname
  config.vm.hostname = "dump1090.localdomain"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:80" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 8080, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "172.16.1.1"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Do not auto-mount (with the wrong ownership) '/vagrant'
  config.vm.synced_folder ".", "/vagrant", :mount_options => [ "dmode=775", "fmode=775" ]

  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--usb", "on"]
    vm.customize ["modifyvm", :id, "--usbehci", "on"]
  end

  # The VM provisioning script
  config.vm.provision "shell", path: "deploy.sh"
end
