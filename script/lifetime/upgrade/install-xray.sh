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
xraycore_link="${websc}/script/xray/core/v25.10.15/xray.linux.zip"

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
    "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10000,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
# VLESS XTLS
    {
      "listen": "::",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "flow": "xtls-rprx-vision",
            "id": "$uuid"
#xray-vless-xtls
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "alpn": "h2",
            "dest": 4443,
            "xver": 2
          },
          {
            "dest": 8181,
            "xver": 2
          },
          // Websocket
          {
            "path": "/xvless",
            "dest": "@vless-ws",
            "xver": 2
          },
          // HTTPupgrade
          {
            "path": "/xvless-hup",
            "dest": "@vl-hup",
            "xver": 2
          }
        ]
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "streamSettings": {
        "tlsSettings": {
          "certificates": [
            {
              "ocspStapling": 3600,
              "certificateFile": "/usr/local/etc/xray/fullchain.cer",
              "keyFile": "/usr/local/etc/xray/private.key"
            }
          ],
          "minVersion": "1.2",
          "cipherSuites": "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256:TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256:TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        },
        "network": "tcp",
        "security": "tls"
      },
      "tag": "in-01"
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
}
END

cat> /usr/local/etc/xray/vlessgrpc.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [
        {
        "port": 4443,
        "listen": "127.0.0.1",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#xray-vless-grpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vlgrpc"
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
}
END

cat> /usr/local/etc/xray/vlessws.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [    
    {
      "listen": "@vless-ws",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email":"general@vless-ws",
            "id": "$uuid"
#xray-vless-tls
          }
        ],
        "decryption": "none"
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "streamSettings": {
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/xvless"
        },
        "network": "ws",
        "security": "none"
      },
      "tag": "in-03"
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
}

END


cat> /usr/local/etc/xray/vlesshup.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [   
    {
      "listen": "@vl-hup",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email":"general@vless-ws",
            "id": "$uuid"
#vless
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "httpupgradeSettings": {
          "acceptProxyProtocol": true,
          "path": "/xvless-hup"
        },
        "network": "httpupgrade",
        "security": "none"
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "in-08"
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
}

END

cat> /usr/local/etc/xray/none.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [   
    {
      "port": 80,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$uuid"
#universal
          }
        ],
        "fallbacks": [
          {
            "dest": 8181,
            "xver": 2
          },
          // Websocket
          {
            "path": "/xvless",
            "dest": "@vless-ws",
            "xver": 2
          },
          {
            "dest": 2000,
            "xver": 2
          },
          {
            "dest": 2100,
            "xver": 2
          },
          // HTTPupgrade
          {
            "path": "/xvless-hup",
            "dest": "@vl-hup",
            "xver": 2
          }
        ],
        "decryption": "none"
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "in-18"
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

# enable xray vlessws
systemctl daemon-reload
systemctl enable xray@vlessws
systemctl start xray@vlessws
systemctl restart xray@vlessws

# enable xray vlessgrpc
systemctl daemon-reload
systemctl enable xray@vlessgrpc
systemctl start xray@vlessgrpc
systemctl restart xray@vlessgrpc

# enable xray none tls
systemctl daemon-reload
systemctl enable xray@none
systemctl start xray@none
systemctl restart xray@none

# enable xray vlesshup
systemctl daemon-reload
systemctl enable xray@vlesshup
systemctl start xray@vlesshup
systemctl restart xray@vlesshup



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
