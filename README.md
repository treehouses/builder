# treehouse-builder

Treehouse-builder is based on [Raspian](https://www.raspbian.org/)and allows the user to develop and tailor their own custom RPi images. The script will modify the latest Raspian image by installing packages, purging packages and executing custom commands, and then finally creates a bootable .img file that can be burned to the SD card.

## Instructions

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
System requirements
†Required packages
kpartx wget gpg parted qemu-arm-static
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
WIP
```

### Retrieve builds

Copy successful builds from `temp`.

To remove otherwise:`bash clean.sh`

## Built With

```
WIP
```

