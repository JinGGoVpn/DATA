#!/bin/bash
clear
red='\e[1;31m'
gr='\e[0;32m'
blue='\e[0;34m'
bb='\e[0;94m'
cy='\033[0;36m'
NC='\e[0m'

install_resolv() {
clear
apt install resolvconf -y
systemctl enable resolvconf.service
systemctl start resolvconf.service
systemctl restart resolvconf.service
clear
    clear
    mwarp
}

change_dns() {
clear
dns=($(cat /etc/resolvconf/resolv.conf.d/head | awk '{print $2}'))
echo -e "DEFAULT DNS ADALAH 8.8.8.8"
echo -e "DNS SERVER KINI= $dns"
echo -e ""
echo -e "${green}MASUKKAN DNS BARU ATAU TEKAN CTL C UTK EXIT${NC}"
echo -e ""
read -p "NEW DNS SERVER: " dns2
if [ -z $dns2 ]; then
echo "Please Input Port"
mdns
fi
# Masukkan DNS kedalam RESOLVE
echo -e ""
echo "nameserver $dns2" > /etc/resolv.conf
echo "nameserver $dns2" > /etc/resolvconf/resolv.conf.d/head

systemctl stop resolvconf.service
systemctl enable resolvconf.service
systemctl start resolvconf.service
clear
sleep 2
echo -e "============================================="
echo -e " ${green} PERTUKARAN DNS SERVER SELESAI${NC}"
echo -e "============================================="
echo ""
    echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
    read answer
    if [ "$answer" == "${answer#[Yy]}" ]; then
        reboot
    else
        mdns
    fi
}

echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " \033[30;5;47m                      ⇱ DNS MENU ⇲                           \033[m"       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} " 
echo -e  " ${bb}[ 01 ] INSTALL RESOLVCONF "
echo -e  " ${bb}[ 02 ] CHANGE DNS"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}" 
echo -e  " ${bb}[  0 ]${NC}" "${cy}EXIT TO MENU${NC}  "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  "  "
echo -e "\e[1;31m"
read -p  "     Please select an option :  " warp
echo -e "\e[0m"
 case $warp in
  1)
	clear ; install_resolv
  ;;
  2)
    clear ; change_dns
  ;;
  0)
  sleep 0.5
  clear
  menu
  ;;
  *)
  echo -e "ERROR!! Please Enter an Correct Number"
  sleep 1
  clear
  mdns
  ;;
  esac