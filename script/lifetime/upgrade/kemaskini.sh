#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/add-xvless
rm -f /usr/local/bin/trial-xvless
rm -f /usr/local/bin/trial-xvless
rm -f /usr/local/bin/vless-list
rm -f /usr/local/bin/menu
#buat file
touch /usr/local/bin/vless-list
chmod +x /usr/local/bin/vless-list

# download script
cd /usr/local/bin
wget -O add-xvless "${websc}/script/lifetime/upgrade/add-xvless.sh" && chmod +x add-xvless
wget -O trial-xvless "${websc}/script/lifetime/upgrade/trial-xvless.sh" && chmod +x trial-xvless
wget -O menu "${websc}/script/lifetime/upgrade/menu.sh" && chmod +x menu
wget -O vless-list "${websc}/script/lifetime/upgrade/vless-list.sh" && chmod +x vless-list


cd
clear
