#!/bin/bash
export LANG=en_US.UTF-8
mkdir -p "$HOME/agsbx"
url='https://raw.githubusercontent.com/chrimast/sbx/main/sbx.sh'
case "${*##* }" in list|del|upx|ups|res) ;; *)
cmd=""
for v in uuid vlpt hypt xhpt anpt arpt sopt xupt xcpt reym cdnym name oap alns cadn; do
[ -n "${!v+x}" ] && cmd+="$v=\"${!v}\" "
done
main="bash <(curl -Ls $url)"
cmd+="$main${*:+ $*}"
[ "$cmd" != "$main" ] && echo "$cmd" > "$HOME/agsbx/sh.txt"
;; esac
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${sopt+x}" ] || sop=yes
[ -z "${xupt+x}" ] || xup=yes
[ -z "${xcpt+x}" ] || xcp=yes
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
if [ "$1" = "rep" ]; then
[ "$xcp" = yes ] || [ "$xup" = yes ] || [ "$sop" = yes ] || [ "$vlp" = yes ] || [ "$hyp" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：rep 重置协议时，请至少设置一个协议变量"; exit; }
fi
else
[ "$1" = "del" ] || [ "$xcp" = yes ] || [ "$xup" = yes ] || [ "$sop" = yes ] || [ "$vlp" = yes ] || [ "$hyp" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：未安装脚本，请至少设置一个协议变量"; exit; }
fi
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_hy2=${hypt:-''}
export port_xh=${xhpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_so=${sopt:-''}
export port_xu=${xupt:-''}
export port_xc=${xcpt:-''}
export ym_vl_re=${reym:-''}
export cdnym=${cdnym:-''}
export ippz=${ippz:-''}
export name=${name:-''}
export oap=${oap:-''}
export alns=${alns:-''}
export cadn=${cadn:-''}
v46url="https://icanhazip.com"
sbxurl="https://raw.githubusercontent.com/chrimast/sbx/main/sbx.sh"
showmode(){
[ -s "$HOME/agsbx/sh.txt" ] && echo "上次输入的完整脚本：$(cat "$HOME/agsbx/sh.txt")"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/chrimast/sbx/main/sbx.sh) 或 bash <(wget -qO- https://raw.githubusercontent.com/chrimast/sbx/main/sbx.sh)"
echo "显示节点信息命令：sbx list 【或者】 主脚本 list"
echo "重置变量组命令：自定义各种协议变量组 sbx rep 【或者】 自定义各种协议变量组 主脚本 rep"
echo "更新脚本命令：原已安装的自定义各种协议变量组 主脚本 rep"
echo "更新Xray或Singbox内核命令：sbx upx或ups 【或者】 主脚本 upx或ups"
echo "重启脚本命令：sbx res 【或者】 主脚本 res"
echo "卸载脚本命令：sbx del 【或者】 主脚本 del"
echo "双栈VPS显示IPv4/IPv6节点配置命令：ippz=4或6 sbx list 【或者】 ippz=4或6 主脚本 list"
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "SBX 脚本"
echo "当前版本：V26.10.30"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
arm64|aarch64) cpu=arm64;;
amd64|x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
if [ "$1" != "del" ]; then
if [ ! -f sbx_update ]; then
echo "执行必要的脚本依赖中，请稍等10秒……"
if command -v apk >/dev/null 2>&1; then
apk update >/dev/null 2>&1 && apk add --no-cache bash busybox-extras gcompat libc6-compat iptables openssl unzip tar socat curl >/dev/null 2>&1
elif command -v apt >/dev/null 2>&1; then
export DEBIAN_FRONTEND=noninteractive
printf 'iptables-persistent iptables-persistent/autosave_v4 boolean true\niptables-persistent iptables-persistent/autosave_v6 boolean true\n' | debconf-set-selections
apt update >/dev/null 2>&1 && apt install -y busybox coreutils util-linux iptables iptables-persistent cron openssl unzip tar socat curl >/dev/null 2>&1
fi
touch sbx_update
fi
fi
v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- "$v46url" 2>/dev/null) )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- "$v46url" 2>/dev/null) )
#v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://myip.ipip.net/ | awk -F'来自于：' '{print $2}' 2>/dev/null) )
v6dq=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -6 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
v4dq=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k https://ip.fm | sed -n 's/.*Location: //p' 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 --tries=2 -qO- https://ip.fm | grep '<span class="has-text-grey-light">Location:' | tail -n1 | sed -E 's/.*>Location: <\/span>([^<]+)<.*/\1/' 2>/dev/null) )
}
outcfg(){
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsbx/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct
if command -v curl >/dev/null 2>&1; then
curl -s4m5 -k "$v46url" >/dev/null 2>&1 && v4_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -4 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v4_ok=true
fi
if command -v curl >/dev/null 2>&1; then
curl -s6m5 -k "$v46url" >/dev/null 2>&1 && v6_ok=true
elif command -v wget >/dev/null 2>&1; then
timeout 3 wget -6 --tries=2 -qO- "$v46url" >/dev/null 2>&1 && v6_ok=true
fi
if [ "$v4_ok" = true ] && [ "$v6_ok" = true ]; then
sbyx='prefer_ipv4'
xryx='ForceIPv4v6'
elif [ "$v4_ok" = true ]; then
sbyx='ipv4_only'
xryx='ForceIPv4'
elif [ "$v6_ok" = true ]; then
sbyx='ipv6_only'
xryx='ForceIPv6'
else
sbyx='prefer_ipv4'
xryx='ForceIPv4v6'
fi
}
issueca(){
if [ -s /root/sbxca/private.key ] && [ -s /root/sbxca/cert.crt ] && [ -s /root/sbxca/ca.log ]; then
echo "已存在 /root/sbxca 证书，跳过申请"
return 0
fi
if [ "$EUID" -ne 0 ]; then
echo "证书申请失败：需要 root"
return 1
fi
v4v6
if [ -n "$cadn" ]; then
ym=$cadn
elif [ -n "$v4" ]; then
ym=$v4
elif [ -n "$v6" ]; then
ym=$v6
else
echo "证书申请失败：无法获取本机 IP"
return 1
fi
echo "=========申请 Let's Encrypt 证书：$ym ========="
if ! command -v socat >/dev/null 2>&1; then
echo "证书申请失败：缺少 socat"
return 1
fi
ACME_HOME=/root/.acme.sh
if [ ! -x "$ACME_HOME/acme.sh" ]; then
email="sbx$(date +%s)@gmail.com"
echo "安装官方 acme.sh"
if command -v curl >/dev/null 2>&1; then
curl https://get.acme.sh | sh -s email=$email
elif command -v wget >/dev/null 2>&1; then
wget -O - https://get.acme.sh | sh -s email=$email
else
echo "证书申请失败：缺少 curl/wget"
return 1
fi
fi
if [ ! -x "$ACME_HOME/acme.sh" ]; then
echo "证书申请失败：acme.sh 安装失败"
return 1
fi
if command -v lsof >/dev/null 2>&1; then
lsof -t -iTCP:80 -sTCP:LISTEN 2>/dev/null | xargs -r kill >/dev/null 2>&1
fi
mkdir -p /root/sbxca
le_extra=""
if echo "$ym" | grep -q ':'; then
le_extra="$le_extra --listen-v6"
fi
if echo "$ym" | grep -Eq '^([0-9]+\.){3}[0-9]+$|^[0-9a-fA-F:]+$'; then
le_extra="$le_extra --cert-profile shortlived --days 3"
fi
# shellcheck disable=SC2086
if ! "$ACME_HOME/acme.sh" --issue -d "$ym" --standalone -k ec-256 --server letsencrypt --insecure $le_extra; then
echo "证书申请失败：Let's Encrypt 签发失败（80 端口需空闲；域名需解析到本机且关闭 CDN）"
return 1
fi
if ! "$ACME_HOME/acme.sh" --install-cert -d "$ym" --key-file /root/sbxca/private.key --fullchain-file /root/sbxca/cert.crt --ecc; then
echo "证书申请失败：安装证书失败"
return 1
fi
echo "$ym" > /root/sbxca/ca.log
if [ ! -s /root/sbxca/private.key ] || [ ! -s /root/sbxca/cert.crt ]; then
echo "证书申请失败：未生成证书文件"
return 1
fi
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/acme.sh --cron/d' /tmp/crontab.tmp
echo "0 0 * * * $ACME_HOME/acme.sh --cron --home $ACME_HOME >/dev/null 2>&1" >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm -f /tmp/crontab.tmp
echo "证书已保存到 /root/sbxca （cert.crt / private.key / ca.log）"
}
upxray(){
mkdir -p "$HOME/agsbx" /tmp/sbxcore
if [ "$cpu" = arm64 ]; then
xzip="Xray-linux-arm64-v8a.zip"
else
xzip="Xray-linux-64.zip"
fi
url="https://github.com/XTLS/Xray-core/releases/latest/download/${xzip}"
tmp="/tmp/sbxcore/${xzip}"
echo "下载官方 Xray：${url}"
(command -v curl >/dev/null 2>&1 && curl -Lo "$tmp" -# --retry 2 "$url") || (command -v wget >/dev/null 2>&1 && wget -O "$tmp" --tries=2 "$url")
if [ ! -s "$tmp" ]; then
echo "Xray 下载失败"
return 1
fi
if command -v unzip >/dev/null 2>&1; then
unzip -o -j "$tmp" xray -d "$HOME/agsbx" >/dev/null 2>&1
elif command -v python3 >/dev/null 2>&1; then
python3 - "$tmp" "$HOME/agsbx/xray" <<'PY'
import zipfile, sys
z = zipfile.ZipFile(sys.argv[1])
open(sys.argv[2], "wb").write(z.read("xray"))
PY
else
echo "缺少 unzip，无法解压 Xray"
rm -f "$tmp"
return 1
fi
rm -f "$tmp"
chmod +x "$HOME/agsbx/xray"
sbcore=$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
}
upsingbox(){
mkdir -p "$HOME/agsbx" /tmp/sbxcore
if command -v curl >/dev/null 2>&1; then
tag=$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/SagerNet/sing-box/releases/latest | tr -d '\r' | sed 's|.*/||')
elif command -v wget >/dev/null 2>&1; then
tag=$(wget --max-redirect=0 --server-response -qO /dev/null https://github.com/SagerNet/sing-box/releases/latest 2>&1 | awk 'tolower($1) ~ /location:/ {print $2; exit}' | tr -d '\r' | sed 's|.*/||')
fi
ver=${tag#v}
if [ -z "$ver" ]; then
echo "无法获取 sing-box 最新版本"
return 1
fi
url="https://github.com/SagerNet/sing-box/releases/download/${tag}/sing-box-${ver}-linux-${cpu}.tar.gz"
tmp="/tmp/sbxcore/sing-box.tgz"
echo "下载官方 Sing-box：${url}"
(command -v curl >/dev/null 2>&1 && curl -Lo "$tmp" -# --retry 2 "$url") || (command -v wget >/dev/null 2>&1 && wget -O "$tmp" --tries=2 "$url")
if [ ! -s "$tmp" ]; then
echo "Sing-box 下载失败"
return 1
fi
rm -rf /tmp/sbxcore/sb
mkdir -p /tmp/sbxcore/sb
tar -xzf "$tmp" -C /tmp/sbxcore/sb
found=$(find /tmp/sbxcore/sb -type f -name sing-box | head -n 1)
if [ -z "$found" ]; then
echo "Sing-box 压缩包中未找到二进制"
rm -rf /tmp/sbxcore/sb "$tmp"
return 1
fi
mv "$found" "$HOME/agsbx/sing-box"
rm -rf /tmp/sbxcore/sb "$tmp"
chmod +x "$HOME/agsbx/sing-box"
sbcore=$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
}
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsbx/uuid" ]; then
if [ -e "$HOME/agsbx/sing-box" ]; then
uuid=$("$HOME/agsbx/sing-box" generate uuid)
else
uuid=$("$HOME/agsbx/xray" uuid)
fi
echo "$uuid" > "$HOME/agsbx/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsbx/uuid"
fi
uuid=$(cat "$HOME/agsbx/uuid")
echo "UUID密码：$uuid"
}
installxray(){
echo
echo "=========启用xray内核========="
mkdir -p "$HOME/agsbx/xrk"
if [ ! -e "$HOME/agsbx/xray" ]; then
upxray
fi
cat > "$HOME/agsbx/xr.json" <<EOF
{
  "log": {
  "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=bing.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
if [ ! -e "$HOME/agsbx/xrk/private_key" ]; then
key_pair=$("$HOME/agsbx/xray" x25519)
private_key=$(echo "$key_pair" | awk -F':' '/PrivateKey/ {print $2}' | xargs)
public_key=$(echo "$key_pair" | awk -F':' '/Password/ {print $2}' | xargs)
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/agsbx/xrk/private_key"
echo "$public_key" > "$HOME/agsbx/xrk/public_key"
echo "$short_id" > "$HOME/agsbx/xrk/short_id"
fi
private_key_x=$(cat "$HOME/agsbx/xrk/private_key")
public_key_x=$(cat "$HOME/agsbx/xrk/public_key")
short_id_x=$(cat "$HOME/agsbx/xrk/short_id")
fi
if [ -n "$xhp" ]; then
if [ ! -e "$HOME/agsbx/xrk/dekey" ]; then
vlkey=$("$HOME/agsbx/xray" vlessenc)
dekey=$(echo "$vlkey" | grep '"decryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
enkey=$(echo "$vlkey" | grep '"encryption":' | sed -n '2p' | cut -d' ' -f2- | tr -d '"')
echo "$dekey" > "$HOME/agsbx/xrk/dekey"
echo "$enkey" > "$HOME/agsbx/xrk/enkey"
fi
dekey=$(cat "$HOME/agsbx/xrk/dekey")
enkey=$(cat "$HOME/agsbx/xrk/enkey")
fi

if [ -n "$xhp" ]; then
xhp=xhpt
if [ -z "$port_xh" ] && [ ! -e "$HOME/agsbx/port_xh" ]; then
port_xh=$(shuf -i 10000-65535 -n 1)
echo "$port_xh" > "$HOME/agsbx/port_xh"
elif [ -n "$port_xh" ]; then
echo "$port_xh" > "$HOME/agsbx/port_xh"
fi
port_xh=$(cat "$HOME/agsbx/port_xh")
echo "Vless-xhttp-reality-enc端口：$port_xh"
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "${dekey}"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptargo
fi
if [ -n "$xup" ]; then
xup=xupt
if [ -z "$port_xu" ] && [ ! -e "$HOME/agsbx/port_xu" ]; then
port_xu=$(shuf -i 10000-65535 -n 1)
echo "$port_xu" > "$HOME/agsbx/port_xu"
elif [ -n "$port_xu" ]; then
echo "$port_xu" > "$HOME/agsbx/port_xu"
fi
port_xu=$(cat "$HOME/agsbx/port_xu")
echo "Vless-xhttp-tls-UDP端口：$port_xu"
cat >> "$HOME/agsbx/xr.json" <<EOF
{
  "tag": "xhttp-h3",
  "listen": "::",
  "port": ${port_xu},
  "protocol": "vless",
  "settings": {
    "clients": [
      {
        "id": "${uuid}",
        "flow": ""
      }
    ],
    "decryption": "none"
  },
  "streamSettings": {
    "network": "xhttp",
    "security": "tls",
    "xhttpSettings": {
    "mode": "auto",
    "path": "${uuid}-xu"
    },
    "tlsSettings": {
      "alpn": [
        "h3"
      ],
      "certificates": [
        {
          "certificateFile": "$certificateHTA",
          "keyFile": "$keyHTA"
        }
      ]
    }
  },
  "sniffing": {
    "enabled": true,
    "destOverride": ["http", "tls", "quic"],
   "metadataOnly": false
  }
},	
EOF
else
xup=xuptargo
fi

if [ -n "$xcp" ]; then
xcp=xcpt
if [ -z "$port_xc" ] && [ ! -e "$HOME/agsbx/port_xc" ]; then
port_xc=$(shuf -i 10000-65535 -n 1)
echo "$port_xc" > "$HOME/agsbx/port_xc"
elif [ -n "$port_xc" ]; then
echo "$port_xc" > "$HOME/agsbx/port_xc"
fi
port_xc=$(cat "$HOME/agsbx/port_xc")
echo "Vless-xhttp-tls-TCP/UDP端口：$port_xc"
cat >> "$HOME/agsbx/xr.json" <<EOF
{
  "tag": "xhttp-h23",
  "listen": "::",
  "port": ${port_xc},
  "protocol": "vless",
  "settings": {
    "clients": [
      {
        "id": "${uuid}",
        "flow": ""
      }
    ],
    "decryption": "none"
  },
  "streamSettings": {
    "network": "xhttp",
    "security": "tls",
    "xhttpSettings": {
    "mode": "auto",
    "path": "${uuid}-xc"
    },
    "tlsSettings": {
     "alpn": [
      "h2","http/1.1"
       ],
      "certificates": [
        {
          "certificateFile": "$certificateHTA",
          "keyFile": "$keyHTA"
        }
      ]
    }
  },
  "sniffing": {
    "enabled": true,
    "destOverride": ["http", "tls", "quic"],
   "metadataOnly": false
  }
},	
EOF
else
xcp=xcptargo
fi

if [ -n "$vlp" ]; then
vlp=vlpt
if [ -z "$port_vl_re" ] && [ ! -e "$HOME/agsbx/port_vl_re" ]; then
port_vl_re=$(shuf -i 10000-65535 -n 1)
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
elif [ -n "$port_vl_re" ]; then
echo "$port_vl_re" > "$HOME/agsbx/port_vl_re"
fi
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
echo "Vless-tcp-reality-v端口：$port_vl_re"
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptargo
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsbx/sing-box" ]; then
upsingbox
fi
cat > "$HOME/agsbx/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
if [ -n "$anp" ]; then
anp=anpt
if [ -z "$port_an" ] && [ ! -e "$HOME/agsbx/port_an" ]; then
port_an=$(shuf -i 10000-65535 -n 1)
echo "$port_an" > "$HOME/agsbx/port_an"
elif [ -n "$port_an" ]; then
echo "$port_an" > "$HOME/agsbx/port_an"
fi
port_an=$(cat "$HOME/agsbx/port_an")
echo "Anytls端口：$port_an"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[
              "stop=7",
              "0=30-30",
              "1=80-280",
              "2=220-380,c,380-720",
              "3=40-80,200-600",
              "4=300-800",
              "5=200-700",
              "6=250-650"
            ],
            "tls":{
                "enabled": true,
                "certificate_path": "$certificateHTA",
                "key_path": "$keyHTA"
            }
        },
EOF
else
anp=anptargo
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=bing.com
fi
echo "$ym_vl_re" > "$HOME/agsbx/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsbx/sbk"
if [ ! -s "$HOME/agsbx/sbk/private_key" ] || [ ! -s "$HOME/agsbx/sbk/public_key" ] || [ ! -s "$HOME/agsbx/sbk/short_id" ]; then
key_pair=$("$HOME/agsbx/sing-box" generate reality-keypair)
private_key=$(printf '%s\n' "$key_pair" | awk '/PrivateKey/{print $NF}' | tr -d '"')
public_key=$(printf '%s\n' "$key_pair" | awk '/PublicKey/{print $NF}' | tr -d '"')
short_id=$("$HOME/agsbx/sing-box" generate rand 4 --hex)
if [ -z "$private_key" ] || [ -z "$public_key" ] || [ -z "$short_id" ]; then
echo "Reality 密钥生成失败"
exit 1
fi
echo "$private_key" > "$HOME/agsbx/sbk/private_key"
echo "$public_key" > "$HOME/agsbx/sbk/public_key"
echo "$short_id" > "$HOME/agsbx/sbk/short_id"
fi
private_key_s=$(cat "$HOME/agsbx/sbk/private_key")
public_key_s=$(cat "$HOME/agsbx/sbk/public_key")
short_id_s=$(cat "$HOME/agsbx/sbk/short_id")
if [ -z "$private_key_s" ] || [ -z "$public_key_s" ] || [ -z "$short_id_s" ]; then
echo "Reality 密钥生成失败"
exit 1
fi
if [ -z "$port_ar" ] && [ ! -e "$HOME/agsbx/port_ar" ]; then
port_ar=$(shuf -i 10000-65535 -n 1)
echo "$port_ar" > "$HOME/agsbx/port_ar"
elif [ -n "$port_ar" ]; then
echo "$port_ar" > "$HOME/agsbx/port_ar"
fi
port_ar=$(cat "$HOME/agsbx/port_ar")
echo "Any-Reality端口：$port_ar"
cat >> "$HOME/agsbx/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[
              "stop=7",
              "0=30-30",
              "1=80-280",
              "2=220-380,c,380-720",
              "3=40-80,200-600",
              "4=300-800",
              "5=200-700",
              "6=250-650"
            ],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptargo
fi
}

xrsbhy2(){
if [ -n "$hyp" ]; then
hyp=hypt
if [ -z "$port_hy2" ] && [ ! -e "$HOME/agsbx/port_hy2" ]; then
port_hy2=$(shuf -i 10000-65535 -n 1)
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
elif [ -n "$port_hy2" ]; then
echo "$port_hy2" > "$HOME/agsbx/port_hy2"
fi
port_hy2=$(cat "$HOME/agsbx/port_hy2")
echo "Hysteria2端口：$port_hy2"
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
    {
      "tag": "hy2-xr",
      "protocol": "hysteria",
      "port": ${port_hy2},
      "settings": {
        "version": 2,
        "clients": [
          {
            "auth": "${uuid}"
          }
        ]
      },
      "streamSettings": {
        "network": "hysteria",
        "security": "tls",
        "tlsSettings": {
		  "alpn": [
             "h3"
            ],
          "certificates": [
            {
              "certificateFile": "$certificateHTA",
              "keyFile": "$keyHTA"
            }
          ]
        }
      },
	   "sniffing": {
       "enabled": true,
       "destOverride": ["http", "tls", "quic"],
       "metadataOnly": false
       }
    },
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "$certificateHTA",
            "key_path": "$keyHTA"
        }
    },
EOF
fi
else
hyp=hyptargo
fi
}

xrsbso(){
if [ -n "$sop" ]; then
sop=sopt
if [ -z "$port_so" ] && [ ! -e "$HOME/agsbx/port_so" ]; then
port_so=$(shuf -i 10000-65535 -n 1)
echo "$port_so" > "$HOME/agsbx/port_so"
elif [ -n "$port_so" ]; then
echo "$port_so" > "$HOME/agsbx/port_so"
fi
port_so=$(cat "$HOME/agsbx/port_so")
echo "Socks5端口：$port_so"
if [ -e "$HOME/agsbx/xr.json" ]; then
cat >> "$HOME/agsbx/xr.json" <<EOF
        {
         "tag": "socks5-xr",
         "port": ${port_so},
         "listen": "::",
         "protocol": "socks",
         "settings": {
            "auth": "password",
             "accounts": [
               {
               "user": "${uuid}",
               "pass": "${uuid}"
               }
            ],
            "udp": true
          },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsbx/sb.json" <<EOF
    {
      "tag": "socks5-sb",
      "type": "socks",
      "listen": "::",
      "listen_port": ${port_so},
      "users": [
      {
      "username": "${uuid}",
      "password": "${uuid}"
      }
     ]
    },
EOF
fi
else
sop=soptargo
fi
}

xrsbout(){
if [ -e "$HOME/agsbx/xr.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/xr.json"
cat >> "$HOME/agsbx/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xryx}"
     }
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "direct"
      }
    ]
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/xr.service <<EOF
[Unit]
Description=xr service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/xray run -c /root/agsbx/xr.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable xr >/dev/null 2>&1
systemctl start xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/xray <<EOF
#!/sbin/openrc-run
description="xr service"
command="/root/agsbx/xray"
command_args="run -c /root/agsbx/xr.json"
command_background=yes
pidfile="/run/xray.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/xray >/dev/null 2>&1
rc-update add xray default >/dev/null 2>&1
rc-service xray start >/dev/null 2>&1
else
nohup "$HOME/agsbx/xray" run -c "$HOME/agsbx/xr.json" >/dev/null 2>&1 &
fi
fi
if [ -e "$HOME/agsbx/sb.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsbx/sb.json"
cat >> "$HOME/agsbx/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "rules": [
       {
          "action": "sniff"
        },
       {
        "action": "resolve",
         "strategy": "${sbyx}"
       }
    ],
    "final": "direct"
  }
}
EOF
if pidof systemd >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/systemd/system/sb.service <<EOF
[Unit]
Description=sb service
After=network.target
[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=/root/agsbx/sing-box run -c /root/agsbx/sb.json
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sb >/dev/null 2>&1
systemctl start sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1 && [ "$EUID" -eq 0 ]; then
cat > /etc/init.d/sing-box <<EOF
#!/sbin/openrc-run
description="sb service"
command="/root/agsbx/sing-box"
command_args="run -c /root/agsbx/sb.json"
command_background=yes
pidfile="/run/sing-box.pid"
command_background="yes"
depend() {
need net
}
EOF
chmod +x /etc/init.d/sing-box >/dev/null 2>&1
rc-update add sing-box default >/dev/null 2>&1
rc-service sing-box start >/dev/null 2>&1
else
nohup "$HOME/agsbx/sing-box" run -c "$HOME/agsbx/sb.json" >/dev/null 2>&1 &
fi
fi
}
ins(){
if [ "$anp" != yes ] && [ "$arp" != yes ]; then
installxray
xrsbhy2
xrsbso
outcfg
xrsbout
anp="anptargo"; arp="arptargo"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$xup" != yes ] && [ "$xcp" != yes ]; then
installsb
xrsbhy2
xrsbso
outcfg
xrsbout
xhp="xhptargo"; vlp="vlptargo"; xup="xuptargo"; xcp="xcptargo"
else
installsb
installxray
xrsbhy2
xrsbso
outcfg
xrsbout
fi
sleep 5
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' || pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/agsbx/d' ~/.bashrc
SCRIPT_PATH="$HOME/bin/sbx"
mkdir -p "$HOME/bin"
rm -f "$HOME/bin/agsbx"
(command -v curl >/dev/null 2>&1 && curl -sL "$sbxurl" -o "$SCRIPT_PATH") || (command -v wget >/dev/null 2>&1 && wget -qO "$SCRIPT_PATH" "$sbxurl")
chmod +x "$SCRIPT_PATH"
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行脚本的节点恢复操作，请稍等……'; sleep 6; export alns=\"${alns}\" cadn=\"${cadn}\" cfip=\"${cfip}\" hyjpt=\"${hyjpt}\" cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" uuid=\"${uuid}\" $xhp=\"${port_xh}\" $xup=\"${port_xu}\" $sop=\"${port_so}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $hyp=\"${port_hy2}\" $xcp=\"${port_xc}\" reym=\"${ym_vl_re}\"; bash "$HOME/bin/sbx"; fi" >> ~/.bashrc
fi
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
if ! pidof systemd >/dev/null 2>&1 && ! command -v rc-service >/dev/null 2>&1; then
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1 ; then
echo '@reboot sleep 10 && /bin/sh -c "nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
echo "脚本进程启动成功，安装完毕" && sleep 2
else
echo "脚本进程未启动，安装失败" && exit
fi
if [ -n "$cfip" ]; then
set -- $cfip
cdnip1="$1"
cdnip2="$2"
echo "$cdnip1" > "$HOME/agsbx/cdnip1"
echo "$cdnip2" > "$HOME/agsbx/cdnip2"
else
cdnip1="www.shopify.com"
cdnip2="www.wto.org"
echo "$cdnip1" > "$HOME/agsbx/cdnip1"
echo "$cdnip2" > "$HOME/agsbx/cdnip2"
fi
}
sbxstatus(){
echo "=========当前内核运行状态========="
procs=$(find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null)
if echo "$procs" | grep -Eq 'agsbx/s' || pgrep -f 'agsbx/s' >/dev/null 2>&1; then
echo "Sing-box (版本V$("$HOME/agsbx/sing-box" version 2>/dev/null | awk '/version/{print $NF}'))：运行中"
else
echo "Sing-box：未启用"
fi
if echo "$procs" | grep -Eq 'agsbx/x' || pgrep -f 'agsbx/x' >/dev/null 2>&1; then
echo "Xray (版本V$("$HOME/agsbx/xray" version 2>/dev/null | awk '/^Xray/{print $2}'))：运行中"
else
echo "Xray：未启用"
fi
}
cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 -k "$v46url" 2>/dev/null || curl -s6m5 -k "$v46url" 2>/dev/null) ) || (command -v wget >/dev/null 2>&1 && (timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null || timeout 3 wget -6 -qO- --tries=2 "$v46url" 2>/dev/null) ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
location="$v6dq"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
location="$v4dq"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
location="$v4dq"
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
sbxstatus
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo "服务器地区：$location"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsbx/server_ip.log"
fi
else
ipbest
fi
}
ipchange
rm -rf "$HOME/agsbx/jhsub.txt"
uuid=$(cat "$HOME/agsbx/uuid")
server_ip=$(cat "$HOME/agsbx/server_ip.log")
sxname=$(cat "$HOME/agsbx/name" 2>/dev/null)
xvvmcdnym=$(cat "$HOME/agsbx/cdnym" 2>/dev/null)
cdnip1=$(cat "$HOME/agsbx/cdnip1" 2>/dev/null)
cdnip2=$(cat "$HOME/agsbx/cdnip2" 2>/dev/null)
if grep -q 'agsbx/private.key' "$HOME/agsbx/sb.json" >/dev/null 2>&1 || grep -q 'agsbx/private.key' "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
sni=www.bing.com
add=$server_ip
jhins=1
msins=true
else
sni=$(cat /root/sbxca/ca.log 2>/dev/null)
add=$(cat /root/sbxca/ca.log 2>/dev/null)
jhins=0
msins=false
fi
echo "*********************************************************"
echo "*********************************************************"
echo "脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
ym_vl_re=$(cat "$HOME/agsbx/ym_vl_re" 2>/dev/null)
if [ -e "$HOME/agsbx/xray" ]; then
private_key_x=$(cat "$HOME/agsbx/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/agsbx/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/agsbx/xrk/short_id" 2>/dev/null)
enkey=$(cat "$HOME/agsbx/xrk/enkey" 2>/dev/null)
fi
if [ -e "$HOME/agsbx/sing-box" ]; then
private_key_s=$(cat "$HOME/agsbx/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/agsbx/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/agsbx/sbk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/agsbx/sskey" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "【 Vless-xhttp-reality-enc 】支持ENC加密，节点信息如下："
port_xh=$(cat "$HOME/agsbx/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=$enkey&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-enc-$hostname"
echo "$vl_xh_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xh_link"
echo
fi
if grep xhttp-h23 "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
port_xc=$(cat "$HOME/agsbx/port_xc")
xhttpclmh(){
clxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-TCP-$hostname
  type: vless
  server: $add
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto
EOF
}
clxcpt1(){
echo "- ${sxname}Xhttp-TCP-$hostname"
}
}
if ! grep -A 26 'xhttp-h23' "$HOME/agsbx/xr.json" | grep -q 'sbxca' >/dev/null 2>&1; then
sha=$(cat "$HOME/agsbx/SHA256.txt")
echo "【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc2_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&hpkp=$sha&pcs=$sha&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc2_link"
xhttpclmh
else
if [ "$sni" != "$(printf '%s' "$server_ip" | tr -d '[]')" ]; then
case "$port_xc" in
443|2053|2083|2087|2096|8443)
echo "【 Vless-xhttp-tls-CDN-TCP 】节点信息如下："
echo "可自行更换优选IP域名"
vl_xc2_link="vless://$uuid@$cdnip1:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-CDN-TCP-$hostname"
echo "$vl_xc2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc2_link"
echo
echo "【 Vless-xhttp-tls-CDN-UDP 】节点信息如下："
echo "可自行更换优选IP域名"
vl_xc3_link="vless://$uuid@$cdnip2:$port_xc?encryption=none&security=tls&sni=$sni&alpn=h3&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-CDN-UDP-$hostname"
echo "$vl_xc3_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc3_link"
echo
clxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-CDN-TCP-$hostname
  type: vless
  server: $cdnip1
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto

- name: ${sxname}Xhttp-CDN-UDP-$hostname
  type: vless
  server: $cdnip2
  port: $port_xc
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  alpn:
    - h3
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xc"
    mode: auto
EOF
}
clxcpt1(){
echo "- ${sxname}Xhttp-CDN-TCP-$hostname"
echo "- ${sxname}Xhttp-CDN-UDP-$hostname"
}
;;
*)
echo "【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc1_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc1_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc1_link"
xhttpclmh
;;
esac
else
echo "【 Vless-xhttp-tls-TCP 】节点信息如下："
vl_xc1_link="vless://$uuid@$add:$port_xc?encryption=none&security=tls&sni=$sni&insecure=0&allowInsecure=0&type=xhttp&path=$uuid-xc&mode=auto#${sxname}Vless-xhttp-tls-TCP-$hostname"
echo "$vl_xc1_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xc1_link"
xhttpclmh
fi
fi
echo
fi

if grep xhttp-h3 "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "【 Vless-xhttp-tls-UDP 】节点信息如下："
port_xu=$(cat "$HOME/agsbx/port_xu")
if ! grep -A 26 'xhttp-h3' "$HOME/agsbx/xr.json" | grep -q 'sbxca' >/dev/null 2>&1; then
sha=$(cat "$HOME/agsbx/SHA256.txt")
fi
vl_xu_link="vless://$uuid@$add:$port_xu?encryption=none&security=tls&sni=$sni&alpn=h3&insecure=0&allowInsecure=0&hpkp=$sha&pcs=$sha&type=xhttp&path=$uuid-xu&mode=auto#${sxname}Vless-xhttp-tls-UDP-$hostname"
echo "$vl_xu_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_xu_link"
echo
cludpxcpt(){
cat <<EOF
- name: ${sxname}Xhttp-UDP-$hostname
  type: vless
  server: $add
  port: $port_xu
  uuid: $uuid
  udp: true
  tls: true
  network: xhttp
  alpn:
    - h3
  servername: $sni
  client-fingerprint: chrome
  skip-cert-verify: $msins
  xhttp-opts:
    path: "$uuid-xu"
    mode: auto
EOF
}
cludpxcpt1(){
echo "- ${sxname}Xhttp-UDP-$hostname"
}
fi
if grep reality-vision "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "【 Vless-tcp-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/agsbx/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/agsbx/jhsub.txt"
echo "$vl_link"
echo
sbvlpt(){
cat <<EOF
    {
      "type": "vless",
      "tag": "${sxname}vless-$hostname",
      "server": "$server_ip",
      "server_port": $port_vl_re,
      "uuid": "$uuid",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_x",
          "short_id": "$short_id_x"
        }
      }
    },
EOF
}
sbvlpt1(){
echo "\"${sxname}vless-$hostname\","
}
clvlpt(){
cat <<EOF
- name: ${sxname}vless-reality-vision-$hostname               
  type: vless
  server: $server_ip                          
  port: $port_vl_re                                
  uuid: $uuid   
  network: tcp
  udp: true
  tls: true
  flow: xtls-rprx-vision
  servername: $ym_vl_re                 
  reality-opts: 
    public-key: $public_key_x    
    short-id: $short_id_x                      
  client-fingerprint: chrome
EOF
}
clvlpt1(){
echo "- ${sxname}vless-reality-vision-$hostname"
}
fi
if grep anytls-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsbx/port_an")
an_link="anytls://$uuid@$add:$port_an?sni=$sni&insecure=$jhins&allowInsecure=$jhins#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsbx/jhsub.txt"
echo "$an_link"
echo
sbanpt(){
cat <<EOF
         {
            "type": "anytls",
            "tag": "${sxname}anytls-$hostname",
            "server": "$add",
            "server_port": $port_an,
            "password": "$uuid",
            "idle_session_check_interval": "30s",
            "idle_session_timeout": "30s",
            "min_idle_session": 5,
            "tls": {
                "enabled": true,
                "insecure": $msins,
                "server_name": "$sni"
            }
         },
EOF
}
sbanpt1(){
echo "\"${sxname}anytls-$hostname\","
}
clanpt(){
cat <<EOF
- name: ${sxname}anytls-$hostname
  type: anytls
  server: $add
  port: $port_an
  password: $uuid
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  sni: $sni
  skip-cert-verify: $msins
EOF
}
clanpt1(){
echo "- ${sxname}anytls-$hostname"
}
fi
if grep anyreality-sb "$HOME/agsbx/sb.json" >/dev/null 2>&1; then
echo "【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsbx/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsbx/jhsub.txt"
echo "$ar_link"
echo
sbarpt(){
cat <<EOF
    {
        "type": "anytls",
        "tag": "${sxname}any-reality-$hostname",
        "server": "$server_ip",
        "server_port": $port_ar,
        "password": "$uuid",
        "idle_session_check_interval": "30s",
        "idle_session_timeout": "30s",
        "min_idle_session": 5,
        "tls": {
        "enabled": true,
        "server_name": "$ym_vl_re",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
      "reality": {
          "enabled": true,
          "public_key": "$public_key_s",
          "short_id": "$short_id_s"
        }
      }
         },
EOF
}
sbarpt1(){
echo "\"${sxname}any-reality-$hostname\","
}
clarpt(){
cat <<EOF
- name: ${sxname}any-reality-$hostname
  type: anytls
  server: $server_ip
  port: $port_ar
  password: $uuid
  client-fingerprint: chrome
  udp: true
  idle-session-check-interval: 30
  idle-session-timeout: 30
  sni: $ym_vl_re
  reality-opts:
    public-key: $public_key_s
    short-id: $short_id_s
EOF
}
clarpt1(){
echo "- ${sxname}any-reality-$hostname"
}
fi
if grep -q 'hy2-sb' "$HOME/agsbx/sb.json" >/dev/null 2>&1 || grep -q 'hy2-xr' "$HOME/agsbx/xr.json" >/dev/null 2>&1; then
echo "【 Hysteria2 】节点信息如下："
if { [ -f "$HOME/agsbx/sb.json" ] && grep -q 'hy2-sb' "$HOME/agsbx/sb.json" && ! grep -A 14 'hy2-sb' "$HOME/agsbx/sb.json" | grep -q 'sbxca'; } || { [ -f "$HOME/agsbx/xr.json" ] && grep -q 'hy2-xr' "$HOME/agsbx/xr.json" && ! grep -A 20 'hy2-xr' "$HOME/agsbx/xr.json" | grep -q 'sbxca'; }; then
sha=$(cat "$HOME/agsbx/SHA256.txt")
fi
port_hy2=$(cat "$HOME/agsbx/port_hy2")
hy2_ports=$(iptables -t nat -nL --line 2>/dev/null | grep -w "$port_hy2" | awk '{print $8}' | sed 's/dpts://; s/dpt://' | tr '\n' ',' | sed 's/,$//')
if [ -n "$hy2_ports" ] || [ -n "$hyjpt" ]; then
echo "Hysteria2跳跃端口已开启：$hy2_ports"
cmhy2pt=$(echo $hy2_ports | tr ':' '-')
hyps="&mport=$cmhy2pt"
sbhy2pt=$(echo "$hy2_ports" | grep -o '[0-9]\+:[0-9]\+' | sed 's/.*/"&"/' | paste -sd,)
sbhy2ports(){
    cat <<EOF
  "server_ports": [ $sbhy2pt ],
EOF
}
else
hyps=
fi
#hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&allowInsecure=1$hyps&sni=www.bing.com#${sxname}hy2-$hostname"
hy2_link="hysteria2://$uuid@$add:$port_hy2?security=tls&alpn=h3&insecure=0&allowInsecure=0$hyps&sni=$sni&pinSHA256=$sha#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsbx/jhsub.txt"
echo "$hy2_link"
echo
sbhypt(){
cat <<EOF
    {
        "type": "hysteria2",
        "tag": "${sxname}hy2-$hostname",
        "server": "$add",
        "server_port": $port_hy2,
$(sbhy2ports 2>/dev/null)
        "password": "$uuid",
        "tls": {
            "enabled": true,
            "server_name": "$sni",
            "insecure": $msins,
            "alpn": [
                "h3"
            ]
        }
    },
EOF
}
sbhypt1(){
echo "\"${sxname}hy2-$hostname\","
}
clhypt(){
cat <<EOF
- name: ${sxname}hysteria2-$hostname                            
  type: hysteria2                                      
  server: $add                              
  port: $port_hy2
  ports: $cmhy2pt
  password: $uuid                          
  alpn:
    - h3
  sni: $sni                               
  skip-cert-verify: $msins
  fast-open: true
EOF
}
clhypt1(){
echo "- ${sxname}hysteria2-$hostname"
}
fi
get_func() {
local f=$1
if type "$f" >/dev/null 2>&1; then
local out
out=$($f)
[ -n "$out" ] && printf "%s\n" "$out"
fi
}
sbxy="$(get_func sbvlpt; get_func sbanpt; get_func sbarpt; get_func sbhypt)"
clxy="$(get_func cludpxcpt; get_func clxcpt; get_func clvlpt; get_func clanpt; get_func clarpt; get_func clhypt)"
sbgz="$(get_func sbvlpt1; get_func sbanpt1; get_func sbarpt1; get_func sbhypt1)"
clgz="$({ get_func cludpxcpt1; get_func clxcpt1; get_func clvlpt1; get_func clanpt1; get_func clarpt1; get_func clhypt1; } | sed '2,$s/^/    /')"
sbgz=$(printf "%s\n" "$sbgz" | sed '$ s/,$//')
cat > $HOME/agsbx/sbox.json <<EOF
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "http_clients": [
    {
      "tag": "rule-set-direct"
    }
  ],
  "dns": {
    "servers": [
      {
        "type": "fakeip",
        "tag": "fakeip",
        "inet4_range": "198.18.0.0/15",
        "inet6_range": "fc00::/18"
      },
      {
        "type": "udp",
        "tag": "dns-cn",
        "server": "223.5.5.5",
        "server_port": 53
      },
      {
        "type": "https",
        "tag": "dns-proxy",
        "server": "dns.google",
        "domain_resolver": "dns-cn",
        "detour": "proxy"
      }
    ],
    "rules": [
      {
        "rule_set": [
          "geosite-cn"
        ],
        "action": "route",
        "server": "dns-cn"
      },
      {
        "query_type": [
          "A",
          "AAAA"
        ],
        "action": "route",
        "server": "fakeip"
      }
    ],
    "final": "dns-proxy",
    "strategy": "prefer_ipv4",
    "cache_capacity": 8192,
    "optimistic": {
      "enabled": true,
      "timeout": "1h"
    },
    "timeout": "10s",
    "reverse_mapping": true
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "address": [
        "172.19.0.1/30",
        "fdfe:dcba:9876::1/126"
      ],
      "auto_route": true,
      "strict_route": true,
      "mtu": 1420
    }
  ],
  "outbounds": [
   $sbxy
    {
      "type": "selector",
      "tag": "proxy",
      "default": "auto",
      "outbounds": [
        "auto",
        $sbgz
      ]
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
      $sbgz
      ],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "10m",
      "tolerance": 30,
      "idle_timeout": "30m"
    },
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "default_http_client": "rule-set-direct",
    "default_domain_resolver": "dns-cn",
    "auto_detect_interface": true,
    "rule_set": [
      {
        "tag": "geosite-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/cn.srs"
      },
      {
        "tag": "geoip-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs"
      }
    ],
    "rules": [
      {
        "inbound": [
          "tun-in"
        ],
        "protocol": [
          "dns"
        ],
        "action": "hijack-dns"
      },
      {
        "clash_mode": "Global",
        "action": "route",
        "outbound": "proxy"
      },
      {
        "ip_is_private": true,
        "action": "route",
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geosite-cn"
        ],
        "action": "route",
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geoip-cn"
        ],
        "action": "route",
        "outbound": "direct"
      },
      {
        "clash_mode": "Direct",
        "action": "route",
        "outbound": "direct"
      },
      {
        "network": [
          "tcp",
          "udp"
        ],
        "port": 853,
        "action": "reject"
      }
    ],
    "final": "proxy"
  },
  "experimental": {
    "cache_file": {
      "enabled": true,
      "store_dns": true
    },
    "clash_api": {
      "external_controller": "127.0.0.1:9090",
      "external_ui": "ui",
      "default_mode": "Rule"
    }
  }
}
EOF

cat > $HOME/agsbx/clmi.yaml <<EOF
port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
dns:
  enable: true 
  listen: "0.0.0.0:1053"
  ipv6: true
  prefer-h3: false
  respect-rules: true
  use-system-hosts: false
  cache-algorithm: "arc"
  enhanced-mode: "fake-ip"
  fake-ip-range: "198.18.0.1/16"
  fake-ip-filter:
    - "+.lan"
    - "+.local"
    - "+.msftconnecttest.com"
    - "+.msftncsi.com"
    - "localhost.ptlogin2.qq.com"
    - "localhost.sec.qq.com"
    - "+.in-addr.arpa"
    - "+.ip6.arpa"
    - "time.*.com"
    - "time.*.gov"
    - "pool.ntp.org"
    - "localhost.work.weixin.qq.com"
  default-nameserver: ["223.5.5.5", "119.29.29.29"]
  nameserver:
    - "https://1.1.1.1/dns-query"
    - "https://8.8.8.8/dns-query"
  proxy-server-nameserver:
    - "https://223.5.5.5/dns-query"
    - "https://doh.pub/dns-query"

proxies:
$clxy

proxy-groups:
- name: 负载均衡
  type: load-balance
  url: https://www.gstatic.com/generate_204
  interval: 300
  strategy: round-robin
  proxies:
    $clgz
- name: 自动选择
  type: url-test
  url: https://www.gstatic.com/generate_204
  interval: 300
  tolerance: 50
  proxies:
    $clgz 
- name: 🌍选择代理节点
  type: select
  proxies:
    - 负载均衡                                         
    - 自动选择
    - DIRECT
    $clgz
rules:
  - GEOIP,LAN,DIRECT
  - GEOSITE,CN,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,🌍选择代理节点
EOF
echo "---------------------------------------------------------"
echo
echo "---------------------------------------------------------"
echo "聚合节点信息，请进入 $HOME/agsbx/jhsub.txt 文件目录查看或者运行 cat $HOME/agsbx/jhsub.txt 查看"
echo "========================================================="
echo "相关快捷方式如下：(首次安装成功后需重连SSH，sbx快捷方式才可生效；如未生效，请使用主脚本)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) $(pgrep -f 'websbx' 2>/dev/null) >/dev/null 2>&1
sed -i '/agsbx/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsbx\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsbx\/xray/d' /tmp/crontab.tmp
sed -i '/agsbx\/cloudflared/d' /tmp/crontab.tmp
sed -i '/websbx/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp >/dev/null 2>&1
rm /tmp/crontab.tmp
rm -rf "$HOME/bin/sbx" "$HOME/bin/agsbx"
if pidof systemd >/dev/null 2>&1; then
for svc in xr sb argo; do
systemctl stop "$svc" >/dev/null 2>&1
systemctl disable "$svc" >/dev/null 2>&1
done
rm -rf /etc/systemd/system/{xr.service,sb.service,argo.service}
elif command -v rc-service >/dev/null 2>&1; then
for svc in sing-box xray argo; do
rc-service "$svc" stop >/dev/null 2>&1
rc-update del "$svc" default >/dev/null 2>&1
done
rm -rf /etc/init.d/{sing-box,xray,argo} /etc/local.d/alpinesbx.start /etc/local.d/alpinesubsbx.start
iptables -t nat -F PREROUTING >/dev/null 2>&1
ip6tables -t nat -F PREROUTING >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
}
xrestart(){
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart xr >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service xray restart >/dev/null 2>&1
else
nohup $HOME/agsbx/xray run -c $HOME/agsbx/xr.json >/dev/null 2>&1 &
fi
}
sbrestart(){
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
if pidof systemd >/dev/null 2>&1; then
systemctl restart sb >/dev/null 2>&1
elif command -v rc-service >/dev/null 2>&1; then
rc-service sing-box restart >/dev/null 2>&1
else
nohup $HOME/agsbx/sing-box run -c $HOME/agsbx/sb.json >/dev/null 2>&1 &
fi
}
if [ "$1" = "del" ]; then
cleandel
rm -rf sbx_update "$HOME/agsbx" "$HOME/websbx"
echo "卸载完成" && sleep 2
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsbx"/{sb.json,xr.json,sbargoym.log,sbargotoken.log,argo.log,argoport.log,cdnym,name}
echo "SBX重置协议完成，开始更新相关协议变量……" && sleep 2
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "upx" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/x"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
upxray && xrestart && echo "Xray内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "ups" ]; then
for P in /proc/[0-9]*; do [ -L "$P/exe" ] || continue; TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue; case "$TARGET" in *"/agsbx/s"*) kill "$(basename "$P")" 2>/dev/null ;; esac; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) >/dev/null 2>&1
upsingbox && sbrestart && echo "Sing-box内核更新完成" && sleep 2 && cip
exit
elif [ "$1" = "res" ]; then
for P in /proc/[0-9]*; do
[ -L "$P/exe" ] || continue
TARGET=$(readlink -f "$P/exe" 2>/dev/null) || continue
case "$TARGET" in
*"/agsbx/s"*)
kill "$(basename "$P")" 2>/dev/null
sbrestart
;;
*"/agsbx/x"*)
kill "$(basename "$P")" 2>/dev/null
xrestart
;;
esac
done
sleep 5 && echo "重启完成" && sleep 3 && cip
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsbx/(s|x)' && ! pgrep -f 'agsbx/(s|x)' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsbx/c|/agsbx/s|/agsbx/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'agsbx/s' 2>/dev/null) $(pgrep -f 'agsbx/c' 2>/dev/null) $(pgrep -f 'agsbx/x' 2>/dev/null) >/dev/null 2>&1
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url" 2>/dev/null) || (command -v wget >/dev/null 2>&1 && timeout 3 wget -4 -qO- --tries=2 "$v46url" 2>/dev/null) )" ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "脚本未安装，开始安装…………" && sleep 1
if [ -n "$oap" ]; then
setenforce 0 >/dev/null 2>&1
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
echo
echo "iptables执行开放所有端口"
fi
if [ ! -f "$HOME/agsbx/SHA256.txt" ]; then
command -v openssl >/dev/null 2>&1 && openssl ecparam -genkey -name prime256v1 -out "$HOME/agsbx/private.key" >/dev/null 2>&1
command -v openssl >/dev/null 2>&1 && openssl req -new -x509 -days 36500 -key "$HOME/agsbx/private.key" -out "$HOME/agsbx/cert.crt" -subj "/CN=www.bing.com" >/dev/null 2>&1
SHA256=$(openssl x509 -in $HOME/agsbx/cert.crt -outform DER | sha256sum | awk '{print $1}')
echo "$SHA256" > "$HOME/agsbx/SHA256.txt"
fi
if [ -n "$alns" ]; then
if ! issueca; then
echo "证书申请失败，已停止安装（未回退到自签证书）"
exit 1
fi
fi
echo
if [ -n "$alns" ] && [ -s "/root/sbxca/private.key" ]; then
certificateHTA="/root/sbxca/cert.crt"
keyHTA="/root/sbxca/private.key"
echo "HY2/Anytls/Xhttp-tls将使用IP证书或域名证书的TLS"
else
certificateHTA="$HOME/agsbx/cert.crt"
keyHTA="$HOME/agsbx/private.key"
echo "HY2/Anytls/Xhttp-tls将使用自签证书的TLS"
fi
ins
if [ -n "$hyjpt" ] && [ -n "$hyp" ]; then
echo
echo "设置Hysteria2协议的跳跃端口：$hyjpt"
iptables -t nat -F PREROUTING >/dev/null 2>&1
ip6tables -t nat -F PREROUTING >/dev/null 2>&1
hyport=$(cat "$HOME/agsbx/port_hy2")
for port in $hyjpt; do
iptables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
ip6tables -t nat -A PREROUTING -p udp --dport "$port" -j DNAT --to-destination :$hyport
done
netfilter-persistent save >/dev/null 2>&1
if command -v rc-service >/dev/null 2>&1 && command -v rc-update >/dev/null 2>&1; then
rc-update show default 2>/dev/null | grep -q 'iptables' || rc-update add iptables >/dev/null 2>&1
rc-update show default 2>/dev/null | grep -q 'ip6tables' || rc-update add ip6tables >/dev/null 2>&1
rc-service iptables save >/dev/null 2>&1
rc-service ip6tables save >/dev/null 2>&1
fi
fi
cip
echo
else
echo "脚本已安装"
echo
sbxstatus
echo
if [ "$xcp" = yes ] || [ "$xup" = yes ] || [ "$sop" = yes ] || [ "$vlp" = yes ] || [ "$hyp" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ]; then
echo "提示：命令里已带协议变量，但节点仍在运行，当前命令不会改协议。要按这条命令重装，请在末尾加 rep"
echo
fi
echo "相关快捷方式如下："
showmode
exit
fi
