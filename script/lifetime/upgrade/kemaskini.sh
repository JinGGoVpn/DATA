#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/add-xvless
rm -f /usr/local/bin/trial-xvless
rm -f /usr/local/bin/del-xvless
rm -f /usr/local/bin/renew-xvless
rm -f /usr/local/bin/menu
rm -f /usr/local/bin/recert-xray
rm -f /usr/local/bin/vless-list
rm -f /usr/local/bin/mwarp


# download script
cd /usr/local/bin
wget -O mxray "${websc}/script/lifetime/upgrade/mxray.sh" && chmod +x mxray
wget -O mssh "${websc}/script/lifetime/upgrade/mssh.sh" && chmod +x mssh
wget -O mbckp "${websc}/script/lifetime/upgrade/mbckp.sh" && chmod +x mbckp
wget -O menu "${websc}/script/lifetime/upgrade/menu.sh" && chmod +x menu
wget -O mwarp "${websc}/script/lifetime/upgrade/mwarp.sh" && chmod +x mwarp

cd
clear
