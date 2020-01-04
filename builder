#!/bin/bash
# Download Raspbian Image, remove first-boot stuff, add repos and install packages.
#
# Open interactive Shell in chroot or write result to SD Card
#
# License: GNU General Public License, see http://www.gnu.org/copyleft/gpl.html for full text
#
# The following variables and arrays customize the behavior. To change them simply create a configuration
# file `pirateship-image-creator.config` which overrides them.
#
# Add at least the following lines to override the internal configuration:
# INSTALL_PACKAGES=()
# ADD_REPOS=()
# ADD_REPO_KEYS=()
echo "Fetching Image"
mkdir -p images
apt-get install git
# Runs pi-gen to create a 1.2gb Raspbian image
git clone https://github.com/RPi-Distro/pi-gen 
mv ./pi-gen/* ./
touch ./stage2/SKIP_IMAGES
cp ./stage4/EXPORT_IMAGE ./stage3/EXPORT_IMAGE	
ls
echo - e 'binfmt_misc\n\nloop\n' >> /etc/modules
cp ./builder /etc/init.d/builder
chmod +x /etc/init.d/builder
sudo update-rc.d /etc/init.d/builder defaults
sudo reboot