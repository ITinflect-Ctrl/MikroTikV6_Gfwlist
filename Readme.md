# MikroTik RouterOS v6 GFWList DNS 转发规则生成器

🕒 自动更新计划：每日 20:10 UTC (北京时间 04:10) 自动执行更新脚本。

自动从 GFWList 提取域名并生成 MikroTik RouterOS v6 DNS 静态转发规则脚本（使用正则表达式），实现智能分流和科学上网。

## 🚀 快捷导入方式（推荐）

如果您的 MikroTik 路由器可以直接访问 GitHub，可以使用以下命令直接下载并导入脚本，**无需手动生成和上传文件**。

### 📥 直接导入 GFWList DNS 规则

```routeros
/tool/fetch url="https://raw.githubusercontent.com/Codivs-Ctrl/MikroTikV6_Gfwlist/main/gfwlist6_domain.rsc" mode=https dst-path=gfwlist6_domain.rsc
:delay 15s
/import gfwlist6_domain.rsc
```

### 🔄 自动化更新（定时任务）

创建一个 MikroTik 定时任务，每周自动更新 GFWList 规则：

```routeros
/system scheduler
add name=update-gfwlist interval=7d start-date=2026-02-10 start-time=03:00:00 \
on-event="/tool/fetch url=\"https://raw.githubusercontent.com/Codivs-Ctrl/MikroTikV6_Gfwlist/main/gfwlist6_domain.rsc\" mode=https dst-path=gfwlist6_domain.rsc\r\
\n:delay 15s\r\
\n/import gfwlist6_domain.rsc\r\
\n/log info \"GFWList rules updated successfully\""
```

### 📝 使用说明

1. **打开 Terminal**：在 MikroTik 路由器中打开 Terminal 或通过 SSH 连接
2. **复制粘贴命令**：直接复制上述命令到 Terminal 执行
3. **查看导入进度**：使用 `/log print` 查看导入日志
4. **验证导入结果**：使用 `/ip dns static print count-only where comment=Gfwlist` 查看规则数量

### ⚠️ 注意事项

- MikroTik 路由器需要能够访问 GitHub（raw.githubusercontent.com）
- 首次使用前请确保 GitHub 仓库中已有最新的 `.rsc` 文件
- 如果 GitHub 访问受限，请使用下方的手动生成方式
- 建议先在测试设备上验证后再应用到生产环境

---

## 📋 项目简介

本工具从 GFWList 项目自动提取被墙域名列表，生成适用于 MikroTik RouterOS v6 的 DNS 静态转发规则（使用正则表达式格式）。通过将特定域名转发到海外 DNS 服务器（如 Google DNS），实现智能分流和科学上网。

**主要功能**：
- ✅ 自动下载最新的 GFWList 源文件
- ✅ 自动解码 Base64 编码的 GFWList
- ✅ 智能提取二级域名（SLD），避免冗余
- ✅ 严格的域名验证，过滤无效域名
- ✅ 生成 RouterOS v6 兼容的 `.rsc` 脚本（正则表达式格式）
- ✅ 自动错误处理，避免重复导入冲突
- ✅ 使用正则表达式实现域名及子域名自动匹配
- ✅ 自动清理 DNS 缓存
- ✅ 详细的日志记录和时间戳
- ✅ **支持自定义域名列表，可指定独立 DNS 服务器**
- ✅ **支持自定义域名与 IP 映射（A记录）**

---

## 🛠️ 手动生成方式（高级用户）

如果需要自定义配置或 GitHub 访问受限，可以使用以下方式手动生成脚本。

### 系统要求

- **Python**: 3.6 或更高版本
- **依赖库**: `tldextract`
- **支持平台**: Windows、Linux、macOS

### 安装依赖

```bash
pip install tldextract
```

### 快速开始

```bash
# 1. （可选）创建自定义域名文件
echo "nas.home 192.168.1.100" > custom_domains.txt
echo "mysite.com 1.1.1.1" >> custom_domains.txt

# 2. 运行生成脚本（会自动下载最新的 GFWList）
python MikroTikV6_Gfwlist.py

# 3. 查看生成的文件
ls -l gfwlist6_domain.rsc gfwlist_sld.txt
```

**注意**：脚本运行时会自动从 GitHub 下载最新的 GFWList 源文件，无需手动下载。如果下载失败，可以手动使用以下命令：
```bash
wget -O base64.txt https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
# 或
curl -o base64.txt https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
```

### 生成的文件

脚本执行完成后，会在当前目录生成以下文件：

**主要输出**：
- `gfwlist6_domain.rsc` - MikroTik RouterOS v6 导入脚本（包含完整的 DNS 转发规则，使用正则表达式格式）
- `gfwlist_sld.txt` - 纯文本域名列表（用于检查和备份）

**可选输入**：
- `custom_domains.txt` - 自定义域名列表（支持 DNS 转发和 IP 映射）

### 导入到 MikroTik

生成文件后，通过以下任一方式导入：

**方式1 - Winbox**：
1. 打开 Winbox，连接到路由器
2. 点击 Files 菜单，拖拽上传 `gfwlist6_domain.rsc`
3. 打开 Terminal，执行：`/import gfwlist6_domain.rsc`

**方式2 - SSH/SCP**：
```bash
# 上传文件
scp gfwlist6_domain.rsc admin@192.168.88.1:

# SSH 登录并导入
ssh admin@192.168.88.1
/import gfwlist6_domain.rsc
```

**方式3 - FTP**：
使用 FTP 客户端上传到路由器，然后 Terminal 执行导入命令

---

## 📝 脚本输出示例

### DNS 静态转发规则 (gfwlist6_domain.rsc)

```routeros
### --- Created at: 2026-02-10 14:30:25 --- ###
:log info "Starting to update MikroTik v6 GFWLIST domain rules..."
/ip dns static remove [find comment=Gfwlist]
/ip dns static
# 自定义域名（优先）
:do { add regexp="(\\.|^)nas\\.home\$" comment=Gfwlist type=FWD forward-to=192.168.1.100 } on-error={}
:do { add regexp="(\\.|^)mysite\\.com\$" comment=Gfwlist type=FWD forward-to=1.1.1.1 } on-error={}
# GFWList 域名（使用正则表达式格式）
:do { add regexp="(\\.|^)google\\.com\$" comment=Gfwlist type=FWD forward-to=8.8.8.8 } on-error={}
:do { add regexp="(\\.|^)youtube\\.com\$" comment=Gfwlist type=FWD forward-to=8.8.8.8 } on-error={}
:do { add regexp="(\\.|^)facebook\\.com\$" comment=Gfwlist type=FWD forward-to=8.8.8.8 } on-error={}
:do { add regexp="(\\.|^)twitter\\.com\$" comment=Gfwlist type=FWD forward-to=8.8.8.8 } on-error={}
...（约 4000+ 条规则）
:delay 5s;
/ip dns cache flush
:log info "Completed updating GFWLIST domain rules."
```

### 域名列表文件 (gfwlist_sld.txt)

```
google.com
youtube.com
facebook.com
twitter.com
instagram.com
...
```

---

## 💡 应用场景示例

### 场景1: 智能分流（推荐）

国内域名走本地 DNS，被墙域名走海外 DNS：

```routeros
# 1. 导入 GFWList 规则（已配置转发到 8.8.8.8）
/import gfwlist6_domain.rsc

# 2. 设置路由器默认 DNS 为国内 DNS
/ip dns set servers=223.5.5.5,114.114.114.114

# 3. 允许 DNS 请求（如果作为局域网 DNS 服务器）
/ip dns set allow-remote-requests=yes
```

**工作原理**：
- GFWList 中的域名 → 转发到 8.8.8.8（海外 DNS）
- 其他域名 → 使用本地 DNS（223.5.5.5 等）
- 实现自动分流，无需客户端配置

### 场景2: 全局海外 DNS + 国内域名例外

```routeros
# 1. 设置默认 DNS 为海外
/ip dns set servers=8.8.8.8,1.1.1.1

# 2. 添加国内常用域名走本地 DNS
/ip dns static
add type=FWD forward-to=223.5.5.5 match-subdomain=yes name=baidu.com
add type=FWD forward-to=223.5.5.5 match-subdomain=yes name=qq.com
add type=FWD forward-to=223.5.5.5 match-subdomain=yes name=taobao.com
```

### 场景3: 配合透明代理使用

```routeros
# 1. 导入 GFWList DNS 规则
/import gfwlist6_domain.rsc

# 2. 标记需要走代理的流量
/ip firewall mangle
add chain=prerouting dst-address-list=!CN action=mark-routing new-routing-mark=proxy

# 3. 策略路由
/ip route
add dst-address=0.0.0.0/0 gateway=代理服务器 routing-mark=proxy
```

---

## ⚙️ 自定义配置

### 修改 DNS 转发服务器

编辑 `MikroTikV6_Gfwlist.py` 脚本第 130 行左右，修改 `forward-to` 参数：

```python
# 使用 Cloudflare DNS
rsc.write(f':do {{ add regexp="{regexp}" comment=Gfwlist type=FWD forward-to=1.1.1.1 }} on-error={{}}\n')

# 或使用多个 DNS（备用）
rsc.write(f':do {{ add regexp="{regexp}" comment=Gfwlist type=FWD forward-to=8.8.8.8,1.1.1.1 }} on-error={{}}\n')
```

**常用 DNS 服务器**：

| 服务商 | DNS 地址 | 特点 |
|--------|----------|------|
| Google DNS | 8.8.8.8 / 8.8.4.4 | 稳定快速，隐私保护较好 |
| Cloudflare DNS | 1.1.1.1 / 1.0.0.1 | 速度快，注重隐私 |
| OpenDNS | 208.67.222.222 / 208.67.220.220 | 内容过滤功能 |
| Quad9 | 9.9.9.9 | 安全防护，阻止恶意网站 |

### 修改注释标签

如需更改规则标签（便于管理多个列表）：

```python
# 将 comment=Gfwlist 改为自定义名称
rsc.write(f':do {{ add regexp="{regexp}" comment=CustomGFW type=FWD forward-to=8.8.8.8 }} on-error={{}}\n')
```

### 添加自定义域名（推荐方式）

创建 `custom_domains.txt` 文件，脚本会自动读取并优先处理：

```txt
# 自定义域名列表
# 支持两种配置方式：

# 方式1: 仅域名（使用默认DNS 8.8.8.8）
example.com
custom.domain

# 方式2: 域名 + 转发地址（指定DNS服务器或IP地址）
mysite.com 1.1.1.1
internal.local 192.168.1.100
nas.home 10.0.0.50
cdn.example.com 8.8.4.4

# 注释行以 # 开头
# 空行会被忽略
```

**配置说明**：
- **不带转发地址**：域名会使用默认 DNS 服务器（8.8.8.8）进行转发
- **带转发地址**：可以指定任意 DNS 服务器或 IP 地址进行转发
- 两种方式可以混合使用，灵活配置不同域名的转发策略

**工作原理**：
- 脚本会先读取 `custom_domains.txt`
- 自定义域名会排在 GFWList 前面（优先级更高）
- 自动去重，避免与 GFWList 冲突
- 所有域名都以 DNS 转发方式处理（type=FWD）

**使用场景**：
- 添加 GFWList 中未包含的域名
- 为特定域名指定不同的 DNS 服务器
- 将内网域名转发到局域网 DNS 服务器（如 192.168.1.1）
- 覆盖 GFWList 中的某些域名配置

---

## 📊 性能参考

| 设备型号 | RAM | 规则数量 | 导入时间 | 内存占用 | 状态 |
|---------|-----|---------|---------|---------|------|
| hEX S (RB760iGS) | 256MB | ~4000 | ~5分钟 | ~30MB | ✅ 正常 |
| RB750Gr3 | 256MB | ~4000 | ~4分钟 | ~28MB | ✅ 正常 |
| RB4011 | 1GB | ~4000 | ~2分钟 | ~25MB | ✅ 优秀 |
| CCR1009 | 2GB | ~4000 | ~1分钟 | ~25MB | ✅ 优秀 |
| hEX lite | 64MB | ~4000 | ~15分钟 | ~45MB | ⚠️ 卡顿 |

**性能建议**：
- 推荐 RAM ≥ 256MB 的设备
- 低配设备可能在导入时响应缓慢，属正常现象
- DNS 查询性能不受明显影响

---

## 🔍 域名验证规则

脚本自动过滤以下无效域名，确保生成的规则安全可靠：

**排除规则**：
- ❌ 包含特殊字符：`[ ] * ? < > " ' | \ 空格`
- ❌ 长度超过 253 字符
- ❌ 不符合域名格式（无点、以连字符开头/结尾等）
- ❌ 顶级域名少于 2 个字符
- ❌ 不包含字母的域名（如纯数字）
- ❌ 通配符域名（如 `*.example.com`）

**提取策略**：
- ✅ 自动提取二级域名（如 `www.google.com` → `google.com`）
- ✅ 使用 `match-subdomain=yes` 自动匹配所有子域名
- ✅ 避免重复和冗余规则

---

## ⚠️ 注意事项

### 导入前必读

- 📦 **备份配置**：导入前务必使用 `/export file=backup` 备份当前配置
- 🔄 **定期更新**：GFWList 每周更新，建议每月更新一次规则
- ⚙️ **测试验证**：首次使用建议先在测试设备上验证
- 💾 **系统资源**：约 4000+ 条 DNS 规则，低配设备可能响应缓慢

### 已知限制

- RouterOS v6 使用正则表达式（regexp）实现子域名匹配，语法与 v7 不同
- DNS 静态规则过多可能影响路由器启动时间
- 不支持 DNS over HTTPS (DoH) 转发

### 兼容性

| RouterOS 版本 | 兼容性 | 说明 |
|--------------|--------|------|
| v6.43+ | ✅ 完全支持 | 使用正则表达式格式 |
| v7.0+ | ⚠️ 需v7版本脚本 | match-subdomain语法不同 |
| v5.x | ❌ 不支持 | 语法不兼容 |

---

## 🐛 常见问题

### Q1: 导入时报错 "expected closing brace"

**原因**：脚本文件中存在语法错误（通常是源 GFWList 数据问题）

**解决方案**：
```bash
# 使用最新版脚本重新生成（已包含域名验证）
python MikroTikV6_Gfwlist.py

# 检查生成的文件是否有异常字符
grep -n '[\[\]*?]' gfwlist6_domain.rsc
```

### Q2: 导入后部分网站无法访问

**原因**：DNS 转发服务器无法访问或被污染

**解决方案**：
```routeros
# 1. 测试 DNS 服务器连通性
/tool/ping 8.8.8.8 count=5

# 2. 测试 DNS 解析
/tool/dns-query name=google.com server=8.8.8.8

# 3. 如果无法访问 8.8.8.8，更换为其他 DNS
# 编辑脚本，修改 forward-to 为可用的海外 DNS
```

### Q3: MikroTik 路由器无法访问 GitHub

**解决方案**：
- 使用手动生成方式，在本地电脑运行脚本
- 通过 Winbox/FTP 手动上传生成的 `.rsc` 文件
- 或使用国内 Git 镜像/CDN 加速服务

### Q4: 如何查看导入进度？

```routeros
# 查看系统日志
/log print where message~"GFWLIST"

# 查看已导入的规则数量
/ip dns static print count-only where comment=Gfwlist

# 查看具体规则
/ip dns static print where comment=Gfwlist
```

### Q5: 导入后路由器卡顿或无响应

**原因**：设备性能不足，处理大量规则时资源占用高

**临时方案**：
```routeros
# 1. 等待导入完成（可能需要 10-15 分钟）
# 2. 通过 Serial Console 连接，避免网络断开

# 长期方案：
# - 升级设备内存
# - 使用性能更好的设备
# - 或减少规则数量（修改脚本，只保留常用域名）
```

### Q6: 如何卸载/清除规则？

```routeros
# 删除所有 Gfwlist 规则
/ip dns static remove [find comment=Gfwlist]

# 清除 DNS 缓存
/ip dns cache flush

# 确认删除
/ip dns static print count-only where comment=Gfwlist
```

---

## 📚 数据来源

- **GFWList 项目**: https://github.com/gfwlist/gfwlist
- **数据格式**: Base64 编码的 Adblock Plus 规则
- **更新频率**: 社区维护，不定期更新
- **数据量**: 约 4000+ 域名（二级域名去重后）

**GFWList 是什么？**
GFWList 是一个包含被 GFW (Great Firewall) 屏蔽的网站列表的项目，由社区维护，广泛用于各类代理工具。

---

## 🔧 高级用法

### 批量管理多个列表

```routeros
# 为不同用途创建多个列表
/import gfwlist6_domain.rsc        # 标签: Gfwlist
/import custom_domains.rsc         # 标签: Custom
/import ads_block.rsc              # 标签: AdsBlock

# 独立管理
/ip dns static remove [find comment=Gfwlist]
/ip dns static remove [find comment=Custom]
```

### 日志分析

```routeros
# 查看 DNS 查询日志（需先开启）
/ip dns set cache-max-ttl=1w
/log print where topics~"dns"

# 导出日志分析最常访问的域名
```

### 与防火墙联动

```routeros
# 将 GFWList 域名解析的 IP 自动加入地址列表
/ip firewall layer7-protocol
add name=gfw-domains regexp="(google|youtube|facebook|twitter)"

/ip firewall mangle
add chain=prerouting protocol=tcp layer7-protocol=gfw-domains action=add-dst-to-address-list address-list=GFW-IPs
```

---

## 🔗 相关项目

- [GFWList 官方项目](https://github.com/gfwlist/gfwlist)
- [MikroTik RouterOS 文档](https://help.mikrotik.com/docs/)
- [RouterOS DNS 配置指南](https://help.mikrotik.com/docs/display/ROS/DNS)
- [RouterOS v6 DNS 正则表达式](https://help.mikrotik.com/docs/display/ROS/DNS)

---

## 🤝 贡献与支持

欢迎提交 Issue 和 Pull Request！

**项目维护**：
- 报告问题：提交 Issue 描述遇到的问题
- 改进建议：提交 PR 或在 Discussions 讨论
- 分享经验：Star 项目并分享给需要的人

**联系方式**：
- GitHub Issues: [提交问题](https://github.com/Codivs-Ctrl/MikroTikV6_Gfwlist/issues)
- Email: Zhihong@codivs.com

---

## ⚖️ 许可证 (License)

本项目采用 [MIT License](LICENSE) 授权。

Copyright (c) 2026 FelixBlaze

> **注意：** 本项目仅供学习和研究使用，请在法律允许的范围内使用。作者不对任何因误用、非法使用或操作不当导致的后果承担法律责任。

---

如果这个项目对您有帮助，请给个 Star ⭐！

**最后更新**: 2026年2月10日  
**脚本版本**: 2.0.0  
**测试环境**: RouterOS v6.49  
**作者**: Codivs-Ctrl
**仓库**: https://github.com/Codivs-Ctrl/MikroTikV6_Gfwlist
