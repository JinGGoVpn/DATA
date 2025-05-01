#!/bin/bash
clear
red='\e[1;31m'
gr='\e[0;32m'
blue='\e[0;34m'
bb='\e[0;94m'
cy='\033[0;36m'
NC='\e[0m'
clear

MYIP=$(wget -qO- ipv4.icanhazip.com); 
echo "Checking VPS" 
clear

domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "XRAY VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "XRAY VLESS WS NON TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			sleep 1
            add-xvless
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
read -p "SNI (bug) : " sni
read -p "PATH (EXP : wss://bug.com /Press Enter If Only Use Default) : " wss
path=$wss
read -p "Subdomain (EXP : m.google.com. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
sed -i '/#xray-vless-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/vlessws.json
sed -i '/#xray-vless-grpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/vlessgrpc.json
sed -i '/#xray-vless-xtls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","flow": "xtls-rprx-direct","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#xray-vless-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/none.json

echo -e "### $user $exp" >> /usr/local/etc/xray/vless.txt

vlesslink1="vless://${uuid}@${dom}:$tls?path=$path/xvless&security=tls&encryption=none&type=ws&sni=$sni#${user}"
vlesslink2="vless://${uuid}@${dom}:$none?path=$path/xvlessntls&encryption=none&type=ws&host=$sni&sni=$sni#${user}"
vless_direct="vless://${uuid}@${dom}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=$sni#$user"
vlessgrpc="vless://${uuid}@${dom}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vlgrpc&sni=$sni#$user"

digisosial="vless://${uuid}@m.twitter.com.${domain}:$none?path=/xvlessntls&encryption=none&type=ws&host=m.twitter.com#${user}-digisosial"
#digiapn="vless://${uuid}@apn.jinnoe.eu.org:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-digi-apn"
#digiapn1="vless://${uuid}@protect.paymaya.com:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-digi-apn1"
#digiboost="vless://${uuid}@api.useinsider.com:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-digi-boost"

#maxistv="vless://${uuid}@104.16.51.111:$none?path=help.viu.com&encryption=none&type=ws&host=$dom#${user}-maxistv-router"
#maxistv1="vless://${uuid}@help.viu.com:$none?path=help.viu.com&encryption=none&type=ws&host=$dom#${user}-maxistv-hp"
#maxishunt1="vless://${uuid}@api-faceid.maxis.com.my.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=www.mosti.gov.my#$user-maxisnew"
#maxishunt2="vless://${uuid}@api-faceid.maxis.com.my.${domain}:$tls?securuty=tls&path=/xvless&encryption=none&type=ws&host=www.mosti.gov.my&sni=www.mosti.gov.my#${user}-maxisnew1"
#maxishunt3="vless://${uuid}@api-faceid.maxis.com.my.${domain}:$none?path=/xvlessntls&encryption=none&type=ws&host=www.mosti.gov.my#${user}-maxisnew2"

#maxisreborn="vless://${uuid}@zn4oa6cok9jkhgn6c-maxiscx.siteintercept.qualtrics.com:$none?encryption=none&type=ws&host=zn4oa6cok9jkhgn6c-maxiscx.siteintercept.qualtrics.com.$dom#${user}"
#maxissabah="vless://${uuid}@ookla.com:$tls?path=$path=/xvless&security=tls&encryption=none&host=$sni&type=ws&sni=$sni#${user}"


celcomboost="vless://${uuid}@104.17.147.22:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-celcomboost-router"
celcomboost1="vless://${uuid}@www.speedtest.net:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-celcomboost-hp"
celcomboost2="vless://${uuid}@${MYIP}:$none?path=/xvlessntls&encryption=none&type=ws&host=opensignal.com#${user}-celcomboost2"

umobile="vless://${uuid}@www.pubgmobile.com.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=www.pubgmobile.com#$user-umobile-funz"
umobile1="vless://${uuid}$MYIP:$none?path=/xvlessntls&encryption=none&type=ws&host=www.pubgmobile.com#${user}-umobile-funz-ntls"
umobile2="vless://${uuid}@www.pubgmobile.com.${domain}:$tls?path=/xvless&security=tls&encryption=none&type=ws&sni=www.pubgmobile.com#${user}-umobile-funz-tls"
umobile3="vless://${uuid}104.18.8.53:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-umobile-new-ntls"

yes="vless://${uuid}@104.17.112.188:$none?path=/vlessntls&encryption=none&type=ws&host=$dom#${user}-yes-router"
#yes1="vless://${uuid}@eurohealthobservatory.who.int:$none?path=/vlessntlst&encryption=none&type=ws&host=$dom#${user}-yes-hp"

yoodopubg="vless://${uuid}@m.pubgmobile.com.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=m.pubgmobile.com#$user-yodoopubg"
yoodopubg1="vless://${uuid}@${MYIP}:$none?path=$path/xvlessntls&encryption=none&type=ws&host=m.pubgmobile.com#${user}-yodoopubg1"
yoodopokemon="vless://${uuid}@community.pokemon.com.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=community.pokemon.com#$user-yodoopokemon"
yoodopokemon1="vless://${uuid}@${MYIP}:$none?path=$path/xvlessntls&encryption=none&type=ws&host=community.pokemon.com#${user}-yodoopokemon1"

yoodoml="vless://${uuid}@m.mobilelegends.com.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=m.mobilelegends.com#$user-yodooml"
yoodoml1="vless://${uuid}@${MYIP}:$none?path=$path/xvlessntls&encryption=none&type=ws&host=m.mobilelegends.com#${user}-yodooml1"

#unifi="vless://${uuid}@map.unifi.com.my.${domain}:$tls?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=map.unifi.com.my#$user-unifi"
#unifi1="vless://${uuid}@${MYIP}:$none?path=/xvlessntls&encryption=none&type=ws&host=map.unifi.com.my#${user}-unifi1"
unifi2="vless://${uuid}172.66.40.170:$none?path=/xvlessntls&encryption=none&type=ws&host=$dom#${user}-unifi-wow-ntls"

systemctl restart xray
systemctl restart xray@none
systemctl restart xray@vlessws
systemctl restart xray@vlessgrpc
clear
echo -e ""
echo -e "================================="
echo -e "   XRAY VLESS WS & XTLS       " 
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "Expired On     : $exp"
echo -e "IP/Host        : ${MYIP}"
echo -e "Domain         : ${domain}"
echo -e "port TLS       : $tls"
echo -e "port none TLS  : $none"
echo -e "id             : ${uuid}"
echo -e "Encryption     : none"
echo -e "network        : ws"
echo -e "path           : /xvless"
echo -e "================================="
echo -e "LINK VLESS TLS :"
echo -e ""
echo -e "   \```${vlesslink1}\```"
echo -e ""
echo -e "================================="
echo -e "LINK VLESS NTLS : "
echo -e ""
echo -e "   \```${vlesslink2}\```"
echo -e ""
echo -e "================================="
echo -e "LINK VLESS XTLS : "
echo -e ""
echo -e "   \```${vless_direct}\```"
echo -e ""
echo -e "================================="
echo -e "LINK VLESS GRPC : "
echo -e ""
echo -e "   \```${vlessgrpc}\```"
echo -e ""
echo -e "================================="
echo -e ""
echo -e " ${bb}═══════════════════════${NC} "
echo -e " \033[30;5;47m ⇱ TELCO CONFIG ⇲  \033[m"
echo -e " ${bb}═══════════════════════${NC} "
echo -e ""
echo -e "${cy}LINK VLESS DIGI :${NC} "
echo -e ""
#echo -e "   \`${digiapn}\`"
#echo -e ""
#echo -e "   \`${digiapn1}\`"
#echo -e ""
#echo -e "   \`${digiboost}\`"
#echo -e ""
echo -e "   \`${digisosial}\`"
echo -e ""
echo -e "================================="
#echo -e "${cy}LINK VLESS MAXIS-HUNTIP :${NC} "
#echo -e ""
#echo -e "   ${maxishunt1}"
#echo -e ""
#echo -e "   ${maxishunt2}"
#echo -e ""
#echo -e "   ${maxishunt3}"
#echo -e ""
#echo -e "================================="
#echo -e "${cy}LINK VLESS MAXISTV :${NC} "
#echo -e ""
#echo -e "   ${maxistv}"
#echo -e ""
#echo -e "   ${maxistv1}"
#echo -e ""
#echo -e "================================="
#echo -e "${cy}LINK VLESS MAXIS REBORN :${NC} "
#echo -e ""
#echo -e "   \`${maxisreborn}\`"
#echo -e ""
#echo -e "================================="
#echo -e "${cy}LINK VLESS MAXIS SABAH :${NC} "
#echo -e ""
#echo -e "   \`${maxissabah}\`"
#echo -e ""
#echo -e "================================="
echo -e "${cy}LINK VLESS CELCOM :${NC} "
echo -e ""
echo -e "   \`${celcomboost}\`"
echo -e ""
echo -e "   \`${celcomboost1}\`"
echo -e ""
echo -e "   \`${celcomboost2}\`"
echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS UMOBILE :${NC} "
echo -e ""
echo -e "   \`${umobile}\`"
echo -e ""
echo -e "   \`${umobile1}\`"
echo -e ""
echo -e "   \`${umobile2}\`"
echo -e ""
echo -e "   \`${umobile3}\`"
echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS YES :${NC} "
echo -e ""
echo -e "   \`${yes}\`"
echo -e ""
#echo -e "   \`${yes1}\`"
#echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS YODOO PUBG :${NC} "
echo -e ""
echo -e "   \`${yoodopubg}\`"
echo -e ""
echo -e "   \`${yoodopubg1}\`"
echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS YODOO POKEMON :${NC} "
echo -e ""
echo -e "   \`${yoodopokemon}\`"
echo -e ""
echo -e "   \`${yoodopokemon1}\`"
echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS YODOO ML :${NC} "
echo -e ""
echo -e "   \`${yoodoml}\`"
echo -e ""
echo -e "   \`${yoodoml1}\`"
echo -e ""
echo -e "================================="
echo -e "${cy}LINK VLESS UNIFI :${NC} "
echo -e ""
#echo -e "   ${unifi}"
#echo -e ""
#echo -e "   ${unifi1}"
#echo -e ""
echo -e "   \`${unifi2}\`"
echo -e ""
echo -e "================================="
echo -e "ScriptMod By JinGGo"
read -n 1 -s -r -p "Press any key to back on menu"
clear
menu