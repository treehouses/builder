# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  
  config.vm.box = "bento/debian-10"  
  config.vm.hostname = "treehouses"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "./images", "/deploy"  
  
  config.vm.define "treehouses" do |treehouses|
  end

  config.vm.provider "virtualbox" do |vb|
    vb.name = "treehouses"
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8082" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8082
  #config.vm.network "forwarded_port", guest: 5984, host: 5981, auto_correct: true
  #config.vm.network "forwarded_port", guest: 8080, host: 8081, auto_correct: true
  config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "2222"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end  
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "docker" do |d|
  end
  config.vm.provision "shell",
    inline: "echo - e 'binfmt_misc\n\nloop\n' >> /etc/modules"
  config.vm.provision :reload 
  config.vm.provision "shell", inline: <<-SHELL
	apt update
	apt install -y git dos2unix
	cd /		
	git clone https://github.com/RPi-Distro/pi-gen 
	cp /vagrant/config /pi-gen/config
	dos2unix /pi-gen/config
	touch /pi-gen/stage2/SKIP_IMAGES
	cp /pi-gen/stage4/EXPORT_IMAGE /pi-gen/stage3/EXPORT_IMAGE	
	sudo bash /pi-gen/build-docker.sh	
  SHELL
end