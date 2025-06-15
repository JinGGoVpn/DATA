#!/bin/bash
#
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
# ==================================================

# // initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# // Domain
domain=$(cat /root/domain)
websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

# // detail nama perusahaan
country=MY
state=Malaysia
locality=Malaysia
organization=jinggo
organizationalunit=jinggo
commonname=jinggo.xyz
email=jinggovpn@gmail.com

# // simple password minimal
wget -O /etc/pam.d/common-password "${websc}/script/sshovpn/password"
chmod +x /etc/pam.d/common-password

# // go to root
cd

# // Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# // nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# // Ubah izin akses
chmod +x /etc/rc.local

# // enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# // disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# // update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# // Install Wget And Curl
apt -y install wget curl

# // Install Requirements Tools
apt install ruby -y
apt install python -y
apt install make -y
apt install cmake -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
apt install libssl1.0-dev -y
apt install dos2unix -y
apt install curl -y
apt install pwgen openssl netcat cron -y
apt install socat -y
apt install htop -y
apt install iftop -y
echo "clear" >> .profile
echo "menu" >> .profile

# // set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
date

# // set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# // Nginx
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "${websc}/script/sshovpn/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "${websc}/script/sshovpn/vps.conf"
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart

systemctl daemon-reload
systemctl enable nginx
ufw disable

# / / Make Main Directory
mkdir -p /usr/local/etc/xray/
touch /usr/local/etc/xray/vless.txt


# Generate certificates
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
service squid start
cd
systemctl restart nginx
sleep 1
clear

# // install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "${websc}/script/sshovpn/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500


# // setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# // install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# // install squid
cd
# install squid for debian 11
apt -y install squid
wget -O /etc/squid/squid.conf "${websc}/script/sshovpn/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# // Setting Vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# // install stunnel
apt install stunnel4 -y

cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 444
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[wss-stunnel]
accept = 2096
connect = 127.0.0.1:2092

END

# // make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# // konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#sshws
apt -y install python
apt -y install tmux
apt -y install ruby
gem install lolcat
apt -y install figlet

# // OpenVPN
#wget ${websc}/script/sshovpn/vpn.sh && chmod +x vpn.sh && ./vpn.sh

# // install fail2ban
apt install -y dnsutils tcpdump dsniff grepcidr
apt -y install fail2ban

# // Instal DDOS Flate
#wget https://data.jinggo.eu.org/script/sshovpn/install-ddos.sh && chmod +x install-ddos.sh && ./install-ddos.sh

# banner /etc/issue.net
wget -O /etc/issue.net "${websc}/script/sshovpn/issue.net"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# // blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# // download script
cd /usr/local/bin

# // menu ssh-ovpn
wget -O usernew "${websc}/script/sshovpn/usernew.sh"
wget -O trial "${websc}/script/sshovpn/trial.sh"
wget -O renew "${websc}/script/sshovpn/renew.sh"
wget -O hapus "${websc}/script/sshovpn/hapus.sh"
wget -O cek "${websc}/script/sshovpn/cek.sh"
wget -O delete "${websc}/script/sshovpn/delete.sh"
wget -O ceklim "${websc}/script/sshovpn/ceklim.sh"
wget -O autokill "${websc}/script/sshovpn/autokill.sh"
wget -O tendang "${websc}/script/sshovpn/tendang.sh"
wget -O member "${websc}/script/sshovpn/member.sh"

# // menu system
wget -O add-host "${websc}/script/menu/add-host.sh"
wget -O speedtest "${websc}/script/menu/speedtest_cli.py"
wget -O restart-service "${websc}/script/v2/restart-service.sh"
wget -O ram "${websc}/script/menu/ram.sh"
wget -O info "${websc}/script/menu/info.sh"
wget -O nf "${websc}/script/menu/nf.sh"
wget -O mdns "${websc}/script/menu/mdns.sh"
wget -O status "${websc}/script/v2/status.sh"
wget -O update "${websc}/script/v2/update.sh"


# menu
wget -O menu "${websc}/script/v2/menu.sh"
wget -O mwarp "${websc}/script/warp/mwarp.sh"


# // xpired
wget -O clear-log "${websc}/script/menu/clear-log.sh"
wget -O clearcache "${websc}/script/menu/clearcache.sh"

chmod +x add-host
chmod +x speedtest
chmod +x restart-service
chmod +x ram
chmod +x info
chmod +x nf
chmod +x mdns
chmod +x status
chmod +x update
chmod +x menu
chmod +x mwarp

chmod +x clear-log
chmod +x clearcache


chmod +x usernew
chmod +x trial
chmod +x renew
chmod +x hapus
chmod +x cek
chmod +x delete
chmod +x ceklim
chmod +x autokill
chmod +x tendang
chmod +x member



cd
rm -f /etc/crontab
touch /etc/crontab
echo "SHELL=/bin/sh" >> /etc/crontab
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/crontab
echo "0 */08 * * * root /usr/local/bin/clear-log # clear log every 8 hours" >> /etc/crontab
echo "0 */08 * * * root /usr/local/bin/clearcache  # clear cache every 1hours daily" >> /etc/crontab
echo "0 8 * * * root /usr/local/bin/delete # delete expired user" >> /etc/crontab
echo "0 0 * * * root /usr/local/bin/delexp # delete expired user" >> /etc/crontab
echo "0 5 * * * root reboot" >> /etc/crontab


# // remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y


/etc/init.d/nginx restart
#/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

history -c
cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# // finihsing
clear
echo -e "${RED}SSH-VPN INSTALL DONE${NC} "
sleep 2
