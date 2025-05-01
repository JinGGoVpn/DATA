#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/vless.txt")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/usr/local/etc/xray/vless.txt" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### " "/usr/local/etc/xray/vless.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/vless.txt" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/\b$user\b/d" /usr/local/etc/xray/vless.txt
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/config.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/none.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vlessws.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vlessgrpc.json
systemctl restart xray
systemctl restart xray@none
systemctl restart xray@vlessws
systemctl restart xray@vlessgrpc
clear
echo " Vless Account Deleted Successfully"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="
echo -e "ScriptMod By JinGGo"
read -n 1 -s -r -p "Press any key to back on menu"
menu