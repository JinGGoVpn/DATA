#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

echo -e "${green}MASUKKAN NAMA FOLDER FILE${NC}"
read -rp "Folder : " -e fol
mkdir /root/${fol}.x
echo -e "${green}ENCRYPTION IN PROGRESS${NC}"
sleep 2

cp -r /root/${fol}/* /root/${fol}.x &> /dev/null
cd ${fol}.x
ohgini=$(ls -1)
shcku (){
shc -r -f $sayang  -o /root/${fol}.x/$sayang
rm -rf $sayang.x.c
}
for sayang in $ohgini 
do
        shcku;
done
echo -e "${green}ENCRYTION FILE COMPLETE..CHECK ENC FILE AT FOLDER ${fol}.x ${NC}"
sleep 2
cd
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
enc