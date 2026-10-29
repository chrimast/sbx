# SBX

精简自 [argosbx](https://github.com/yonggekkk/argosbx) 的 SSH 命令生成器与安装脚本。

当前版本：V26.10.30

## 仓库文件

- `sbx.sh`：主安装脚本（本机 SSH 一键安装 / 更新 / 导出节点）
- `index.html`：命令生成页
- `container/nodejs/start.sh`：Node.js 容器版安装脚本（与主脚本协议集一致，独立入口，不由 `sbx.sh` 远程拉取）
- `container/nodejs/index.js`、`container/nodejs/package.json`：容器探测页
- `LICENSE`：GPLv3

仓库里没有其它 `.sh`。运行时也不会再下载任何外部 shell 脚本。

## 使用

命令生成页：[https://chrimast.github.io/sbx/](https://chrimast.github.io/sbx/)（GitHub Pages 直接跑仓库根目录的 `index.html`）。本地也可打开 `index.html`。勾选协议后复制命令，或：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/chrimast/sbx/main/sbx.sh)
```

安装后可用快捷命令（需重连 SSH 或 `export PATH="$HOME/bin:$PATH"`）：

```bash
sbx list    # 显示节点
sbx del     # 卸载
sbx rep     # 按当前环境变量重置
sbx upx     # 升级 Xray
sbx ups     # 升级 Sing-box
sbx res     # 重启
```

## 保留协议

- Xray：Vless-tcp-reality-vision、Vless-xhttp-reality-enc、Vless-xhttp-tls-UDP、Vless-xhttp-tls-TCP/UDP
- Sing-box：AnyTLS、Any-reality
- 自动（已选 Xray 则用 Xray，否则 Sing-box）：Hysteria2、Socks5

已去掉 Vless-ws-enc、Vless-xhttp-enc、Vmess-ws、Tuic、Naiveproxy、Shadowsocks-2022、订阅链接设置、Argo 隧道、套 WARP-IP 出站。

## 外部 / 上游文件（非 sh）

安装和 `sbx upx` / `sbx ups` 都从官方 latest 下载内核，**不进本仓库**：

- Xray：[XTLS/Xray-core](https://github.com/XTLS/Xray-core/releases/latest)
  `https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip`（arm64 为 `Xray-linux-arm64-v8a.zip`）
- Sing-box：[SagerNet/sing-box](https://github.com/SagerNet/sing-box/releases/latest)
  `https://github.com/SagerNet/sing-box/releases/download/<最新tag>/sing-box-<版本>-linux-<amd64|arm64>.tar.gz`

Clash 规则集（仅导出配置引用，运行时由客户端拉取）：

- `https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/cn.srs`
- `https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs`

探测与 DNS（不是脚本、不是内核）：

- 出口 IP：`https://icanhazip.com`
- 地区：`https://ip.fm`
- 连通性：`https://www.gstatic.com/generate_204`
- DoH：`1.1.1.1`、`8.8.8.8`、`223.5.5.5`、`doh.pub`
