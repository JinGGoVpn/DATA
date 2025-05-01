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
clear
echo -e  "  ${cy}IP VPS NUMBER                    : $IPVPS${NC}"
echo -e  "  ${cy}DOMAIN                           : $DOMAIN${NC}"
echo -e  "  ${cy}OS VERSION                       : `hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"${NC}
echo -e  "  ${cy}KERNEL VERSION                   : `uname -r`${NC}"
echo -e  "  ${cy}XRAY CORE VERSION                : $xcore${NC}"
echo -e  "  ${cy}EXP DATE CERT XRAY               : $expxray${NC}"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  "       ${cy}PROTOCOL      VLESS      ${NC}    "
echo -e  "       "${cy}TOTAL USER${NC}"    [$usrvl]                "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " \033[30;5;47m                         ⇱ XRAY MENU ⇲                           \033[m"       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} " 
echo -e  " ${bb}[  1 ]${NC} CREATE NEW USER            ${bb}[  5 ]${NC}"" CHECK USER LOGIN"
echo -e  " ${bb}[  2 ]${NC} CREATE TRIAL USER          ${bb}[  6 ]${NC}"" DELETE USER EXPIRED"
echo -e  " ${bb}[  3 ]${NC} EXTEND ACCOUNT ACTIVE      ${bb}[  7 ]${NC}"" RENEW XRAY CERTIFICATION"
echo -e  " ${bb}[  4 ]${NC} DELETE ACTIVE USER"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " \033[30;5;47m                         ⇱ SYSTEM MENU ⇲                         \033[m"      
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " ${bb}[  8 ]${NC} ADD/CHANGE DOMAIN VPS      ${bb}[ 14 ]${NC} SPEEDTEST VPS"
echo -e  " ${bb}[  9 ]${NC} CHANGE DNS SERVER          ${bb}[ 15 ]${NC} CHECK STREAM GEO LOCATION"
echo -e  " ${bb}[ 10 ]${NC} RESTART ALL SERVICE        ${bb}[ 16 ]${NC} DISPLAY SYSTEM INFORMATIONN"
echo -e  " ${bb}[ 11 ]${NC} CHECK RAM USAGE            ${bb}[ 17 ]${NC} SERVICE STATUS"
echo -e  " ${bb}[ 12 ]${NC} REBOOT VPS" 
echo -e  " ${bb}[ 13 ]${NC} UPDATE SCRIPT"             
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
  clear ; add-xvless
  ;;
  2)
  clear ; trial-xvless
  ;;
  3)
  clear ; renew-xvless
  ;;
  4)
  clear ; del-xvless
  ;; 
  5)
  clear ; cek-xvless
  ;;
  6)
  clear ; delexp
  ;;
  7)
  clear ; recert-xray
  ;;    
  8)
  clear ; add-host
  ;;
  9)
  clear ; mdns
  ;;
  10)
  clear ; restart-service
  ;;
  11)
  clear ; ram
  ;;
  12)
  clear ; reboot
  ;;
  13)
  clear ; update
  ;;
  14)
  clear ; speedtest
  ;;
  15)
  clear ; nf
  ;;
  16)
  clear ; info
  ;;
  17)
  clear ; status
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
