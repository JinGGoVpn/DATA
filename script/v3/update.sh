#!/bin/bash
clear

echo -e "${green}START UPDATE${NC}"
sleep 5
websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main
wget ${websc}/script/v3/kemaskini.sh && chmod +x kemaskini.sh && ./kemaskini.sh

echo -e "${green}UPDATE SELESAI${NC}"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
    read answer
    if [ "$answer" == "${answer#[Yy]}" ]; then
        rm -f kemaskini.sh
        menu
    else
    	rm -f kemaskini.sh
        reboot
    fi
