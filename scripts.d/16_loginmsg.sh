#!/bin/bash

motd=/etc/motd
chmod u+x /etc/motd

echo "" >> $motd
echo "Welcome to the treehouses project!" >> $motd
echo " " >> $motd
echo "The Open Learning Exchange is a social benefit and for-purpose organization based in Cambridge, Massachusetts." >> $motd
echo "Our mission is to provide universal quality education using open source materials and technology to overcome educational barriers in third world countries." >> $motd
echo " " >> $motd
echo "For more information, please visit: http://treehouses.io/" >> $motd
echo "" >> $motd
echo "To begin using treehouses type \`treehouses help\` " >> $motd
echo " " >> $motd

