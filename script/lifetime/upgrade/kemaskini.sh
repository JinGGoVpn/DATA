#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/status

# download script
cd /usr/local/bin
wget -O status "${websc}/script/lifetime/upgrade/status.sh" && chmod +x status

cd
clear
