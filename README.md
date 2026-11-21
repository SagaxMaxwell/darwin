# Darwin 配置

面向 Apple Silicon 的 macOS 配置，使用 nix-darwin、Home Manager、Lix 和 Rift。

## 结构

| 文件 | 用途 |
| --- | --- |
| `flake.nix` / `flake.lock` | `MacBook` 入口、依赖锁定与共享主题参数 |
| `darwin.nix` | 系统服务、macOS 默认项与 Home Manager 接入 |
| `home.nix` | Home Manager 入口、应用模块导入与基础 XDG 设置 |
| `apps/terminal.nix` | Ghostty、Shell 和终端工具 |
| `apps/development.nix` | Git、开发工具、AI 工具与 Herdr 模块接入 |
| `apps/desktop.nix` | 浏览器、播放器、登录应用与 Rift 模块接入 |
| `editor/helix.nix` / `editor/zed.nix` | 编辑器与语言工具 |
| `apps/herdr.nix` | Herdr 及 Claude Code／Codex／Pi 会话集成 |
| `apps/rift.nix` | Rift 原生 TOML 配置与 launchd 常驻服务 |
| `system/homebrew.nix` | nix-homebrew 安装 Homebrew 本体，nix-darwin 声明软件清单 |
| `system/fonts.nix` / `packages/fonts.nix` | Nix 声明系统字体与自定义字体包 |

目录沿用 `~/nixos` 的分类：`system/` 由 `darwin.nix` 和 `flake.nix` 接入；`home.nix` 导入 `apps/` 和 `editor/`；`packages/` 定义自定义包。应用设置与服务集中在对应模块，Homebrew 保留原导入顺序和 PATH 优先级。

## 与 `~/nixos` 对照

已采用适用于 macOS 的部分：`packages/fonts.nix` 使用共享的归档字体构建函数，终端启用 `bottom`，Nushell 沿用 Home Manager 26.11 的会话环境默认值，Helix 和 Zed 共用 Nix 提供的 `rust-analyzer` 与诊断辅助设置。应用仍按平台选择来源：macOS 使用 Homebrew cask，Linux 专属的 Umbriel、Flatpak、Wayland、ROCm、XDG MIME 和 `wl-clipboard` 不迁移；Delta、Anytype、Tabularis 等同类应用保留各自平台的安装方式，避免重复声明。

两边都只保留一份编辑器、Agent、字体和终端配置入口。Home Manager 管理用户设置，nix-darwin 管理系统项，Homebrew 只管理应用包；不把 Linux 服务、桌面组件或第二套包管理器带入 Darwin。

Ghostty、Zed 随系统外观切换：浅色外观使用 GitHub Dark Dimmed（仍是深色主题），深色外观使用 IR Black；Zed 自动安装对应扩展。Helix 使用 `base16_terminal` 跟随终端配色。Ghostty 与 Zed 内置终端使用 Monaspace Neon Var → Cascadia Code NF → Maple Mono NF → Maple Mono NF CN → Recursive → Sarasa Mono SC → Sarasa Term SC；macOS Terminal 的 Basic profile 仅支持单字体，保留系统当前字体。系统字体由 Nix 安装 Amstelvar、Roboto Serif、Roboto Flex、Google Sans Flex、Inter、Monaspace、Recursive、Maple Mono、昭源字体、思源字体、Noto Color Emoji、OpenMoji 等。

`flake.nix` 的 `opacity = 0.8`（80% 不透明）控制 Ghostty、Zed 指定主题的背景及 mpv 视频外空白区域；Ghostty、Zed 开启模糊。这不是全局窗口透明度，各应用效果不同。

## 使用

先确认 `darwin.nix` 中的用户名和主机名，然后在仓库目录执行：

```sh

# Check the flake.
nix flake check --no-build

# Evaluate the system derivation.
nix eval --raw .#darwinConfigurations.MacBook.system.drvPath

# Build the system.
darwin-rebuild build --flake .#MacBook

# Build and activate the system.
sudo darwin-rebuild switch --flake .#MacBook

# Update inputs, then rebuild and activate.
nix flake update

# Update apps without sudo in a new terminal.
brew update
brew bundle

# Check apps without upgrades.
brew bundle check --no-upgrade
```

首次安装 Lix 使用官方安装器，已有 Nix/Lix 无需重装；之后由 `nix.package = pkgs.lix` 管理。nix-homebrew 在首次激活时安装 Homebrew。新增文件需先 `git add` 才会纳入 Git Flake。`--no-build` 检查不能替代系统入口求值、构建和激活验证。

## 当前约定

- Home Manager 管理用户配置，nix-darwin 管理系统设置；软件来源与更新边界见后文。
- Nix 使用锁定的 Flake 输入，关闭旧 channel 机制；激活后在新终端中不再引用不存在的 root channel 路径。
- `nixpkgs` 跟踪 `nixpkgs-unstable`，实际版本由 `flake.lock` 固定；更新全部输入使用 `nix flake update`，更新后先运行 Flake 检查和系统求值。
- Zed、Herdr、Claude Code、Codex、Pi 保留可变配置，Nix 声明优先；删除声明字段后需手动清理用户配置中的旧值。
- macOS 菜单栏在普通桌面下不自动隐藏，由 `darwin.nix` 声明；全屏模式沿用系统默认行为。
- 关闭系统“减少透明度”，保留原生玻璃效果；液态玻璃不设数值强度。
- Herdr 通过 `apps/herdr.nix` 接入 Claude Code／Codex 的 SessionStart 钩子及 Pi 扩展，直接链接包内上游文件，记录和恢复 Agent 会话。
- Python 使用 ty＋ruff，TOML 使用 Tombi，Nix 使用 nixd＋nixfmt。
- 终端工具由 Home Manager 管理，包含 `bottom`、`nix-tree`、`nix-output-monitor`、`xh` 和 WireGuard CLI；Nushell 使用 Home Manager 的会话环境。
- 笔记使用 Anytype；现行规范位于 Anytype「知识星图」中的“Anytype 笔记规范”，旧的 Obsidian 仓库不属于 Darwin 配置。SSH 服务已启用，WireGuard 工具已安装但连接参数待配置。

## Rift 设置

`apps/rift.nix` 统一声明布局、快捷键与服务。Home Manager 生成 `~/.config/rift/config.toml`，服务通过原生 `--config` 加载，直接打开应用也读取同一配置，无需源码补丁。下表默认值以 Rift 0.8.3 为准。

| 设置 | 当前值／行为 | 与默认的关系 |
| --- | --- | --- |
| 窗口管理 | 新空间默认启用 | 自定义 |
| 布局 | `scrolling` 横向滚动 | 自定义，默认是 `traditional` |
| 默认列宽 | 可用宽度的 70% | 沿用默认，显式声明 |
| 预设列宽 | 50% → 70% → 90% | 自定义 |
| 最大列宽 | 90% | 沿用默认，显式声明 |
| 保留应用原有窗口宽度 | 关闭，新列使用默认列宽 | 自定义 |
| 窗口间距 | 水平、垂直均为 8 px | 自定义，默认是 0 |
| 屏幕外边距 | 四边均为 0 | 沿用默认 |
| 列滚动／工作区切换手势 | 均关闭 | 沿用默认 |
| 工作区 | 每个显示器 4 个，前两个名为 `first`、`second` | 沿用上游默认 |
| 动画 | 开启，时长 0.3 秒，帧率目标 100 | 开启为自定义；时长、帧率沿用默认 |
| 焦点跟随鼠标／鼠标跟随焦点／切换后隐藏指针 | 均开启 | 沿用上游默认 |
| 配置热重载 | 开启 | 沿用上游默认 |
| `⌥ Enter` | 新开 Ghostty 窗口 | 自定义，默认打开 macOS 自带终端 |
| 其余快捷键 | 沿用上游绑定 | 默认绑定，显式声明 |
| 自动启动 | Home Manager launchd agent 在图形登录后启动，崩溃或异常退出后重启 | Nix 管理 |

应用自身的尺寸限制仍然有效。列宽预设切换尚未绑定快捷键，可使用下表命令。

| 操作 | 命令／方式 |
| --- | --- |
| 持久修改并应用 | 修改 `apps/rift.nix`，执行 `sudo darwin-rebuild switch --flake .#MacBook`；配置变化会触发 Home Manager 重启 Rift |
| 循环切换当前列宽 | `rift-cli execute layout switch-preset-column-width` |
| 打开设置窗口 | `/opt/homebrew/bin/rift-cli settings`；配置位于只读 Nix store，持久修改应在 `apps/rift.nix` 完成 |
| 查看工作区布局 | `/opt/homebrew/bin/rift-cli query workspace-layout` |
| 手动重启服务 | 普通用户执行 `launchctl kickstart -k gui/501/git.acsandmann.rift`；本机 UID 为 501，兼容 Nushell，不加 `sudo` |

Rift 通过 Homebrew formula `acsandmann/tap/rift` 安装，常驻服务由 Home Manager 单独管理。不要运行 `rift service install`、`rift service restart` 或 `brew services start rift`，以免重写 Nix 管理的 plist 或重复启动。服务 PATH 包含 Nix 用户包、系统包和 Homebrew，使用正常进程优先级。

首次启动需在系统设置中授予辅助功能权限，并在「桌面与程序坞 → 调度中心」中开启「显示器具有单独的空间」。

## 软件来源与更新策略

nix-homebrew 将 Homebrew 本体固定在 Nix store，nix-darwin 按 Brewfile 管理软件；`/opt/homebrew` 保存 Cellar、Caskroom、Taps 等状态。本机已由 Nix 管理，新机器无需独立安装；仅接管手工安装时临时启用 `autoMigrate`。

| 来源 | 软件／组件 | 理由 |
| --- | --- | --- |
| nixpkgs | Lix、Nix 工具、Git／gh、四种 Shell、终端 CLI、Herdr、Claude Code、Codex、Pi、Bun、uv、rustup、Helix、语言服务器／格式化器、WireGuard 工具 | 统一锁定依赖，适合声明式环境；编辑器引用 Nix 语言工具的绝对路径 |
| nixpkgs | mpv | 同时作为 CLI 和播放器，保留 Home Manager 的配置与脚本集成 |
| Homebrew 官方 cask | Anytype、Blender、Ghostty、Google Chrome、SFM、Shottr、Tabularis、Zed、Delta | 使用上游 macOS 应用包，安装到 `/Applications`；Tabularis 使用上游 Apple Silicon DMG，避免维护 Nix 构建覆盖 |
| Homebrew 官方 formula | Gas City（`gascity`）、`mas` | Gas City 使用上游推荐渠道并自动提供运行依赖；`mas` 管理 Mac App Store 声明 |
| Homebrew 上游 tap | `acsandmann/tap/rift` | 上游 formula 提供应用和 CLI；避免自行维护打包，服务由 Home Manager 管理 |
| nix-homebrew | Homebrew 本体及运行环境 | 由 Nix 配置安装、由 `flake.lock` 固定源码；不使用独立安装脚本，也不把 `pkgs.brew` 当作完整的前缀安装管理器 |

Ghostty、Chrome、Zed 使用 `package = null`，Home Manager 只管理配置，避免双重安装；保留 Chrome 扩展。Zed 语言工具来自 Nix。Ghostty cask 不链接 CLI，故 `home.sessionPath` 添加应用的 `Contents/MacOS`；Zed、Blender 的 CLI 由 cask 提供。

Homebrew 使用默认 API 安装官方软件，不把庞大的 `homebrew-core`／`homebrew-cask` 仓库加入 Flake；只保留 Rift 的第三方 tap。Apple Silicon 使用 `/opt/homebrew`，未启用额外的 Intel／Rosetta 前缀。nix-homebrew 提供 Bash／Zsh／Fish 集成；系统 PATH 补充 Homebrew 路径供 Nushell 等入口继承，不再启用第二套 shell 集成。

`homebrew.global.brewfile = true` 让手工 `brew bundle` 使用 Nix 生成的同一份清单。nix-darwin 自动为声明的软件生成 `trusted: true`，Rift 使用完整 formula 名称，因此无需重复配置信任或信任整个 tap。通过 nix-homebrew 的启动器统一关闭 analytics。

`darwin-rebuild switch` 沿用 `autoUpdate = false`、`upgrade = false`、`cleanup = "none"`，只安装缺少的软件。更新执行 `brew update`、`brew bundle`；`auto_updates` cask 通常由应用自行更新，不启用全局 greedy。缓存清理沿用默认；移除声明不会自动卸载，先用 `brew bundle cleanup` 查看清单，按需加 `--force` 执行。不启用会删除应用数据的 `zap`。

`flake.lock` 固定 Nix 输入与 Homebrew 本体，不固定 API／可变 tap 获取的 cask 和 formula 版本；Nix 回滚不会回滚 Homebrew 应用。

## Agent 工具

| 工具 | 声明与使用 |
| --- | --- |
| Pi | `apps/development.nix` 启用 `programs.pi-coding-agent`；运行 `pi`，首次通过 `/login` 登录，再选择模型 |
| Herdr | 保留现有配置；在 Herdr 窗格中运行 `pi`，官方扩展自动上报状态与会话路径，在普通终端中不启用上报 |
| Gas City | `system/homebrew.nix` 安装 `gascity`，命令为 `gc`；安装并声明 Herdr 后端，项目、city 和后台服务按实际工作初始化 |
| Delta（Zed 团队） | Homebrew cask `zed-delta`，安装 `Delta.app` 和 `delta` CLI；与 Git diff 工具 `pkgs.delta` 不同，登录与协作空间在应用内设置 |
| Vibex | 暂不纳入：当前锁定的 nixpkgs 和 Homebrew 官方仓库未找到包，上游提供 macOS DMG；不自行打包，后续可重新检查 |

Pi 使用用户自己的登录凭据与模型选择，不在 Nix 中写入密钥。Herdr 扩展由 Nix 管理，无需再执行 `herdr integration install pi`。

### 外观与会话

| 工具 | 外观 | 会话保存与恢复 |
| --- | --- | --- |
| Pi | 原生 `system` 主题跟随终端；在 Ghostty 中使用现有 80% 不透明度和模糊 | 默认保存会话；官方 Herdr 扩展上报状态与路径，Herdr 重启后可用 `pi --session` 恢复 |
| Herdr | `terminal` 主题跟随 Ghostty，主要面板使用终端默认背景；没有独立的透明度或模糊数值 | 自动保存布局；保留 `resume_agents_on_restore = true` 和 `pane_history = true`，覆盖已接入的 Pi／Claude Code／Codex |
| Gas City | CLI 使用宿主终端外观；Dashboard 未找到原生窗口透明／模糊设置，跳过 | 通过 `GC_SESSION=herdr` 选择官方 Herdr 后端；`GC_SUPERVISOR_ENV=GC_SESSION` 让上游安装 supervisor 时保留该选择 |
| Delta | 官方设置未列出透明／模糊接口，跳过 | 自有线程持久化与默认跨设备同步；未找到官方 Herdr 集成，不添加恢复钩子 |
| Vibex | 暂未纳入安装，跳过 | 暂不配置 |

80% 指背景不透明度，文字不随之降低透明度。Pi／Herdr 本身不创建带毛玻璃的 macOS 窗口，实际效果由宿主终端决定；Ghostty 已启用 `background-opacity-cells`，有色单元格也应用背景不透明度。其他终端不保证相同效果。

Herdr 退出客户端（`Ctrl+B` 后按 `Q`）仍保留后台进程；服务器重启后恢复的是布局、受支持 Agent 的对话，或保存的屏幕历史，不是任意进程的内存状态。原生 Agent 恢复优先于屏幕历史重放。Nix 安装不使用 `herdr update --handoff`；版本更新由 Nix 管理。

Gas City 的环境变量由 `apps/development.nix` 声明，激活后需新登录环境。首次使用按[官方指南](https://github.com/gastownhall/gascity#get-it-running)设置 Dolt 身份并初始化 city；`gc init` 会启动后台 supervisor，本配置不自动创建 city 或启动 Agent。已经安装的 supervisor 需在新环境执行 `gc supervisor install` 同步环境；现有进程不会因 Nix 声明自动切换后端。

`GC_SESSION` 优先于各 city 的 `[session].provider`，当前默认全部使用 Herdr；ACP Agent 仍走独立 ACP 后端。Gas City 管理每个 city 的专用 Herdr server，提供按 rig／Agent 分组的工作区与标签页。会话事件尚未直接驱动其调度器，状态仍通过周期检查发现；上游记录了版本兼容限制，首次使用需验证完整工作流程，参见[集成说明](https://github.com/gastownhall/gascity/blob/v1.5.1/docs/reference/herdr-provider.md)。这些配置不等于已经完成 Agent 联调。

Delta 新版设置由账号同步并保存在加密缓存中，官方建议使用设置界面；旧 `settings.json` 只在账号无设置时导入，不通过 Nix 写入该缓存或添加未经支持的字段。参见 [Delta 设置](https://delta.dev/docs/configuration/settings)、[Herdr 会话恢复](https://herdr.dev/docs/session-state/)。

Delta 对齐 Zed 的目标是浅色外观使用 `GitHub Dark Dimmed`、深色外观使用 `IR Black`。目前官方只说明应用内外观与深色主题选择，未找到导入这两个 Zed 主题扩展或按系统外观分别配置它们的接口，因此尚未应用。语言扩展会按需自动下载，但[目前仅用于语法高亮](https://delta.dev/docs/agents/language-support)，不运行语言服务器，不提供诊断、补全或跳转；也未找到保存时格式化接口。暂不复制 Zed 的 `theme_overrides`、`lsp`、`languages` 或 `format_on_save` 字段；需要完整编辑功能时可使用 Delta 文件菜单的 `Open in Zed`，沿用现有配置。

包支持核对于 2026-11-19：[Vibex 安装说明](https://github.com/vibex-ai/vibex#quick-start)、[Delta cask](https://formulae.brew.sh/cask/zed-delta)。Delta 官方 Nix flake 当前仅支持 Linux，本机使用 Homebrew。

## 补丁清单

范围限于本仓库与直接检查的上游打包实现，不涵盖整个 nixpkgs 依赖图。

| 位置／来源 | 补丁或兼容处理 | 处理结果 |
| --- | --- | --- |
| nix-homebrew 上游默认 `patchBrew` | 修改 Homebrew `update.sh`，跳过本体自更新 | 保留上游默认集成，Homebrew 本体由 Nix 更新 |
| nix-homebrew 上游默认 `patchBrew` | 适配 Ruby 路径与 `fiddle` gem 加载 | 保留，使用 Nix 提供的 Ruby 运行环境 |
| nix-homebrew 上游默认 `patchBrew` | 嵌入版本号并调整 Git revision 缓存识别 | 保留，适配 Nix store 中的 Homebrew 源码 |
| nixpkgs 的 Pi 打包 | 从同版本 npm 发布包补充模型目录，整理 workspace 依赖并包装 CLI | 上游离线构建与安装处理，本仓库无额外补丁 |
| nixpkgs 的 Herdr 打包 | macOS 下将内嵌 libghostty 的 `xcrun`、`ln`、`cp`、`ranlib` 绝对路径改为 PATH 查找 | 上游构建适配，本仓库无额外补丁 |
| nixpkgs 的 Helix 打包 | `mdbook-0.5-support.patch`，并移除旧文档主题模板 | 上游文档构建兼容处理，未在本仓库覆盖 |
| nixpkgs 的 Helix 语法包集合 | Haskell 解析器添加 `-fno-strict-aliasing`；Perl 解析器移除冲突的 `bsearch` 实现 | 上游构建／源码兼容处理，未在本仓库覆盖 |

本仓库无自行维护的源码／构建补丁。上述三项 Homebrew 处理由上游同一个 `patchBrew` 开关控制，默认开启；Ruby 适配按文件结构判断，版本处理要求包提供 `version`。Herdr 钩子链接安装包内的上游脚本，Rift plist 是服务配置，Zed `theme_overrides` 是主题设置，均不属于源码补丁。

## 配置验证（2026-11-21；保留 2026-11-18 基线）

2026-11-21 增补：字体清单同步到 Darwin，加入 Inter、Honk 与昭源黑体 VF；Ghostty 与 Zed 已声明完整等宽回退顺序；macOS Terminal 的 Home Manager 原生模块不支持其 NSKeyedArchiver 字体字段，因此未写入无效 plist 值。Pi 原生模块与 Herdr 扩展已加入，Gas City／Delta 已写入 Brewfile；`nixfmt`、`nix flake check --no-build` 和完整系统构建曾在包含上游修复的临时锁定版本上通过，Home Manager 无模块警告。笔记应用改用 Anytype，移除 Obsidian 及扩展依赖；当前 Brewfile 为 9 个 cask、3 个 formula、9 个 App Store 条目。随后启用 Pi／Herdr 终端配色及 Gas City 原生 Herdr 后端，完整构建和 Herdr 原生 `config check` 均通过。当前 `flake.nix` 仍跟踪 `nixpkgs-unstable`；Swift Collections 的 Darwin 修复已在上游合并，但尚未进入此锁定分支，本次新增配置已通过 Flake 检查和系统求值，未执行 `switch`、视觉验证或 Agent 联调，以下保留此前验证基线。

| 检查 | 结果 |
| --- | --- |
| 格式与求值 | nixfmt、Flake、系统入口求值通过；完整构建曾在包含上游 Swift 修复的锁定版本通过；系统与 Home Manager 无模块警告、无失败断言 |
| 安装来源 | 系统包与用户包声明无重复；Bash、Zsh 和补全包共享 store 路径；Brewfile 为 9 个 cask、3 个 formula、9 个 App Store 条目 |
| 初始化与服务 | Homebrew Shell 初始化仅由 nix-homebrew 提供，Zsh 补全由 Home Manager 初始化；GUI 配置用 `package = null`；Homebrew 无启用的服务，与 Rift 的 Home Manager 服务不重复 |
| 运行闭包 | Herdr 钩子改用包内相同脚本，移除约 49 MiB 源码引用；闭包路径数从 656 降至 655，旧代仍保留原引用 |
| 应用配置 | 生成的 Ghostty 配置通过原生校验；编辑器语言服务路径与 Herdr 钩子已检查，Helix 和 Zed 使用 Nix 解析出的可执行路径 |
| 注释与补丁 | 简短英文注释，上方空行、无同行注释；未新增自定义激活脚本、轮询任务或源码补丁 |

登录项由 Home Manager 管理：AdGuard Mini、Chrome、Ghostty、Quantumult X、Shottr；AdGuard Mini 与 Shottr 用 `open -g`，不抢前台。五项均不常驻重启；另有 Rift 常驻服务和每周 tealdeer 更新任务。

目录整理保留系统和用户软件集合、Brewfile、launchd 服务、应用设置及 Homebrew PATH 优先级；包列表顺序变化使部分生成路径改变。

这是包含多 Shell、编辑器和开发工具的个人环境，不是最小安装。`stateVersion` 是兼容基线，不随版本更新。构建不等于激活或交互测试；Homebrew 安装与权限检查在 `switch` 阶段进行。本次未执行 `switch` 或穷举运行时冲突；已检查包、服务和配置入口，没有发现重复安装、服务冲突、失败断言或模块警告。

## 激活故障排查

普通桌面菜单栏仍隐藏时，用 `defaults read NSGlobalDomain _HIHideMenuBar` 确认值为 `0`。本机 macOS 27.3 曾保留旧运行状态；普通用户执行 `killall MenuBarAgent`、`killall ControlCenter` 后，系统自动重启进程，已实机恢复。无需修改全屏偏好或在每次激活时重启进程。

如果 `switch` 在 `linkGeneration` 阶段更新 Chrome 的 `External Extensions` 时报告 `Operation not permitted`，本次 Home Manager 激活没有完成，后面的 Rift 配置和服务也不会更新。2026-11-17 的系统 TCC 日志已确认：自带终端 `com.apple.Terminal` 对 Chrome 应用数据的访问被拒绝，`sudo` 不能绕过该授权。为实际运行命令的终端开启「隐私与安全性 → 完全磁盘访问权限」，完全退出并重新打开该终端，再执行 `switch`。自带终端路径是 `/System/Applications/Utilities/Terminal.app`；Homebrew 版 Ghostty 路径是 `/Applications/Ghostty.app`。不要用 `chmod 777` 或删除浏览器数据处理这类访问拒绝。

成功后，`~/.config/rift/config.toml` 应链接到 Nix 生成的配置，`launchctl print gui/501/git.acsandmann.rift` 应包含 `--config`，`/opt/homebrew/bin/rift-cli query workspace-layout` 应显示 `scrolling`。只完成构建或 Homebrew 安装不代表系统激活已完成。

若重启后恢复为 `traditional`，且日志出现 `Another Rift instance is already running`，检查重复登录项和读取的配置路径。此前问题由 Rift.app 抢先读取旧配置造成；现在所有入口使用标准 `config.toml`，旧备份位于 `~/.config/rift/config.toml.hm-backup`。自动启动只交给 Home Manager；单独激活用户配置后，仍需执行系统 `switch` 同步 generation。

## 迁移残留清理

2026-11-17 清理迁移残留约 2 GB、注销 19 条失效应用登记，并保留最近三个系统 generation。记录和失效启动项备份位于 `~/Library/Application Support/Darwin Cleanup/`，系统文件备份位于 `/var/root/Library/Application Support/Darwin Cleanup/`。旧 generation 保留旧包供回滚，按需通过 Nix GC 回收。

若 Nix GC 在旧 `.app` 上报告 `chmod ... Operation not permitted`，应检查 macOS「隐私与安全性 → 应用管理」权限。2026-11-17 的日志记录了 `SystemPolicyAppBundles` 拒绝 Nix 后台进程访问。可在获授权并重新启动的终端中执行 `sudo nix-store --store local --gc`。此权限与「完全磁盘访问权限」不同。不要直接修改或删除 Nix store 中的 `.app`，也不要移除其保护属性。

应用设置、项目、笔记、开发 SDK 和现用权限不作为垃圾删除。权限数据库受 macOS 保护，不能仅凭旧路径推断整个应用授权无用；避免全局执行 `tccutil reset All`。

## 已知限制

- Rift 0.8.3 为 0.x 阶段，配置字段与 CLI 可能变化；升级后如配置不再生效，用 `rift-cli execute config reload` 查看具体报错。
- Rift 依赖 macOS 私有窗口 API，系统大版本更新后建议先确认它是否仍正常工作。
- Herdr 已启用 Kitty 图片协议，但 Agent pane 中的图片显示仍需上游终端识别支持。
