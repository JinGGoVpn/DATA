#!/bin/bash
clear
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
M='\e[01;35m' > /dev/null 2>&1; # Black
BL='\e[01;90m' > /dev/null 2>&1; # Black
R='\e[01;91m' > /dev/null 2>&1; # Red
G='\e[01;92m' > /dev/null 2>&1; # Green
Y='\e[01;93m' > /dev/null 2>&1; # Yellow
B='\e[01;94m' > /dev/null 2>&1; # Blue
P='\e[01;95m' > /dev/null 2>&1; # Purple
C='\e[01;96m' > /dev/null 2>&1; # Cyan
W='\e[01;97m' > /dev/null 2>&1; # White
LG='\e[01;37m' > /dev/null 2>&1; # Light Gray
N='\e[0m' > /dev/null 2>&1; # Null

############
clear-log > /dev/null 2>&1
sleep 5
clear

echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/vless.txt | cut -d ' ' -f 2`);
echo -e "-------------------------------";
echo -e "${GREEN}XRAY VLESS USER LOGIN${NC}";
echo -e "-------------------------------";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/ipvless.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvless.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvless.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipvless.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvless.txt | nl)
echo -e "$W user : $G $akun $W";
echo "$jum2";
echo ""
echo -e " --------------------------------$W"
fi
rm -rf /tmp/ipvless.txt
rm -rf /tmp/other.txt
done
echo ""
echo -e "ScriptMod By JinGGo"
read -n 1 -s -r -p "Press any key to back on menu"
menu





