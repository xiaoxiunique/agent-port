# Agent Port — 项目状态文档

> 最后更新: 2026-06-22

## 项目定位

Agent Port 是一个**本地优先（local-first）**的 agent 会话监控与控制台。

你在 tmux 里跑 Claude Code / Codex 等长任务 agent,Agent Port 让你:

- **实时查看**所有 tmux 会话/pane 的状态（running / waiting / idle / failed）
- **交互接管**任意 pane 的终端（全 ANSI 终端模拟,可直接打字）
- **远程发送**文本/控制键/图片,无需 SSH
- **多机器管理**:一部手机/电脑同时监控家里 Mac + 随身 MacBook

架构为两部分:

```
AgentMonitorService/ (Rust)        ← 轮询 tmux,提供 HTTP/WebSocket API
lib/ (Flutter)                      ← 跨平台客户端(iOS/Android/macOS/Linux/Windows/Web)
```

Rust 服务端跑在**每台被监控的 Mac**上;Flutter 客户端跑在**任意设备**上,通过 HTTP/WS 连接服务端。

---

## 技术栈

| 层 | 技术 |
|---|---|
| Rust 服务端 | Axum 0.8 + tokio + portable-pty(PTY 终端流) + serde,单文件 `main.rs` 3922 行 |
| HTTP 客户端 | dio(11 个端点,token 自动注入) |
| WebSocket | web_socket_channel(`/ws` 快照 + `/terminal/ws` 终端 + `/pane-log/ws` 日志流) |
| 状态管理 | Riverpod 2.x(非 3.x — 避免 analyzer 冲突) |
| 模型 | freezed 3.x + json_serializable(注意:类声明必须 `abstract class`) |
| 终端 | xterm 4.x(纯渲染,PTY 在服务端,客户端无需本地 PTY) |
| 持久化 | shared_preferences(`flutter_secure_storage` 与 build_runner aot 冲突,弃用) |
| 路由 | go_router |
| macOS 菜单栏 | tray_manager 0.5.x |
| iOS PiP | 原生 Swift(AVPictureInPictureController + CVPixelBuffer 渲染) |
| 图片 | image_picker |

---

## 功能对齐状态

### ✅ 已完成

| 功能 | 详情 |
|---|---|
| **实时监控列表** | WebSocket `/ws` 推送 + HTTP 轮询降级;简洁 ListTile(icon + name + 时间 + chevron),AppBar 显示 profile name + 在线绿点 |
| **交互终端** | xterm 渲染 ANSI + `/terminal/ws` 双向桥接(收 `data`→write、输入→`input`、resize→`resize`);PTY 完全在服务端 |
| **Logs/Terminal 模式** | 详情页单页切换(不是三 tab),InputBar 底部统一输入 |
| **文本发送** | `/api/send`,Codex 自动 Tab / Claude Enter 判定,vimMode 支持 |
| **控制键** | `/api/key` — Ctrl+C/D/U、Esc、Tab、Backspace、↑↓ |
| **Quick Actions** | InputBar 顶部横滚按钮行:继续/yes/no/LGTM/skip |
| **图片上传** | `image_picker` 选图 → JPEG/PNG magic bytes 检测 → `/api/upload-image` 原始字节 |
| **多服务器 profile** | 增删改 / active 切换,`apiProvider` 随 profile 动态重建,snapshotProvider 自动重连 |
| **Onboarding** | 首启:URL + token 测连 → 建 profile → 完成 |
| **CC Switch 切换** | Settings 页:provider 列表 + 一键切换(`/api/cc-switch` + `/switch`) |
| **项目历史** | Settings 页:历史项目列表 + 一键启动 Claude/Codex(`/api/project-history` + `/launch`) |
| **macOS 宿主** | `HostService`(dart:io Process 守护 Rust 子进程,2s 健康检查 + 崩溃 3s 自动重启);读 `.env`(含 `AGENT_MONITOR_PUBLIC_URLS`,否则 pane.id 空) |
| **macOS 菜单栏** | `tray_manager` 系统托盘 + 上下文菜单(控制中心/启动·停止·重启/退出) + `LSUIElement` |
| **macOS 控制中心** | 服务状态 + localhost/LAN URL + 环境检测(tmux/brew/cc/cx + 安装包装器) |
| **cc/cx 包装器** | `EnvironmentService` 生成 `~/.agent-monitor/bin/cc|cx` + `~/.zshrc` PATH marker |
| **iOS 画中画(PiP)** | 原生 Swift:日志渲染成 CVPixelBuffer 视频帧 + `AVPictureInPictureController`(需 iOS 17+) |
| **跨平台编译** | macOS / iOS / Android / Web 全部编译通过;Linux/Windows 编译待验证 |
| **Android 明文 HTTP** | `network_security_config.xml` 允许 Tailscale/LAN 的 HTTP(服务端无 TLS) |

### ❌ 未完成 / 后置

| 功能 | 原因 / 状态 |
|---|---|
| **腾讯云实时 ASR** | 原生 iOS 有(VoiceInputServices 1268 行,HMAC-SHA256 签名 + QCloud SDK);Flutter 需写原生 plugin(大工作量) |
| **Status tab / `/api/pane/events`** | Flutter 客户端调了这个端点但**服务端未注册(route 404)**;需在 Rust `main.rs` 加 route |
| **refine-text** | `/api/refine-text`(DeepSeek AI 文本优化),配合语音使用;未接入 |
| **Quick Action 可配置** | 当前硬编码默认 5 个;原生 iOS 可在 Settings 配置(`AppSettings.quickActionButtons`) |
| **Logs 实时流(`/pane-log/ws`)** | 当前用 snapshot tail;原生 iOS 用 `/pane-log/ws` + append/slide 累积逻辑(limit 800 行) |
| **系统语音输入(Apple Speech)** | 原生有;Flutter 未接 `speech_to_text` |
| **Android PiP** | 仅做了 iOS;Android PiP 用 `floating` 包(后置) |
| **Linux/Windows 编译验证** | 代码 guard OK(Platform.isMacOS),但无法在 macOS 上交叉编译验证 |

---

## 已知问题 & 潜在风险

### 🔴 高优先级

1. **Claude Code(TUI)logs 只有当前画面(~26 行)**
   - 原因:Claude Code 是 TUI,跑在 tmux alternate screen,`history_used=0`(不写 tmux scrollback)
   - 影响:logs 模式只显示终端当前画面,Claude Code 完整对话历史在 `~/.claude/projects/*.jsonl`(transcript),服务端不读
   - 根因不是服务端 bug:tmux + TUI 的固有限制;`capture-pane` 逻辑从项目初期未改
   - 可能的解决:服务端读 transcript 文件(新功能)

2. **`AGENT_MONITOR_PUBLIC_URLS` 隐式依赖**
   - 不设此环境变量时,snapshot 的 session 生成长编码名 + `pane.id` 始终为空
   - Flutter `HostService` 已读 `.env` 注入(修复),但手动启动服务时容易漏
   - 根因在 Rust `main.rs` 的 session 编码逻辑(未改动)

3. **详情页重构后 `actions_tab.dart` / `status_tab.dart` 成为死代码**
   - 不再被 `pane_detail_page.dart` import
   - 应删除或整合(messages 功能可能需要回归)

### 🟡 中优先级

4. **详情页 UI 与原生还有差异**
   - 列表已重构(简洁 ListTile),但详情页的 log/terminal + InputBar 是第一次尝试,未经与原生逐一对比
   - 原生 InputBar 有更丰富的交互(语音按钮、refine、kill pane 确认等)
   - **建议**:运行原生 iOS app 和 Flutter app 并排对比,逐项修正

5. **logs 累积逻辑缺失**
   - 原生 iOS 的 `PaneRealtimeLogContainer` 有 append/slide 累积(上限 800 行),Flutter 当前只显示 snapshot tail
   - 非常长的 agent 输出(几百行)无法在 logs 模式滚动查看全部

6. **macOS app 后台 `flutter run` 会退出**
   - 无 tty 环境下 `flutter run` 进程不保持
   - 开发时需在真实终端(非 Claude Code 会话)运行

### 🟢 低优先级

7. **`freezed 3.x` 反复踩坑**
   - 每次新建 freezed 模型必须加 `abstract class`(2.x 不需要)
   - 已在 memory 记录,但仍容易忘

8. **Riverpod 2.x(非 3.x)**
   - 因 3.x 与 json_serializable 的 analyzer 版本冲突
   - 若将来 json_serializable 更新支持 analyzer 10+,可升级

9. **`actions_tab.dart` / `status_tab.dart` 旧三 tab 代码残留**
   - 详情页已重构为单页,但这些文件仍在 repo(不被引用)
   - 建议删除

---

## Commit 历史

| Commit | 内容 |
|---|---|
| `b193f7a` | 初始:Flutter 客户端(阶段 0-5 全部代码) |
| `d106540` | 加入 Rust 服务端(AgentMonitorService) |
| `cdac118` | 重构列表 + 详情页对齐原生 UI |
| `5318caf` | Quick action 按钮 + 开发用预填 profile |

---

## Git 分支

- **`main`**(agent-port repo):当前开发分支
- **`feat/flutter-rewrite`**(agent-monitor repo):Flutter 重写的 8 个 commit 备份(在 agent-monitor 里,apps/flutter 已从 main 删除)
- **`main`**(agent-monitor repo):原项目(Rust 服务 + 原生 iOS/macOS)

---

## 与 agent-monitor 的关系

| | agent-monitor | agent-port |
|---|---|---|
| Rust 服务端 | ✅ `apps/apple/AgentMonitorService/` | ✅ `AgentMonitorService/`(复制) |
| 原生 iOS/macOS | ✅ `apps/apple/`(Swift) | ❌ |
| Flutter 客户端 | ❌(已删除) | ✅ `lib/`(活跃开发) |
| 定位 | 原项目 / 原生版备份 | **新主项目** |

两个 repo 的 Rust 服务端**代码一致**(agent-port 从 agent-monitor 复制)。后续 Rust 服务端开发以 agent-port 为主(agent-monitor 作历史保留)。

---

## 下一步建议

1. **并排对比 UI**:同时跑原生 iOS(apple/app)和 Flutter(agent-port),逐项修正详情页差异
2. **接入 `/pane-log/ws`**:让 logs 模式累积(append/slide),不是只显示 snapshot tail
3. **服务端加 `/api/pane/events` route**:让 Status 功能可用(或从详情页移除)
4. **Quick Action 可配置**:加 `AppSettings.quickActionButtons` 字段 + Settings 编辑 UI
5. **清理死代码**:删除 `actions_tab.dart` / `status_tab.dart`(或整合 messages 功能)
6. **腾讯云 ASR**:最后一个大功能(需原生 plugin + HMAC 签名)
