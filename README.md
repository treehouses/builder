# builder using pi-gen

_Tool used to create treehouses Raspbian images using Vagrant, Virtual Box,  and Docker._
_*Currently only creates a raspian image without treehouses scripts. PLEASE NOTE: WORK IN PROGRESS.*_

## Requirements

- Vagrant 
  This runs all the commands on Virtual Box for you in order to create the images.
- Virtual Box 
  This allows us to build the images without affecting our personal systems.
- Virtual Box Guest Additions (Shared folders)
  This should be installed automatically but still a requirement because we need this
  in order to transfer the completed image files from Virtual Box to our folders.
  This can be re-configured to use RSync, SMB, or NFS instead of Virtual Box for
  synced folders, if preferred. 
 
- Vagrant plugin (vagrant-reload)(https://github.com/aidanns/vagrant-reload)
  Used to restart the machine after editing etc/modules.
  
## Instructions

1.  Download or clone this repository
2.  Configure the settings in config and Vagrantfile
3.  Launch terminal/bash/command prompt to this folder
4.  Run `vagrant up` to execute the Vagrantfile script in the directory
5.  Wait for Done! message in around 2-3 minutes
6.  Grab treehouse-116.img out of the images folder