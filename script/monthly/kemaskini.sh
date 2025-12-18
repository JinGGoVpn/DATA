#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/mxray
# download script
cd /usr/local/bin
wget -O monthly "${websc}/script/monthly/mxray.sh" && chmod +x mxray
cd
clear
