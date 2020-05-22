# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "treehouses/buster64"
  config.vm.box_version = "0.13.19"
# config.vm.box_check_update = false

  config.vm.hostname = "treehouses"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "treehouses"
    vb.memory = "2222"
  end

  # load GITHUB_KEY ... please fix .vagrant.yml
  vagrantyml = YAML.load_file('./.vagrant.yml')
  githubapikey = vagrantyml.fetch('GITHUB_KEY')

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true

  config.vm.provision "shell", inline: <<-SHELL
    echo "git checkout <branch> ?"
    mkdir -p /vagrant/images
    cd /vagrant
    dos2unix * */* */*/* */*/*/* */*/*/*/* */*/*/*/*/*
    export GITHUB_KEY='#{githubapikey}'
    python scripts.d/30_ssh_keys.py
    sudo -u vagrant screen -dmS build sudo bash -c 'export PATH="$PATH:/sbin:/usr/sbin:/usr/lib/go-1.14/bin";export GOPATH="$PATH:/home/vagrant/go";cd /vagrant;./builder --chroot; exec bash'
  SHELL
end
