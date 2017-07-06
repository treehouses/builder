# treehouse-builder

Treehouse-builder is based on [Raspian](https://www.raspbian.org/) and allows the user to develop and tailor their own custom RPi images. The script will modify the latest Raspian image by installing packages, purging packages and executing custom commands, and then finally creates a bootable .img file that can be burned to the microSD card.

## Instructions

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
System requirements
class10 microSD card (minimum 8 Gb)

Required packages
kpartx wget gpg parted qemu-arm-static

To install the required packages, run the following command in Debian/Ubuntu: 
sudo apt-get install kpartx wget gpg parted qemu-arm-static. 
```
### Getting Started 

```
git clone https://github.com/ole-vi/treehouse-builder.git
cd treehouse-builder
./treehouse-builder --chroot 
 ``` 
You should be in a chrooted environment when it is completed. You can access the RPi images' files and folders or carry on with any extra modifications. To exit the chrooted environment just type `exit` and then you should be back in your own shell again. The image in this stage is now ready to write to the microSD card.

### Add gpg key

```bash
sudo bash -c 'wget -O - https://packagecloud.io/gpg.key | apt-key add -'
```

### Customize

```
INSTALL_PACKAGES - Install packages found in the APT repositories. 
To add a custom package not found in the default APT repositories: 
add the package name into INSTALL_PACKAGES and then add the custom repository to ADD_REPOS.

PURGE_PACKAGES - Remove packages already installed on the default Raspbian image.

CUSTOM_COMMANDS - Add extra commands to execute upon the completion of the treehouse-builder, 
which is run under a chroot environment. For instance to enable ssh on boot for the RPi, 
the command sudo touch /boot/ssh is included in CUSTOM_COMMANDS. The semi-colon is there to 
separate the commands and will execute regardless whether or not the previous command is successful.

```

### Retrieve builds

After exiting from the chroot environment, successful builds are found in the `treehouse-builder/images` directory. There should be a few files in that directory. The .zip file is the unmodified base image, which is downloaded by the script when executed. The .img file is the new customized image and is now ready to be burned onto the microSD card.

##### To remove unwanted modifications otherwise:

`bash clean.sh`

### Write to microSD Card

There are many different ways to write to the microSD card. An easy approach is to download [Etcher](https://etcher.io) and run the program. It supports multiple Operating Systems such as Linux, OSX and Windows, and has a pretty simple GUI, where you select the location of the .img file, the destination of the microSD card and then press the flash button to write the image onto the microSD card. Remember that it will delete everything on that drive so make sure it is the correct drive!


## Built with

* [rpi-image-creator](https://github.com/ImmobilienScout24/rpi-image-creator)

