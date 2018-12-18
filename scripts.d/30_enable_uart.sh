#!/bin/bash
exit 0

set -e

ROOT=mnt/img_root
CONFIG=$ROOT/boot/config.txt

# Set up firmware configuration

if ! grep -q "^enable_uart=" $CONFIG; then
    {
        echo
        echo "# Enable UART on Pi 3"
        echo "enable_uart=1"
     } >> $CONFIG
fi
