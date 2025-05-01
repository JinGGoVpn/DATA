#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "Checking VPS"
clear
echo -e "============================================="
echo -e " ${green} RECERT XRAY${NC}"
echo -e "============================================="
sleep 1
echo start
sleep 0.5
domain=$(cat /etc/xray/domain)
systemctl stop xray
systemctl stop xray.service
systemctl stop xray@vlessws
systemctl stop xray@vlessgrpc
systemctl stop xray@none
systemctl stop nginx
sudo kill -9 $(sudo lsof -t -i:80)
~/.acme.sh/acme.sh --renew -d $domain --standalone -k ec-256 --force --ecc
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
systemctl daemon-reload
systemctl restart xray
systemctl restart xray.service
systemctl restart xray@none
systemctl restart xray@vlessws
systemctl restart xray@vlessgrpc
systemctl restart nginx
echo Done
sleep 0.5
clear
echo -e "============================================="
echo -e " ${green} RECERT DOMAIN SELESAI${NC}"
echo -e "============================================="
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu