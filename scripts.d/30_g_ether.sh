#!/bin/bash
exit 0 
# Make the pi into a USB ethernet gadget.
ROOT=mnt/img_root
CONFIG=$ROOT/boot/config.txt
CMDLINE=$ROOT/boot/cmdline.txt
USB0IFACE=$ROOT/etc/network/interfaces.d/usb0

# Set up firmware configuration
{
    echo
    echo "# Enable USB gadget mode"
    echo "#dtoverlay=dwc2"
} >> $CONFIG

sed -i -e 's/$/ #modules-load=dwc2,g_ether/' $CMDLINE

# Configure the network interface
{
    echo
    echo "auto usb0"
    echo "allow-hotplug usb0"
    echo "iface usb0 inet ipv4ll"
} >> $USB0IFACE

