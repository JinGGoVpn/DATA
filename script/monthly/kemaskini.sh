#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/mxray
rm -f /usr/local/bin/menu
rm -f /usr/local/bin/mssh
# download script
cd /usr/local/bin
wget -O mxray "${websc}/script/monthly/mxray.sh" && chmod +x mxray
wget -O menu "${websc}/script/monthly/menu.sh" && chmod +x menu
wget -O mssh "${websc}/script/monthly/mssh.sh" && chmod +x mssh
cd
clear
