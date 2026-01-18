#!/bin/bash
clear
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'


add-wg() {
# Load params
source /etc/wireguard/params
if [[ "$IP" = "" ]]; then
SERVER_PUB_IP=$(wget -qO- icanhazip.com);
else
SERVER_PUB_IP=$IP
fi
    echo ""
    echo "Tell me a name for the client."
    echo "Use one word only, no special characters."

    until [[ ${CLIENT_NAME} =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        read -rp "Client name: " -e CLIENT_NAME
        CLIENT_EXISTS=$(grep -w $CLIENT_NAME /etc/wireguard/wg0.conf | wc -l)

        if [[ ${CLIENT_EXISTS} == '1' ]]; then
            echo ""
            echo "A client with the specified name was already created, please choose another name."
            exit 1
        fi
    done

    echo "IPv4 Detected"
    ENDPOINT="$SERVER_PUB_IP:$SERVER_PORT"
    WG_CONFIG="/etc/wireguard/wg0.conf"
    LASTIP=$( grep "/32" $WG_CONFIG | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 )
    if [[ "$LASTIP" = "" ]]; then
    CLIENT_ADDRESS="10.66.66.2"
    else
    CLIENT_ADDRESS="10.66.66.$((LASTIP+1))"
    fi

    # Adguard DNS by default
    CLIENT_DNS_1="176.103.130.130"

    CLIENT_DNS_2="176.103.130.131"
    MYIP=$(wget -qO- ifconfig.co);
    read -p "Expired (days): " masaaktif
    exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

    # Generate key pair for the client
    CLIENT_PRIV_KEY=$(wg genkey)
    CLIENT_PUB_KEY=$(echo "$CLIENT_PRIV_KEY" | wg pubkey)
    CLIENT_PRE_SHARED_KEY=$(wg genpsk)

    # Create client file and add the server as a peer
    echo "[Interface]
PrivateKey = $CLIENT_PRIV_KEY
Address = $CLIENT_ADDRESS/24
DNS = $CLIENT_DNS_1,$CLIENT_DNS_2

[Peer]
PublicKey = $SERVER_PUB_KEY
PresharedKey = $CLIENT_PRE_SHARED_KEY
Endpoint = $ENDPOINT
AllowedIPs = 0.0.0.0/0,::/0" >>"$HOME/$SERVER_WG_NIC-client-$CLIENT_NAME.conf"

    # Add the client as a peer to the server
    echo -e "### Client $CLIENT_NAME $exp
[Peer]
PublicKey = $CLIENT_PUB_KEY
PresharedKey = $CLIENT_PRE_SHARED_KEY
AllowedIPs = $CLIENT_ADDRESS/32" >>"/etc/wireguard/$SERVER_WG_NIC.conf"
    systemctl restart "wg-quick@$SERVER_WG_NIC"
    cp $HOME/$SERVER_WG_NIC-client-$CLIENT_NAME.conf /home/vps/public_html/$CLIENT_NAME.conf
    clear
    sleep 0.5
    echo Generate PrivateKey
    sleep 0.5
    echo Generate PublicKey
    sleep 0.5
    echo Generate PresharedKey
    clear
    echo -e ""
    echo -e "==========-Wireguard-=========="
    echo -e "Wireguard  : http://$MYIP:81/$CLIENT_NAME.conf"
    echo -e "==============================="
    echo -e "Expired On      : $exp"
    rm -f /root/wg0-client-$CLIENT_NAME.conf
echo ""
read -n 1 -s -r -p "Press any key to back on menu wireguard"
mwg
}

del-wg() {
source /etc/wireguard/params
    NUMBER_OF_CLIENTS=$(grep -c -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf")
    if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
        clear
        echo ""
        echo "You have no existing clients!"
        exit 1
    fi

    clear
    echo ""
    echo ""
    echo " Select the existing client you want to remove"
    echo " Press CTRL+C to return"
    echo " ==============================="
    echo "     No  Expired   User"
    grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | nl -s ') '
    until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
        if [[ ${CLIENT_NUMBER} == '1' ]]; then
            read -rp "Select one client [1]: " CLIENT_NUMBER
        else
            read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
        fi
    done

    # match the selected number to a client name
    CLIENT_NAME=$(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | sed -n "${CLIENT_NUMBER}"p)
    user=$(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
    exp=$(grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)

    # remove [Peer] block matching $CLIENT_NAME
    sed -i "/^### Client $user $exp/,/^AllowedIPs/d" /etc/wireguard/wg0.conf
    # remove generated client file
    rm -f "/home/vps/public_html/$user.conf"

    # restart wireguard to apply changes
    systemctl restart "wg-quick@$SERVER_WG_NIC"
    service cron restart
clear
echo " Wireguard Account Deleted Successfully"
echo " =========================="
echo " Client Name : $user"
echo " Expired  On : $exp"
echo " =========================="
echo ""
read -n 1 -s -r -p "Press any key to back on menu wireguard"
mwg
}

cek-wg() {
echo > /etc/wireguard/clients.txt
data=( `cat /etc/wireguard/wg0.conf | grep "### Client" | awk '{ print $3 }'`);
hr(){
    numfmt --to=iec-i --suffix=B "$1"
}
x=1
echo "-------------------------------";
echo "---=[ Wireguard User Login ]=---";
echo "-------------------------------";
echo "Name  Remote IP Virtual IP Bytes Received Bytes Sent Last Seen "
for akun in "${data[@]}"
do
pub=$(cat /etc/wireguard/wg0.conf | grep PublicKey | awk '{ print $3 }' | tr '\n' ' ' | awk '{print $'"$x"'}')
echo "$akun $pub" >> /etc/wireguard/clients.txt
x=$(( "$x" + 1 ))
done
CLIENTS_FILE="/etc/wireguard/clients.txt"
if [ ! -s "$CLIENTS_FILE" ]; then
    echo "::: There are no clients to list"
    exit 0
fi
listClients(){
    if DUMP="$(wg-show wg0 dump)"; then
        DUMP="$(tail -n +2 <<< "$DUMP")"
    else
        exit 1
    fi

    printf "\e[1m::: Connected Clients List :::\e[0m\n"

    {
    printf "\e[4mName\e[0m  \t  \e[4mRemote IP\e[0m  \t  \e[4mBytes Received\e[0m  \t  \e[4mBytes Sent\e[0m  \t  \e[4mLast Seen\e[0m\n"

    while IFS= read -r LINE; do
        if [ -n "${LINE}" ]; then
            PUBLIC_KEY="$(awk '{ print $1 }' <<< "$LINE")"
            REMOTE_IP="$(awk '{ print $3 }' <<< "$LINE")"
            BYTES_RECEIVED="$(awk '{ print $6 }' <<< "$LINE")"
            BYTES_SENT="$(awk '{ print $7 }' <<< "$LINE")"
            LAST_SEEN="$(awk '{ print $5 }' <<< "$LINE")"
            CLIENT_NAME="$(grep "$PUBLIC_KEY" "$CLIENTS_FILE" | awk '{ print $1 }')"
            if [ "$HR" = 1 ]; then
                if [ "$LAST_SEEN" -ne 0 ]; then
                    printf "%s  \t  %s  \t  %s  \t  %s  \t  %s  \t  %s\n" "$CLIENT_NAME" "$REMOTE_IP"  "$(hr "$BYTES_RECEIVED")" "$(hr "$BYTES_SENT")" "$(date -d @"$LAST_SEEN" '+%b %d %Y - %T')"
                else
                    printf "%s  \t  %s  \t  %s  \t  %s  \t  %s  \t  %s\n" "$CLIENT_NAME" "$REMOTE_IP"   "$(hr "$BYTES_RECEIVED")" "$(hr "$BYTES_SENT")" "(not yet)"
                fi
            else
                if [ "$LAST_SEEN" -ne 0 ]; then
                    printf "%s  \t  %s  \t  %s  \t  %'d  \t  %'d  \t  %s\n" "$CLIENT_NAME" "$REMOTE_IP"   "$BYTES_RECEIVED" "$BYTES_SENT" "$(date -d @"$LAST_SEEN" '+%b %d %Y - %T')"
                else
                    printf "%s  \t  %s  \t  %s  \t  %'d  \t  %'d  \t  %s\n" "$CLIENT_NAME" "$REMOTE_IP"   "$BYTES_RECEIVED" "$BYTES_SENT" "(not yet)"
                fi
            fi
        fi
    done <<< "$DUMP"

    printf "\n"
    } | column -t -s $'\t'
}
listClients
echo "-------------------------------";
echo -e "By JINGGO007"
echo ""
read -n 1 -s -r -p "Press any key to back on menu wireguard"
mwg
}

renew-wg() {
source /etc/wireguard/params
    NUMBER_OF_CLIENTS=$(grep -c -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf")
    if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
        clear
        echo ""
        echo "You have no existing clients!"
        exit 1
    fi

    clear
    echo ""
    echo "Select an existing client that you want to renew"
    echo " Press CTRL+C to return"
    echo -e "==============================="
    echo "     No  Expired   User"
    grep -E "^### Client" "/etc/wireguard/$SERVER_WG_NIC.conf" | cut -d ' ' -f 3-4 | nl -s ') '
    until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
        if [[ ${CLIENT_NUMBER} == '1' ]]; then
            read -rp "Select one client [1]: " CLIENT_NUMBER
        else
            read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
        fi
    done
read -p "Expired (days): " masaaktif
user=$(grep -E "^### Client" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### Client" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### Client $user $exp/### Client $user $exp4/g" /etc/wireguard/wg0.conf
clear
echo ""
echo " Wireguard Account Has Been Successfully Renewed"
echo " =========================="
echo " Client Name : $user"
echo " Expired  On: $exp4"
echo " =========================="
echo ""
read -n 1 -s -r -p "Press any key to back on menu wireguard"
mwg
}

echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " \033[30;5;47m                      ⇱ MENU WIREGUARD ⇲                        \033[m"       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} " 
echo -e  " ${bb}[ 01 ]${NC} CREATE NEW USER"
echo -e  " ${bb}[ 02 ]${NC} DELETE ACTIVE USER"
echo -e  " ${bb}[ 03 ]${NC} CHECK USER LOGIN"
echo -e  " ${bb}[ 04 ]${NC} EXTEND ACCOUNT ACTIVE"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}" 
echo -e  " ${bb}[  0 ]${NC}" "${cy}EXIT TO MENU${NC}  "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e "\e[1;31m"
read -p "     Please select an option :  "  wg
echo -e "\e[0m"
case $wg in
    1)
    add-wg
    ;;
    2)
    del-wg
    ;;
    3)
    cek-wg
    ;;
    4)
    renew-wg
    ;;
    0)
    menu
    ;;   
    *)
    echo -e "Please enter an correct number"
    sleep 1
    clear
    mwg
    ;;
    esac
