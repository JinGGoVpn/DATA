#!/bin/bash

RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'

#, // Autodel vless
data=( `cat /usr/local/etc/xray/vless.txt | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/vless.txt" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d"  /usr/local/etc/xray/config.json
sed -i "/^### $user $exp/,/^},{/d"  /usr/local/etc/xray/vlessws.json
sed -i "/^### $user $exp/,/^},{/d"  /usr/local/etc/xray/vlessgrpc.json
sed -i "/^### $user $exp/,/^},{/d"  /usr/local/etc/xray/none.json
sed -i "/\b$user\b/d" /usr/local/etc/xray/vless.txt
fi
done


systemctl restart xray
systemctl restart xray@vlessws
systemctl restart xray@vlessgrpc
systemctl restart xray@none
systemctl restart cron
