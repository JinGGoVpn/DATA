#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
clear
domain=$(cat /etc/xray/domain)
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=$(wget -qO- icanhazip.com);
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
sleep 1
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "Thank You For Using Our Services"
echo -e "SSH & OpenVPN Account Info"
echo -e "==============================="
echo -e "Username            : $Login "
echo -e "Password            : $Pass"
echo -e "Expired On          : $exp"
echo -e "==============================="
echo -e "Domain              : ${domain}"
echo -e "IP/Host             : $MYIP"
echo -e "OpenSSH             : 22"
echo -e "Dropbear            : 109, 143"
echo -e "SSL/TLS             : 444, 777"
echo -e "Port SSH WS HTTP    : 8880"
echo -e "Port Squid          : 3128, 8080"
echo -e "OpenVPN             : TCP $ovpn http://${MYIP}:81/client-tcp-1194.ovpn"
echo -e "OpenVPN             : UDP $ovpn2 http://${MYIP}:81/client-udp-2200.ovpn"
echo -e "OpenVPN             : SSL 442 http://${MYIP}:81/client-tcp-ssl.ovpn"
echo -e "badvpn              : 7100-7300"
echo -e "==============================="
echo -e "PAYLOAD SSH WS HTTP : GET / HTTP/1.1[crlf]Host: ${domain}[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "==============================="
echo -e "Script Mod By JinGGo007"
read -n 1 -s -r -p "Press any key to back on menu"
menu  
