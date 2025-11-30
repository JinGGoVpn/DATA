#!/bin/bash
clear

websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

#delete file
rm -f /usr/local/bin/add-xvless
rm -f /usr/local/bin/trial-xvless
rm -f /usr/local/bin/add-host

# download script
cd /usr/local/bin
wget -O add-xvless "${websc}/script/lifetime/upgrade/add-xvless.sh" && chmod +x add-xvless
wget -O trial-xvless "${websc}/script/lifetime/upgrade/trial-xvless.sh" && chmod +x trial-xvless
wget -O add-host "${websc}/script/lifetime/upgrade/add-host.sh" && chmod +x add-host


cd
clear
