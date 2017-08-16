#!/bin/bash

# Disabled until we can make this conditional somehow
exit 0

set -e

# Make the pi into a USB ethernet gadget.

ROOT=mnt/img_root
CONFIG=$ROOT/boot/config.txt
CMDLINE=$ROOT/boot/cmdline.txt
IFACES=$ROOT/etc/network/interfaces

# Set up firmware configuration

if ! grep -q "^dtoverlay=" $CONFIG; then
    #sed -i -e '${' -e 'a\\' -e 'a# Enable USB gadget mode' \
    #    -e 'adtoverlay=dwc2' -e '}' /boot/config.txt
    echo >> $CONFIG
    echo "# Enable USB gadget mode" >> $CONFIG
    echo "dtoverlay=dwc2" >> $CONFIG
fi

# Load necessary modules

if ! grep -q dwc2 $CMDLINE; then
    sed -i -e 's/$/ modules-load=dwc2,g_ether/' $CMDLINE
fi

# Configure the network interface

if ! grep -q usb0 $IFACES; then
    echo >> $IFACES
    echo "auto usb0" >> $IFACES
    echo "allow-hotplug usb0" >> $IFACES
    echo "iface usb0 inet ipv4ll" >> $IFACES
fi

