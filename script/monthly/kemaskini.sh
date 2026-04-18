#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/menu
rm -f /usr/local/bin/mxray
rm -f /usr/local/bin/mport-xray

# download script
cd /usr/local/bin
wget -O menu "${websc}/script/monthly/menu.sh" && chmod +x menu
wget -O mxray "${websc}/script/lifetime/upgrade/mxray.sh" && chmod +x mxray
wget -O mport-xray "${websc}/script/lifetime/upgrade/mport-xray.sh" && chmod +x mport-xray
cd
clear
