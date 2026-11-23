# Darwin 配置

面向 Apple Silicon 的 macOS 配置，使用 nix-darwin、Home Manager、Lix、nix-homebrew 和 Rift。系统配置、用户配置、应用来源和服务均由 Flake 声明；`flake.lock` 固定 Nix 输入，Homebrew 应用按 Brewfile 管理。

## 设计与边界

- Home Manager 管理用户配置和用户服务，nix-darwin 管理系统设置，Homebrew 管理 macOS 应用。
- `nixpkgs` 跟踪 `nixpkgs-unstable`，实际版本由 `flake.lock` 固定；不使用旧 channel。
- macOS 使用 Homebrew cask 的原生应用包，Linux 专属的 Umbriel、Flatpak、Wayland、ROCm、XDG MIME、Ringboard、lsr、nvtop 和 `wl-clipboard-rs` 不迁移。
- 编辑器、Agent、字体和终端各保留一份配置入口，不重复安装或声明服务。
- Zed、Herdr、Claude Code、Codex、Pi 保留可变配置，Nix 声明优先；删除声明字段后需手动清理用户配置中的旧值。
- macOS 普通桌面不自动隐藏菜单栏，由 `darwin.nix` 声明；全屏沿用系统默认行为。
- `stateVersion` 是兼容基线，不随版本更新。这个仓库是完整的个人工作环境，不追求最小安装。

`~/nixos` 中已经验证适合 macOS 的内容会同步到这里：`mcat`、`ast-grep`、`fd`、`ripgrep`、`resterm`、`sendme`、`devenv`、`mvs`、Difftastic、`bottom`、Nushell 会话环境、Git 现代设置、Helix 和 Zed 的语言工具。Linux-only 的 `lsr`、Ringboard、`nvtop` 和 `wl-clipboard-rs` 不迁移。

## 文件结构

| 文件 | 内容 |
| --- | --- |
| `flake.nix` / `flake.lock` | `MacBook` 入口、输入锁定、共享主题参数 |
| `darwin.nix` | 系统服务、macOS 默认项、Home Manager 接入 |
| `home.nix` | Home Manager 入口、模块导入、基础 XDG 设置 |
| `apps/desktop.nix` | 浏览器、Tabularis、mpv、同步观影、Anime4K、登录项、Rift 接入 |
| `apps/terminal.nix` | Ghostty、Shell、终端工具 |
| `apps/development.nix` | Git、开发工具、AI 工具、Herdr/Gas City 接入 |
| `apps/herdr.nix` | Herdr 与 Claude Code、Codex、Pi 集成 |
| `apps/rift.nix` | Rift TOML 配置与 launchd 常驻服务 |
| `editor/helix.nix` / `editor/zed.nix` | 编辑器、主题、语言工具 |
| `system/homebrew.nix` | nix-homebrew、Brewfile、Homebrew PATH |
| `system/fonts.nix` / `packages/fonts.nix` | 系统字体与自定义字体包 |

`home.nix` 导入 `apps/` 和 `editor/`；`darwin.nix` 与 `flake.nix` 接入系统模块；`packages/` 只放自定义包。应用设置和服务放在对应模块，避免在入口文件重复声明。

## 安装、检查与更新

先确认 `darwin.nix` 中的用户名和主机名，再在仓库目录执行：

```sh
# 检查 Flake（不构建）
nix flake check --no-build

# 求值系统入口
nix eval --raw .#darwinConfigurations.MacBook.system.drvPath

# 构建，不激活
darwin-rebuild build --flake .#MacBook

# 构建并激活
sudo darwin-rebuild switch --flake .#MacBook

# 更新 Nix 输入，再检查和求值
nix flake update

# 更新 Homebrew 应用（新终端中执行）
brew update
brew bundle
brew bundle check --no-upgrade
```

首次安装 Lix 使用官方安装器；之后由 `nix.package = pkgs.lix` 管理。首次激活会由 nix-homebrew 安装 Homebrew；已有手工 Homebrew 时仅在接管阶段临时启用 `autoMigrate`。新增文件需先 `git add`，否则 Git Flake 不会读取。`--no-build` 不能替代系统求值、构建和激活验证。

更新顺序：修改配置 → `nixfmt` 和 `nix flake check --no-build` → 系统入口求值 → `darwin-rebuild build` → 确认无误后 `switch`。Nix 回滚不会回滚 Homebrew 应用。

## 应用来源与系统约定

| 来源 | 组件 | 规则 |
| --- | --- | --- |
| nixpkgs | Lix、Nix 工具、Git/gh、Shell、`mcat`、`ast-grep`、`fd`、`ripgrep`、`resterm`、`sendme`、`zstd`、`devenv`、Difftastic、Herdr、Claude Code、Codex、Pi、Bun、uv、rustup、Helix、语言服务器、格式化器、WireGuard、mpv、mpv 脚本、Syncplay、Anime4K | 统一锁定依赖；编辑器使用 Nix 提供的绝对路径 |
| nixpkgs-multiverse | `mvs` | 通过 Flake 输入安装，不使用已移除的 comma |
| Homebrew 官方 cask | Anytype、Blender、Ghostty、Google Chrome、SFM、Shottr、Tabularis、Zed、Delta | 使用上游 macOS 包，安装到 `/Applications` |
| Homebrew 官方 formula | Gas City（`gascity`）、`mas` | 使用上游推荐渠道及运行依赖 |
| Homebrew 上游 tap | `acsandmann/tap/rift` | 提供 Rift 应用和 CLI；服务仍由 Home Manager 管理 |
| nix-homebrew | Homebrew 本体及运行环境 | 由 Nix 安装和固定，不把 `pkgs.brew` 当作完整前缀管理器 |

Homebrew 使用默认 API，不把完整 `homebrew-core`/`homebrew-cask` 仓库加入 Flake，只保留 Rift 的第三方 tap。Apple Silicon 使用 `/opt/homebrew`，不启用 Intel/Rosetta 前缀。`/opt/homebrew` 保存 Cellar、Caskroom 和 Taps 状态。`homebrew.global.brewfile = true` 让手工 `brew bundle` 使用同一份清单；analytics 由 nix-homebrew 统一关闭。nix-homebrew 提供 Bash、Zsh、Fish 集成，系统 PATH 补充 Homebrew 路径供 Nushell 等入口继承。

nix-darwin 会为声明的软件生成 `trusted: true`；Rift 使用完整 formula 名称，不需要重复信任配置或信任整个 tap。

Homebrew 的 `onActivation` 明确设置 `autoUpdate = false`、`upgrade = false`、`cleanup = "none"`，激活不会偷偷更新、升级或删除未声明的软件。移除声明不会自动卸载，先用 `brew bundle cleanup` 查看，再按需加 `--force`；不启用会删除应用数据的 `zap`。cask 的 `auto_updates` 由应用自行处理，不启用全局 greedy。

工具替换已与 NixOS 对齐：`bat` → `mcat`，`eza` → `lsr`（Linux-only，Darwin 不安装），`xh` → `resterm`，`direnv + nix-direnv` → `devenv 2.x`，`comma` → `mvs`，OmniDiff → Difftastic。`fd` 和 `ripgrep` 仍保留，供 Yazi 等工具搜索；`zstd` 同步到两边。Linux-only 的 Ringboard、`nvtopPackages.amd`、`lsr`、Impression、Ventoy 和 `wl-clipboard-rs` 不同步。OpenGrep、LEKTRA、OmniDiff、all-smi、FluxDown 没有当前可用的 nixpkgs 包；Darwin 不部署 Papers、Loupe、Scrutiny、Noctalia、Umbriel 或 Flatpak 应用。

应用配置和运行约定：

- Ghostty、Chrome、Zed 使用 `package = null`，Home Manager 只管理配置，避免重复安装；Chrome 保留 AdGuard 扩展。
- Ghostty cask 不链接 CLI，`home.sessionPath` 补充其 `Contents/MacOS`；Zed、Blender 的 CLI 由 cask 提供。
- Ghostty、Zed 随系统外观切换：浅色使用 GitHub Dark Dimmed，深色使用 IR Black；Zed 自动安装主题扩展，Helix 使用 `base16_terminal`。
- Ghostty 和 Zed 的终端字体回退顺序为 Monaspace Neon Var → Cascadia Code NF → Maple Mono NF → Maple Mono NF CN → Recursive → Sarasa Mono SC → Sarasa Term SC；macOS Terminal Basic profile 保留系统单字体。
- Nix 安装 Amstelvar、Roboto Serif、Roboto Flex、Google Sans Flex、Inter、Monaspace、Recursive、Maple Mono、昭源字体、思源字体、Noto Color Emoji、OpenMoji 等字体。
- `opacity = 0.8` 控制 Ghostty、Zed 和 mpv 视频外空白区域的背景不透明度；Ghostty、Zed 开启模糊。这不是全局窗口透明度。
- 关闭系统“减少透明度”，保留原生玻璃效果；液态玻璃不设置数值强度。
- Python 使用 ty＋ruff，TOML 使用 Tombi，Nix 使用 nixd＋nixfmt。
- SSH 服务已启用；WireGuard 工具已安装，但连接参数待配置。
- Git 启用 `rerere`、远程分支引用自动清理（`fetch.prune`）、`zdiff3` 冲突上下文和首次推送自动设置 upstream（`push.autoSetupRemote`）；devenv 启用 Nushell 集成。bottom 的文字、边框和图表颜色设为 `reset`，跟随终端配色；Nushell 读取 Home Manager 会话变量；Claude Code 主题设为 `auto`。
- Dock 不按最近使用的空间自动重排（`mru-spaces = false`），不显示最近使用的应用（`show-recents = false`）。Nix 启用 XDG 基础目录（`use-xdg-base-directories = true`），让 Nix 的用户缓存和状态使用 XDG 路径。
- Tabularis 在激活时将 `followSystemTheme = true` 合并到 `~/Library/Application Support/tabularis/config.json`，保留数据库和其他用户设置。
- Nix 每周日 03:15 自动清理 30 天前的旧内容，04:15 运行 store 优化；两项任务分开执行。
- Flake 和 Nix daemon 追加 `nix-community.cachix.org` 及其公钥，保留官方 `cache.nixos.org`。不接入只针对 Linux 的 lantian 缓存。

## Rift

`apps/rift.nix` 是唯一配置入口。Home Manager 生成 `~/.config/rift/config.toml`，launchd 服务通过原生 `--config` 加载同一文件，直接打开应用也使用它，无需源码补丁。当前配置基于 Rift 0.8.3：

| 项目 | 当前设置 |
| --- | --- |
| 布局 | `scrolling` 横向滚动；新空间默认启用 |
| 列宽 | 默认 70%；预设 50% → 70% → 90%；最大 90%；不保留应用原有宽度 |
| 间距与边距 | 水平、垂直间距 8 px；四边屏幕外边距 0 |
| 手势 | 列滚动和工作区切换手势关闭 |
| 工作区 | 每个显示器 4 个，前两个为 `first`、`second` |
| 动画 | 开启；时长 0.3 秒，目标 100 FPS |
| 鼠标与指针 | 焦点跟随鼠标、鼠标跟随焦点、切换后隐藏指针均开启 |
| 热重载 | 开启 |
| `⌥ Enter` | 新开 Ghostty 窗口 |
| 其他快捷键 | 沿用上游绑定并显式声明 |
| 服务 | Home Manager launchd 登录启动，异常退出后重启 |

应用自身尺寸限制仍然有效。列宽预设尚未绑定快捷键：

| 操作 | 命令 |
| --- | --- |
| 持久修改 | 编辑 `apps/rift.nix`，执行 `sudo darwin-rebuild switch --flake .#MacBook` |
| 循环当前列宽 | `rift-cli execute layout switch-preset-column-width` |
| 打开设置 | `/opt/homebrew/bin/rift-cli settings` |
| 查看布局 | `/opt/homebrew/bin/rift-cli query workspace-layout` |
| 重启服务 | `launchctl kickstart -k gui/501/git.acsandmann.rift`（不要加 `sudo`） |

不要运行 `rift service install`、`rift service restart` 或 `brew services start rift`，以免覆盖 Nix 管理的 plist 或重复启动。服务 PATH 包含 Nix 用户包、系统包和 Homebrew，使用正常进程优先级。首次启动需授予辅助功能权限，并在“桌面与程序坞 → 调度中心”中开启“显示器具有单独的空间”。

## mpv

mpv 使用 nixpkgs 的脚本和工具包，设置 `hwdec = "auto"`、`vo = "gpu-next"` 和 `gpu-api = "auto"`，自动选择硬件解码与 GPU 视频输出。当前选择 `uosc + thumbfast`，所以关闭自带 OSC；脚本不自行封装。`mpris` 在当前 nixpkgs 中只支持 Linux，因此 Darwin 不安装。

| 类型 | 包 | 当前状态 |
| --- | --- | --- |
| 跳过赞助商片段 | `mpvScripts.sponsorblock-minimal` | 安装，维护 |
| 片头、回顾、片尾 | `mpvScripts.smartskip` | 安装，维护 |
| 静音跳过与加速 | `mpvScripts.skipsilence` | 安装，维护 |
| 字幕同步 | `mpvScripts.autosubsync-mpv` | 安装，维护 |
| 播放器界面与缩略图 | `mpvScripts.uosc` + `mpvScripts.thumbfast` | 安装，维护 |
| 同步观影 | `pkgs.syncplay` | 安装，维护 |
| 超分着色器 | `pkgs.anime4k` | 安装，维护 |
| 桌面媒体控制 | `mpvScripts.mpris` | 不安装，仅 Linux |
| 片头识别 | `intro-fingerprint`、`TheIntroDB/mpv-script` | 停止维护或无包 |
| 语音转写、字幕翻译、字幕下载、播放历史、手势 | — | 无包，不封装 |
| 超分预设、流媒体预加载、剪辑 | — | 无包，不封装 |
| ModernGlass、`thumbz`、`material-osc` | — | 无包，不封装 |

Anime4K 只提供着色器资源，不会自动改变解码或画质。

## Agent 与会话工具

| 工具 | 配置与使用 |
| --- | --- |
| Pi | `apps/development.nix` 启用 `programs.pi-coding-agent`，通过原生 `settings.packages` 声明 11 个 npm 插件；运行 `pi`，首次用 `/login` 登录并选择模型 |
| Herdr | `apps/herdr.nix` 接入 Claude Code、Codex、Pi 的 SessionStart 钩子和扩展；在 Herdr 窗格运行 `pi` |
| Gas City | `system/homebrew.nix` 安装 `gascity`，命令为 `gc`；Herdr 是默认会话后端 |
| Delta | Homebrew cask `zed-delta`，安装 `Delta.app` 和 `delta` CLI；与 `pkgs.delta` 不同，登录与协作空间在应用内设置 |
| Vibex | 暂不纳入；当前锁定的 nixpkgs 和官方 Homebrew 仓库没有包，上游仅提供 macOS DMG |

## 软件取舍

| 项目 | 当前选择或原因 |
| --- | --- |
| Hickory DNS | 虽有包，但接入代理 TUN/DNS 需要额外适配；macOS 继续使用系统网络栈和现有代理工具 |
| Meta oomd / MetaOOM | Linux 服务，macOS 不适用；内存管理由 macOS 负责 |
| Cassotis、Rime 万象及独立语法模型 | 没有稳定的跨平台 Nix 来源；保留当前 Fcitx/Rime 仅在 NixOS 使用 |
| Spacedrive 2.x | 当前版本和索引兼容性不足；macOS 使用 Homebrew 文件管理器或 Finder |
| Ringboard | Wayland 剪贴板服务，macOS 不适用；系统剪贴板由 macOS 管理 |
| mimalloc、LLVM libc | 不做全局 libc 或分配器替换，避免破坏应用运行时 |
| mdevd、替换 journald、替换 systemd | macOS 不使用这些 Linux 系统服务；保留 Darwin 原生 launchd 和日志机制 |
| Gas City | 通过 Homebrew 安装 `gascity`，由 Herdr 提供会话后端 |
| Vibex | 没有当前可用的 nixpkgs 或 Homebrew 包；暂不安装 |
| OpenGrep、LEKTRA、OmniDiff、all-smi、FluxDown | 当前没有可用的 nixpkgs 包；分别使用 ast-grep、Papers（仅 NixOS）、Difftastic、nvtop（仅 NixOS）；FluxDown 暂不安装 |
| Home Assistant + SMART Sniffer / Scrutiny | 两者都是 NixOS 磁盘健康监测方案；Darwin 不部署 Linux 服务 | 仅 NixOS 使用 Scrutiny + InfluxDB |

- Pi 使用用户自己的登录凭据和模型选择，密钥不写入 Nix；Herdr 扩展由 Nix 管理，不执行 `herdr integration install pi`。
- Pi 使用终端 `system` 主题；Herdr 使用 `terminal` 主题；Gas City CLI 使用宿主终端外观。透明度和模糊由 Ghostty 决定，Agent 工具本身不创建毛玻璃窗口。
- Herdr 保留 `resume_agents_on_restore = true`、`pane_history = true`；退出客户端（`Ctrl+B` 后按 `Q`）仍保留后台进程，可恢复布局、受支持 Agent 对话和屏幕历史，但不是任意进程内存。原生 Agent 恢复优先于屏幕历史重放；Nix 安装不使用 `herdr update --handoff`，版本由 Nix 管理。
- Gas City 的 `GC_SESSION=herdr`、`GC_SUPERVISOR_ENV=GC_SESSION` 由配置声明；首次使用仍需按[官方指南](https://github.com/gastownhall/gascity#get-it-running)设置 Dolt 身份并运行 `gc init`。已有 supervisor 需执行 `gc supervisor install` 同步环境；配置不会自动创建 city 或切换现有进程。
- `GC_SESSION` 优先于各 city 的 `[session].provider`，ACP Agent 仍使用独立 ACP 后端。Gas City 为每个 city 管理专用 Herdr server，提供按 rig/Agent 分组的工作区和标签页；会话事件尚未直接驱动调度器，状态通过周期检查发现，完整流程需按[集成说明](https://github.com/gastownhall/gascity/blob/v1.5.1/docs/reference/herdr-provider.md)验证。
- Delta 的设置由账号同步并保存在加密缓存中，按官方建议使用设置界面；旧 `settings.json` 仅在账号无设置时导入，不通过 Nix 写入未公开字段。目标是浅色使用 `GitHub Dark Dimmed`、深色使用 `IR Black`，但官方未提供导入 Zed 主题扩展或按系统外观配置的接口。Delta 只提供语法高亮，不运行语言服务器、诊断、补全、跳转或保存时格式化；不复制 Zed 的 `theme_overrides`、`lsp`、`languages`、`format_on_save`，需要完整编辑功能时使用 “Open in Zed”。参考：[Delta 设置](https://delta.dev/docs/configuration/settings)、[语言支持](https://delta.dev/docs/agents/language-support)、[Herdr 会话恢复](https://herdr.dev/docs/session-state/)。

Agent 工具的透明度由宿主终端决定。Ghostty 已启用 `background-opacity-cells`，有色单元格也应用 80% 背景不透明度，其他终端不保证相同效果。Vibex 和 Delta 包支持核对日期为 2026-11-19：[Vibex 安装说明](https://github.com/vibex-ai/vibex#quick-start)、[Delta cask](https://formulae.brew.sh/cask/zed-delta)；Delta 官方 Nix flake 仅支持 Linux。

## 补丁、兼容处理与验证

本仓库没有自行维护的源码或构建补丁。以下处理来自上游打包或配置兼容层：

| 位置 | 处理 |
| --- | --- |
| nix-homebrew `patchBrew` | 跳过 Homebrew 本体自更新，适配 Nix Ruby/`fiddle` 路径，嵌入版本号并修正 Git revision 缓存识别 |
| nixpkgs Pi | 从同版本 npm 包补充模型目录，整理 workspace 依赖并包装 CLI |
| nixpkgs Herdr | macOS 下将内嵌 libghostty 的 `xcrun`、`ln`、`cp`、`ranlib` 改为 PATH 查找 |
| nixpkgs Helix | 使用 `mdbook-0.5-support.patch`，移除旧文档主题模板；Haskell 解析器加 `-fno-strict-aliasing`，Perl 解析器移除冲突 `bsearch` |
| 本仓库 | Herdr 钩子链接包内上游脚本；Rift plist、Zed `theme_overrides` 属于配置，不是源码补丁 |

最近一次基线检查（2026-11-21，保留 2026-11-18 记录）：

- `nixfmt`、`git diff --check`、`nix flake check --no-build`、系统入口求值通过；完整构建曾在包含 Swift Collections 上游修复的锁定版本通过。
- Home Manager 无模块警告或失败断言；系统包和用户包无重复声明，Homebrew 为 9 个 cask、3 个 formula、9 个 App Store 条目。
- Ghostty 配置、编辑器语言服务路径、Herdr 钩子、Helix/Zed 解析出的可执行路径已检查；没有新增自定义激活脚本、轮询任务或源码补丁。
- Herdr 使用包内脚本后移除约 49 MiB 源码引用，闭包路径数从 656 降至 655；旧 generation 仍可能保留旧引用。
- 尚未完成 `switch`、视觉验证、穷举运行时冲突检查或 Agent 完整联调；构建不等于激活和交互测试。
- 生成的 Ghostty 配置通过原生校验；Helix/Zed 语言服务和 Herdr 钩子使用 Nix 解析出的可执行路径。Homebrew Shell 初始化仅由 nix-homebrew 提供，Zsh 补全由 Home Manager 初始化；GUI 配置使用 `package = null`。

Home Manager 管理的登录项为 AdGuard Mini、Chrome、Ghostty、Quantumult X、Shottr；AdGuard Mini 和 Shottr 使用 `open -g`，不抢前台，五项均不常驻重启。另有 Rift 常驻服务和每周 tealdeer 更新任务。Brewfile 当前包含 9 个 cask、3 个 formula、9 个 App Store 条目。

## 故障排查

### 激活与菜单栏

- 菜单栏仍隐藏时，执行 `defaults read NSGlobalDomain _HIHideMenuBar`，应为 `0`。若旧状态未刷新，普通用户执行 `killall MenuBarAgent` 和 `killall ControlCenter`，系统会自动重启进程。
- 若 `switch` 在 `linkGeneration` 更新 Chrome `External Extensions` 时报告 `Operation not permitted`，说明激活未完成。为实际运行命令的终端授予“隐私与安全性 → 完全磁盘访问权限”，完全退出并重新打开后再试；自带终端路径为 `/System/Applications/Utilities/Terminal.app`，Ghostty 为 `/Applications/Ghostty.app`。不要 `chmod 777` 或删除浏览器数据。
- 该问题由 TCC 拒绝终端访问 Chrome 应用数据导致，`sudo` 不能绕过授权；后续 Rift 配置和服务也不会在激活中途更新。
- 激活完成后，`~/.config/rift/config.toml` 应链接到 Nix 生成文件；`launchctl print gui/501/git.acsandmann.rift` 应包含 `--config`；`rift-cli query workspace-layout` 应显示 `scrolling`。

### Rift 配置未生效

- 若重启后回到 `traditional`，且日志出现 `Another Rift instance is already running`，检查重复登录项和配置路径。旧备份为 `~/.config/rift/config.toml.hm-backup`。
- 自动启动只交给 Home Manager；仅激活用户配置后仍需执行系统 `switch`，同步完整 generation。

### Nix GC 与迁移残留

2026-11-17 清理迁移残留约 2 GB、注销 19 条失效应用登记，并保留最近三个系统 generation。记录和启动项备份位于 `~/Library/Application Support/Darwin Cleanup/`，系统备份位于 `/var/root/Library/Application Support/Darwin Cleanup/`。

若 GC 在旧 `.app` 上报告 `chmod ... Operation not permitted`，检查“隐私与安全性 → 应用管理”权限；该权限不同于“完全磁盘访问权限”。在获授权并重新启动的终端中执行 `sudo nix-store --store local --gc`。不要直接修改或删除 Nix store 中的 `.app`，也不要移除保护属性。

应用设置、项目、笔记、开发 SDK 和现用权限不作为垃圾删除。macOS 权限数据库受保护，不能凭旧路径推断授权无用；避免全局执行 `tccutil reset All`。

## 已知限制

- Rift 0.8.3 处于 0.x 阶段，字段和 CLI 可能变化；升级后用 `rift-cli execute config reload` 查看配置错误。Rift 依赖 macOS 私有窗口 API，大版本升级后需重新确认。
- 当前锁定的 nixpkgs 可能尚未包含最新 Darwin 修复；Swift Collections 的 `install_name_tool` 问题属于上游依赖打包问题，不是 mpv 配置问题。更新锁定输入后应重新执行 Flake 检查和系统求值。
- Herdr 已启用 Kitty 图片协议，但 Agent pane 的图片显示仍取决于上游终端识别支持。
- Delta 官方 Nix flake 当前仅支持 Linux，本机使用 Homebrew；Vibex 仍未纳入。
- Homebrew 应用版本和账号同步设置不随 Nix 回滚；应用自身更新、权限和登录状态仍需在 macOS 中处理。
