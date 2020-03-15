#!/bin/sh
# Download and install V2Ray
curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
mkdir /usr/bin/v2ray /etc/v2ray
touch /etc/v2ray/config.json
unzip /v2ray.zip -d /usr/bin/v2ray
# Remove /v2ray.zip and other useless files
rm -rf /v2ray.zip /usr/bin/v2ray/*.sig /usr/bin/v2ray/doc /usr/bin/v2ray/*.json /usr/bin/v2ray/*.dat /usr/bin/v2ray/sys*
# V2Ray new configuration
cat <<-EOF > /etc/v2ray/config.json
{
  "log": {
      "access": "/var/log/v2ray/access.log",
      "error": "/var/log/v2ray/error.log",
      "loglevel": "warning"
  },
  "inbound": {
      "port": 80,
      "protocol": "vmess",
      "settings": {
          "clients": [
              {
                  "id": "a641f8a8-470b-8805-903d-fe5840481cb5",
                  "level": 1,
                  "email": "http@4xx.me",
                  "alterId": 64
              }
          ]
      },
      "streamSettings": {
        "network": "tcp",
        "httpSettings": { 
            "path": "/http"
        },
        "tcpSettings": {
            "header": { 
              "type": "http",
              "response": {
                "version": "1.1",
                "status": "200",
                "reason": "OK",
                "headers": {
                  "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"],
                  "Transfer-Encoding": ["chunked"],
                  "Connection": ["keep-alive"],
                  "Pragma": "no-cache"
                }
              }
            }
        }
      }
  },
  "outbound": {
      "protocol": "freedom",
      "settings": {}
  },
  "inboundDetour": [
      {
          "port": 10000,
          "listen":"127.0.0.1",
          "protocol": "vmess",
          "settings": {
              "clients": [
                  {
                      "id": "ed827005-d9cc-dfe2-161a-2e0b0f0b077a",
                      "level": 1,
                      "email": "https@4xx.me",
                      "alterId": 64
                  }
              ]
          },
          "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/https"
                }
            }
      }
  ],
  "outboundDetour": [
      {
          "protocol": "blackhole",
          "settings": {},
          "tag": "blocked"
      }
  ],
  "routing": {
      "strategy": "rules",
      "settings": {
          "rules": [
              {
                  "type": "field",
                  "ip": [
                      "0.0.0.0/8",
                      "10.0.0.0/8",
                      "100.64.0.0/10",
                      "127.0.0.0/8",
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
              }
          ]
      }
  }
}
EOF
/usr/bin/v2ray/v2ray -config=/etc/v2ray/config.json
