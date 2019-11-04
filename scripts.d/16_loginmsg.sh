#!/bin/bash

motd=mnt/img_root/etc/motd

{
  echo ""
  echo " _                     _                                       _"
  echo "| |_  _ __  ___   ___ | |__    ___   _   _  ___   ___  ___    (_)  ___"
  echo "| __|| '__|/ _ \\ / _ \\| '_ \\  / _ \\ | | | |/ __| / _ \\/ __|   | | / _ \\"
  echo "| |_ | |  |  __/|  __/| | | || (_) || |_| |\\__ \\|  __/\\__ \\ _ | || (_) |"
  echo " \\__||_|   \\___| \\___||_| |_| \\___/  \\__,_||___/ \\___||___/(_)|_| \\___/"
  echo "Welcome to the treehouses project!"
  echo ""
  echo "The Open Learning Exchange is a social benefit and for-purpose organization based in Cambridge, Massachusetts."
  echo "Our mission is to provide universal quality education using open source materials and technology to overcome educational barriers in third world countries."
  echo ""
  echo "For more information, please visit: http://treehouses.io/"
  echo ""
  echo "To begin using treehouses type \`treehouses help\` "
  echo "" 
} >> $motd

chmod +x $motd
