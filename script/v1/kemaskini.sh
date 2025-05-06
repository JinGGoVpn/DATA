#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/add-xvless
rm -f /usr/local/bin/trial-xvless
rm -f /usr/local/bin/menu
rm -f /usr/local/bin/mwarp
# download script
cd /usr/local/bin
wget -O add-xvless "${websc}/script/xray/add-xvless.sh" && chmod +x add-xvless
wget -O trial-xvless "${websc}/script/xray/trial-xvless.sh" && chmod +x trial-xvless
wget -O menu "${websc}/script/v1/menu.sh" && chmod +x menu
wget -O mwarp "${websc}/script/warp/mwarp.sh" && chmod +x mwarp
cd
clear
