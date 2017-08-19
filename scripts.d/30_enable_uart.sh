#!/bin/bash

set -e

ROOT=mnt/img_root
CONFIG=$ROOT/boot/config.txt

# Set up firmware configuration

if ! grep -q "^enable_uart=" $CONFIG; then
    echo >> $CONFIG
    echo "# Enable UART on Pi 3" >> $CONFIG
    echo "enable_uart=1" >> $CONFIG
fi
