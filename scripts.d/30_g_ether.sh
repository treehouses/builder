#!/bin/bash

set -e

# Make the pi into a USB ethernet gadget.

ROOT=mnt/img_root
CONFIG=$ROOT/boot/config.txt
CMDLINE=$ROOT/boot/cmdline.txt
USB0_IFACE=$ROOT/etc/network/interfaces.d/usb0

# Set up firmware configuration

if ! grep -q "^dtoverlay=" $CONFIG; then
    #sed -i -e '${' -e 'a\\' -e 'a# Enable USB gadget mode' \
    #    -e 'adtoverlay=dwc2' -e '}' /boot/config.txt
    {
        echo
        echo "# Enable USB gadget mode"
        echo "dtoverlay=dwc2" 
    } >> $CONFIG
fi

# Load necessary modules

if ! grep -q dwc2 $CMDLINE; then
    sed -i -e 's/$/ modules-load=dwc2,g_ether/' $CMDLINE
fi

# Configure the network interface

{
    echo
    echo "auto usb0"
    echo "allow-hotplug usb0"
    echo "iface usb0 inet ipv4ll"
} >> $USB0_IFACE

