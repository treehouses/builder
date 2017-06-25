# treehouse-builder

Treehouse-builder is based on [Raspian](https://www.raspbian.org/) and allows the user to develop and tailor their own custom RPi images. The script will modify the latest Raspian image by installing packages, purging packages and executing custom commands, and then finally creates a bootable .img file that can be burned to the SD card.

## Instructions

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
System requirements
Required packages
kpartx wget gpg parted qemu-arm-static

To install the required packages, run the following command in Debian/Ubuntu: sudo apt-get install kpartx wget gpg parted qemu-arm-static. 
```
### Getting Started 

```
git clone https://github.com/ole-vi/treehouse-builder.git
cd treehouse-builder
./treehouse-builder --chroot 
 ``` 

### Add gpg key

```bash
sudo bash -c 'wget -O - https://packagecloud.io/gpg.key | apt-key add -'
```

### Customize

```
INSTALL_PACKAGES - Install packages found in the APT repositories. To add a custom package not found in the default APT repositories: add the package name into INSTALL_PACKAGES and then add the custom repository to ADD_REPOS.

PURGE_PACKAGES - Remove packages already installed on the default Raspbian image.

CUSTOM_COMMANDS - Add extra commands to execute upon the completion of the treehouse-builder, which is run under a chroot environment. For instance to enable ssh on boot for the RPi, the command sudo touch /boot/ssh is included in CUSTOM_COMMANDS. The semi-colon is there to separate the commands and will execute regardless whether or not the previous command is successful.


```

### Retrieve builds

Copy successful builds from `temp`.

To remove otherwise:`bash clean.sh`

## Built With

```
WIP
```

