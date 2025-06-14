#!/bin/bash
clear
red='\e[1;31m'
gr='\e[0;32m'
blue='\e[0;34m'
bb='\e[0;94m'
cy='\033[0;36m'
NC='\e[0m'
clear

today=`date -d "0 days" +"%Y-%m-%d"`
pass=$(cat /etc/pass/accsess)
IZIN=$(curl https://raw.githubusercontent.com/JinGGoVPN/DATA/main/IP/accsess | grep $pass | awk '{print $3}')
if [[ $today < $IZIN ]]; then
    echo -e ""
    clear
else
    echo -e ""
    clear
    echo -e "${red}ACCESS DENIED/EXPIRED...PM TELEGRAM OWNER${NC}"
    sleep 2
    exit 1
fi
clear

IPVPS=$(curl -s icanhazip.com)
DOMAIN=$(cat /etc/xray/domain)
cekxray="$(openssl x509 -dates -noout < /usr/local/etc/xray/xray.crt)"                                      
expxray=$(echo "${cekxray}" | grep 'notAfter=' | cut -f2 -d=)
xcore="$(/usr/local/bin/xray -version | awk 'NR==1 {print $2}')"

usersc=$(cat /etc/pass/accsess)
expsc=$(curl https://raw.githubusercontent.com/JinGGoVPN/DATA/main/IP/accsess | grep $pass | awk '{print $3}')

usrvl="$gr$(grep -o -i "###" /usr/local/etc/xray/vless.txt | wc -l)$NC"
usrovpn="$gr$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)$NC"

clear
echo -e  "  ${cy}IP VPS NUMBER                    : $IPVPS${NC}"
echo -e  "  ${cy}DOMAIN                           : $DOMAIN${NC}"
echo -e  "  ${cy}OS VERSION                       : `hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"${NC}
echo -e  "  ${cy}KERNEL VERSION                   : `uname -r`${NC}"
echo -e  "  ${cy}XRAY CORE VERSION                : $xcore${NC}"
echo -e  "  ${cy}EXP DATE CERT XRAY               : $expxray${NC}"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  "       ${cy}PROTOCOL     SSH/OVPN      VLESS${NC}    "
echo -e  "       "${cy}TOTAL USER${NC}"      [$usrovpn]        [$usrvl]"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " \033[30;5;47m                         ⇱ SSHWS/OVPN MENU ⇲                      \033[m"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " ${bb}[ 01 ]${NC} CREATE NEW USER            ${bb}[ 06 ]${NC} LIST USER INFORMATION"
echo -e  " ${bb}[ 02 ]${NC} CREATE TRIAL USER          ${bb}[ 07 ]${NC} DELETE USER EXPIRED"
echo -e  " ${bb}[ 03 ]${NC} EXTEND ACCOUNT ACTIVE      ${bb}[ 08 ]${NC} SET AUTO KILL LOGIN"
echo -e  " ${bb}[ 04 ]${NC} DELETE ACTIVE USER         ${bb}[ 09 ]${NC} DISPLAY USER MULTILOGIN"
echo -e  " ${bb}[ 05 ]${NC} CHECK USER LOGIN"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " \033[30;5;47m                         ⇱ XRAY MENU ⇲                           \033[m"       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} " 
echo -e  " ${bb}[ 10 ]${NC} CREATE NEW USER            ${bb}[ 14 ]${NC}"" CHECK USER LOGIN"
echo -e  " ${bb}[ 11 ]${NC} CREATE TRIAL USER          ${bb}[ 15 ]${NC}"" DELETE USER EXPIRED"
echo -e  " ${bb}[ 12 ]${NC} EXTEND ACCOUNT ACTIVE      ${bb}[ 16 ]${NC}"" RENEW XRAY CERTIFICATION"
echo -e  " ${bb}[ 13 ]${NC} DELETE ACTIVE USER"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " \033[30;5;47m                         ⇱ SYSTEM MENU ⇲                         \033[m"      
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " ${bb}[ 17 ]${NC} ADD/CHANGE DOMAIN VPS      ${bb}[ 23 ]${NC} SPEEDTEST VPS"
echo -e  " ${bb}[ 18 ]${NC} CHANGE DNS SERVER          ${bb}[ 24 ]${NC} CHECK STREAM GEO LOCATION"
echo -e  " ${bb}[ 19 ]${NC} RESTART ALL SERVICE        ${bb}[ 25 ]${NC} DISPLAY SYSTEM INFORMATIONN"
echo -e  " ${bb}[ 20 ]${NC} CHECK RAM USAGE            ${bb}[ 26 ]${NC} SERVICE STATUS"
echo -e  " ${bb}[ 21 ]${NC} REBOOT VPS                 ${bb}[ 27 ]${NC} SOCKS WRAP                " 
echo -e  " ${bb}[ 22 ]${NC} UPDATE SCRIPT"             
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}" 
echo -e  " ${bb}[  0 ]${NC}" "${cy}EXIT MENU${NC}  "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " ${bb}══════════════════════════════════${NC}"
echo -e  " SCRIPT VERSION : XRAY VLESS (V1) "
echo -e  " USED BY        : $usersc"
echo -e  " EXPIRED ON     : $expsc"
echo -e  " ${bb}══════════════════════════════════${NC}"
echo -e  "  "
echo -e "\e[1;31m"
read -p  "     Please select an option :  " menu
echo -e "\e[0m"
 case $menu in
  1)
  clear ; usernew
  ;;
  2)
  clear ; trial 
  ;;
  3)
  clear ; renew
  ;;
  4)
  clear ; hapus
  ;;
  5)
  clear ; cek
  ;;
  6)
  clear ; member
  ;;
  7)
  clear ; delete
  ;;
  8)
  clear ; autokill
  ;;
  9)
  clear ; ceklim 
  ;;
  10)
  clear ; add-xvless
  ;;
  11)
  clear ; trial-xvless
  ;;
  12)
  clear ; renew-xvless
  ;;
  13)
  clear ; del-xvless
  ;; 
  14)
  clear ; cek-xvless
  ;;
  15)
  clear ; delexp
  ;;
  16)
  clear ; recert-xray
  ;;    
  17)
  clear ; add-host
  ;;
  18)
  clear ; mdns
  ;;
  19)
  clear ; restart-service
  ;;
  20)
  clear ; ram
  ;;
  21)
  clear ; reboot
  ;;
  22)
  clear ; update
  ;;
  23)
  clear ; speedtest
  ;;
  24)
  clear ; nf
  ;;
  25)
  clear ; info
  ;;
  26)
  clear ; status
  ;;
  27)
  clear ; mwarp
  ;;
  0)
  sleep 0.5
  clear
  exit
  ;;
  *)
  echo -e "ERROR!! Please Enter an Correct Number"
  sleep 1
  clear
  menu
  ;;
  esac
