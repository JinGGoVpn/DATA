#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

echo -e "     ${green}WELCOME TO JINGGOVPN ENCRYPTION SHELL SCRIPT${NC}"
echo -e "=========================================================="
echo -e ""
echo -e "Sila masukkan folder yg mahu di encrypt ke root"
echo -e ""
echo -e "Kemudian tekan 1 utk encrypt file atau 0 untuk exit"
echo -e ""
echo -e " [ 1 ] LETS ENCRYPT" 
echo -e " [ 0 ] EXIT" 
echo -e "=========================================================="
echo -e "\e[1;31m"
read -p  "     Please select an option :  " menc
echo -e "\e[0m"
 case $menc in
   1)
   shco
   ;;
   0)
   clear
   exit
   ;;
   *)
   echo -e "ERROR!! Please Enter an Correct Number"
   sleep 1
   clear
   enc
   ;;
   esac