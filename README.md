# SBX

精简自 [argosbx](https://github.com/yonggekkk/argosbx) 的 SSH 命令生成器与安装脚本。

当前版本：V26.10.30

## 保留协议

- Xray：Vless-tcp-reality-vision、Vless-xhttp-reality-enc、Vless-xhttp-tls-UDP、Vless-xhttp-tls-TCP/UDP
- Sing-box：AnyTLS
- 自动（已选 Xray 则用 Xray，否则 Sing-box）：Hysteria2、Socks5

已去掉 Vless-ws-enc、Vless-xhttp-enc、Vmess-ws、Tuic、Naiveproxy、Any-reality、Shadowsocks-2022、订阅链接设置、Argo 隧道。

## 使用

打开 `index.html` 勾选协议后复制命令，或：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/chrimast/sbx/main/argosbx.sh)
```

常用：`list` 显示节点，`del` 卸载，`rep` 按新变量重置，`upx`/`ups` 升级内核，`res` 重启。

## 说明

Xray / Sing-box 二进制仍从上游 Release 下载。出站固定为服务器本地 IP，已去掉套 WARP-IP 出站。
