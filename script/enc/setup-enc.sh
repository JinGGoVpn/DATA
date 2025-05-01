#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
apt -y update 
apt install build-essential -y
apt install software-properties-common -y
add-apt-repository ppa:neurobin/ppa -y
apt install shc
wget -O /usr/bin/shco https://raw.githubusercontent.com/JinGGoVPN/DATA/main/script/enc/shco.sh ; chmod +x /usr/bin/shco 
cd
wget -O /usr/bin/enc https://raw.githubusercontent.com/JinGGoVPN/DATA/main/script/enc/enc.sh ; chmod +x /usr/bin/enc 
clear
cd
rm -f setup-enc.sh
clear
echo -e " ${RED}ENC SCRIPT INSTALL DONE ${NC}"
sleep 2
clear