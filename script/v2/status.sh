#!/bin/bash                                                                             
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'  


echo -e  "  "
echo -e  " ═══════════════════════════════════════════════════ "
echo -e "\033[30;5;47m                 ⇱  SERVICE STATUS ⇲              \033[m"
echo -e  " ═══════════════════════════════════════════════════ "                            
echo -e  "  "                                                                            
                                                                            
status="$(systemctl show nginx.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " NGINX              : NGINX Service is "$green"ON"$NC""                
else                                                                                     
echo -e " NGINX              : NGINX Service is "$red"OFF"$NC""      
fi

status="$(systemctl show squid --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " SQUID              : SQUID  Service is "$green"ON"$NC""              
else                                                                                    
echo -e " SQUID              : SQUID  Service is "$red"OFF"$NC""    
fi 

status="$(systemctl show openvpn.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " OPENVPN            : OPENVPN Service is "$green"ON"$NC""                
else                                                                                    
echo -e " OPENVPN            : OPENVPN Service is "$red"OFF"$NC""      
fi

status="$(systemctl show xray --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " XRAY XTLS          : XRAY XTLS Service is "$green"ON"$NC""              
else                                                                                    
echo -e " XRAY XTLS          : XRAY XTLS Service is "$red"OFF"$NC""    
fi              

status="$(systemctl show xray@vlessws --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " XRAY WS            : XRAY WS Service is "$green"ON"$NC""              
else                                                                                   
echo -e " XRAY WS            : XRAY WS Service is "$red"OFF"$NC""    
fi 

status="$(systemctl show xray@vlessgrpc --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " XRAY GRPC          : XRAY GRPC Service is "$green"ON"$NC""              
else                                                                                    
echo -e " XRAY GRPC          : XRAY GRPC Service is "$red"OFF"$NC""    
fi                                                                          

status="$(systemctl show xray@none --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " XRAY NON TLS       : XRAY NON TLS Service is "$green"ON"$NC""              
else                                                                                    
echo -e " XRAY NON TLS       : XRAY NON TLS Service is "$red"OFF"$NC""    
fi 

status="$(systemctl show ws-http.service --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
echo -e " SSH WS HTTP        : SSH WS HTTP  Service is "$green"ON"$NC""              
else                                                                                    
echo -e " SSH WS HTTP        : SSH WS HTTP  Service is "$red"OFF"$NC""    
fi 


echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu