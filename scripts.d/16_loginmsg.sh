#!/bin/bash

motd=mnt/img_root/etc/motd
green="\033[1;32m"
brown="\033[0;33m"
{
  echo -e "${brown}#################################################################################"
  echo -e "#${green}     _                     _                                       _           ${brown}#"
  echo -e "#${green}    | |_  _ __  ___   ___ | |__    ___   _   _  ___   ___  ___    (_)  ___     ${brown}#"
  echo -e "#${green}    | __|| '__|/ _ \\ / _ \\| '_ \\  / _ \\ | | | |/ __| / _ \\/ __|   | | / _ \\    ${brown}#"
  echo -e "#${green}    | |_ | |  |  __/|  __/| | | || (_) || |_| |\\__ \\|  __/\\__ \\ _ | || (_) |   ${brown}#"
  echo -e "#${green}     \\__||_|   \\___| \\___||_| |_| \\___/  \\__,_||___/ \\___||___/(_)|_| \\___/    ${brown}#"
  echo -e "#${brown}                                                                               #"
  echo -e "#${brown}                    Welcome to the treehouses project!                         ${brown}#"
  echo -e "#${brown}         For more information, please visit: http://treehouses.io/             ${brown}#"
  echo -e "#${brown}            To begin using treehouses type 'treehouses help'                   ${brown}#"
  echo -e "#${brown}   Please feel free to contact us in the 'https://gitter.im/treehouses/Lobby'  ${brown}#"
  echo -e "${brown}#################################################################################"
 
} > $motd

chmod +x $motd
