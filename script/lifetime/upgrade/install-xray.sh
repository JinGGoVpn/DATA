#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
# V2Ray Mini Core Version 4.42.2
domain=$(cat /etc/xray/domain)
websc=https://raw.githubusercontent.com/JinGGoVPN/DATA/main

apt install python3 -y
apt install cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
chronyc sourcestats -v
chronyc tracking -v
date


# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# / / Installation Xray Core
xraycore_link="${websc}/script/xray/core/v25.10.15.3/xray.linux.zip"

# / / Make Main Directory
mkdir -p /usr/bin/xray


# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# Make Folder XRay
mkdir -p /var/log/xray/
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /etc/xray/xray.pid
touch /usr/local/etc/xray/warp-domain.txt

uuid=$(cat /proc/sys/kernel/random/uuid)
uuid2=$(cat /proc/sys/kernel/random/uuid)
cat> /usr/local/etc/xray/config.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
  "inbounds": [
    {
      "tag": "vless-xtls",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
#xray-vless-xtls
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "path": "/vless-tls",
            "dest": 3030,
            "xver": 1
          },
          {
            "dest": 80,
            "xver": 1  
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "alpn": ["http/1.1", "h2"],
          "certificates": [
            {
                            "certificateFile": "/usr/local/etc/xray/xray.crt",
                            "keyFile": "/usr/local/etc/xray/xray.key"
            }
          ]
        }
      }
    },

    /* -----------------------------
       80 → Non-TLS VLESS with WS + HTTPUpgrade fallback
    ----------------------------- */
    {
      "tag": "vless-plain-80",
      "port": 80,
      "protocol": "vless",
      "settings": {
        "clients": [
           "id": "${uuid}"
#non-tls
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "path": "/vless-ntls",
            "dest": 3031,
            "xver": 2
          },
          {
            "path": "/vless-hup",
            "dest": 3032,
            "xver": 2
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      }
    },

    /* -----------------------------
       3031 → WebSocket inbound for fallback
    ----------------------------- */
    {
      "tag": "vless-ntls",
      "port": 3031,
      "protocol": "vless",
      "settings": {
        "clients": [
           "id": "${uuid}"
#xray-vless-nontls
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/vless-ntls",
          "headers": {
                "Host": ""
               }
        },
        "quicSettings": {}
          },
          "sniffing": {
              "enabled": true,
              "destOverride": [
                 "http",
                 "tls"
             ]
          }
    },

    /* -----------------------------
       3032 → HTTPUpgrade inbound for fallback
    ----------------------------- */
    {
      "tag": "vless-hup",
      "port": 3032,
      "protocol": "vless",
      "settings": {
        "clients": [
           "id": "${uuid}"
#xray-vless-hup
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "httpupgrade",
        "security": "none",
        "httpupgradeSettings": {
          "path": "/vless-hup"
        }
      },
      "sniffing": {
              "enabled": true,
              "destOverride": [
                 "http",
                 "tls"
             ]
          }
    },

    /* -----------------------------
       8080 → WS inbound for fallback from 443
    ----------------------------- */
    {
      "tag": "vless-tls-in",
      "port": 3030,
      "protocol": "vless",
      "settings": {
        "clients": [
           "id": "${uuid}"
#xray-vless-tls
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/vless-tls"
        }
      }
    }
  ],

  "outbounds": [
   {
            "tag": "default",
            "protocol": "freedom"
        },
    {
            "tag":"socks_out",
            "protocol": "socks",
            "settings": {
                "servers": [
                     {
                        "address": "127.0.0.1",
                        "port": 40000
                    }
                ]
            }
    }
  ],
  "routing": {
    "rules": [
 {
                "type": "field",
                "outboundTag": "socks_out",
                "domain": [
#warp-domain
"jinggo.com"
                  ]
     },
     {
                "type": "field",
                "outboundTag": "default",
                "network": "udp,tcp"
    },
    {
                "type": "field",
                "outboundTag": "blocked",
                "domain": [
                 "playstation.com"
                 ]
    },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
}

END

# starting xray vmess ws tls core on sytem startup
cat> /etc/systemd/system/xray.service << END
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

END

# starting xray vmess ws tls core on sytem startup
cat> /etc/systemd/system/xray@.service << END
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/%i.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

END


# enable xray xtls
systemctl daemon-reload
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray


cd /usr/local/bin
wget -O add-xvless "${websc}/script/lifetime/upgrade/add-xvless.sh"
wget -O del-xvless "${websc}/script/xray/del-xvless.sh"
wget -O renew-xvless "${websc}/script/xray/renew-xvless.sh"
wget -O cek-xvless "${websc}/script/xray/cek-xvless.sh"
wget -O recert-xray "${websc}/script/xray/recert-xray.sh"
wget -O trial-xvless "${websc}/script/lifetime/upgrade/trial-xvless.sh"
wget -O delexp "${websc}/script/xray/delexp.sh"


chmod +x add-xvless
chmod +x del-xvless
chmod +x renew-xvless
chmod +x cek-xvless
chmod +x recert-xray
chmod +x trial-xvless
chmod +x delexp

cd
rm -f install-xray.sh
rm -f /root/domain
clear
echo -e " ${RED}XRAY INSTALL DONE ${NC}"
sleep 2
clear
