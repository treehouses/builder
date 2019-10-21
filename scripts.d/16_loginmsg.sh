#!/bin/bash

motd=/etc/motd
chmod u+x /etc/motd

{
echo " "
echo "Welcome to the treehouses project!"
echo " "
echo "The Open Learning Exchange is a social benefit and for-purpose organization based in Cambridge, Massachusetts."
echo "Our mission is to provide universal quality education using open source materials and technology to overcome educational barriers in third world countries."
echo " "
echo "For more information, please visit: http://treehouses.io/"
echo " "
echo "To begin using treehouses type \`treehouses help\` "
echo " " } >> $motd

