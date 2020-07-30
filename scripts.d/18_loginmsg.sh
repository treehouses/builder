#!/bin/bash
exit 0 
motd=mnt/img_root/etc/motd
green="\033[1;32m"
red="\033[0;31m"
reset="\033[0m"
{
  echo -e "${red}################################################################################"
  echo -e "#${green}    _                     _                                       _           ${red}#"
  echo -e "#${green}   | |_  _ __  ___   ___ | |__    ___   _   _  ___   ___  ___    (_)  ___     ${red}#"
  echo -e "#${green}   | __|| '__|/ _ \\ / _ \\| '_ \\  / _ \\ | | | |/ __| / _ \\/ __|   | | / _ \\    ${red}#"
  echo -e "#${green}   | |_ | |  |  __/|  __/| | | || (_) || |_| |\\__ \\|  __/\\__ \\ _ | || (_) |   ${red}#"
  echo -e "#${green}    \\__||_|   \\___| \\___||_| |_| \\___/  \\__,_||___/ \\___||___/(_)|_| \\___/    ${red}#"
  echo -e "#${red}                                                                              #"
  echo -e "#${red}                      Welcome to the treehouses project!                      ${red}#"
  echo -e "#${red}           For more information, please visit: ${reset}http://treehouses.io           ${red}#"
  echo -e "#${red}                To begin using treehouses type ${reset}treehouses help                ${red}#"
  echo -e "#${red}   Please feel free to contact us in the ${reset}https://gitter.im/treehouses/Lobby   ${red}#"
  echo -e "${red}################################################################################${reset}"
} > $motd

chmod +x $motd
