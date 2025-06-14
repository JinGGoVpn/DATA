clear
echo Installing Websocket-SSH Python
sleep 1
echo Sila Tunggu Sebentar...
sleep 0.5
cd

# // GIT USER
websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

# // SYSTEM WEBSOCKET HTTPS 2092
cat <<EOF> /etc/systemd/system/ws-https.service
[Unit]
Description=Python Proxy Mod By JinGGo
Documentation=https://github.com/JinGGo/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python -O /usr/local/bin/ws-https 

[Install]
WantedBy=multi-user.target
EOF

# // SYSTEM WEBSOCKET HTTP 8880
cat <<EOF> /etc/systemd/system/ws-http.service
[Unit]
Description=Python Proxy Mod By JinGGo
Documentation=https://github.com/JinGGo/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-http 8880
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF


# // PYTHON WEBSOCKET TLS && NONE
wget -q -O /usr/local/bin/ws-https ${websc}/script/sshws/ws-https; chmod +x /usr/local/bin/ws-https

# // PYTHON WEBSOCKET DROPBEAR
wget -q -O /usr/local/bin/ws-http ${websc}/script/sshws/ws-http; chmod +x /usr/local/bin/ws-http


# // RESTART && ENABLE SSHVPN WEBSOCKET TLS 
systemctl daemon-reload
systemctl enable ws-https
systemctl restart ws-https
systemctl enable ws-http
systemctl restart ws-http

