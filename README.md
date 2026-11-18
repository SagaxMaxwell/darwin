# Darwin 配置

面向 Apple Silicon 的 macOS 配置，使用 nix-darwin、Home Manager、Lix 和 Rift。

## 文件

| 文件 | 用途 |
| --- | --- |
| `flake.nix` / `flake.lock` | `MacBook` 入口、依赖锁定与共享主题参数 |
| `darwin.nix` | 系统服务、macOS 默认项与 Home Manager 接入 |
| `home.nix` | 用户软件、Shell、终端和应用开关 |
| `helix.nix` / `zed.nix` | 编辑器与语言工具 |
| `herdr.nix` | Herdr 及 Claude Code／Codex 会话钩子 |
| `rift.nix` | Rift 原生 TOML 配置与 launchd 常驻服务 |
| `homebrew.nix` | nix-homebrew 安装 Homebrew 本体，nix-darwin 声明软件清单 |

配置保持单一来源：系统设置在 `darwin.nix`，用户设置在 `home.nix` 或对应应用模块；`flake.nix` 的 `opacity = 0.8`（80% 不透明）用于 Ghostty 背景、Zed 指定主题背景和 mpv 视频外空白区域，不代表整个桌面或所有窗口的透明度。

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

# Update locked inputs, then rebuild and activate.
nix flake update

# Update apps as your user in a new terminal.
brew update
brew bundle

# Check installed apps without requiring upgrades.
brew bundle check --no-upgrade
```

首次安装 Lix 时使用官方安装器；已有 Nix/Lix 无需重复安装，之后由 `nix.package = pkgs.lix` 管理。Homebrew 由 nix-homebrew 在首次激活时安装。新增文件需先 `git add` 才会纳入 Git Flake。`nix flake check --no-build` 不能替代系统入口求值、构建和激活验证。

## 当前约定

- Home Manager 管理用户配置，nix-darwin 管理系统设置；软件来源与更新边界见下表。
- Nix 使用锁定的 Flake 输入，关闭旧 channel 机制；激活后在新终端中不再引用不存在的 root channel 路径。
- Zed、Herdr、Claude Code、Codex 保留可变配置，Nix 声明优先；删除声明字段后需手动清理用户配置中的旧值。
- macOS 菜单栏在普通桌面下不自动隐藏，由 `darwin.nix` 声明；全屏模式沿用系统默认行为。
- Herdr 通过 `herdr.nix` 接入 Claude Code 与 Codex 的 SessionStart 钩子，用于记录和恢复 Agent 会话。
- Python 使用 ty＋ruff，TOML 使用 Tombi，Nix 使用 nixd＋nixfmt。
- Obsidian 笔记库位于 `~/Documents/notes`；SSH 服务已启用，WireGuard 工具已安装但连接参数待配置。

## Rift 设置

布局、快捷键与服务统一在 `rift.nix` 声明。Home Manager 生成 `~/.config/rift/config.toml`，服务通过原生 `--config` 加载，直接打开应用也使用同一配置；无需源码补丁。表中的“默认”以 Rift 0.8.3 为基准。

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
| 持久修改并应用 | 修改 `rift.nix`，执行 `sudo darwin-rebuild switch --flake .#MacBook`；配置变化会触发 Home Manager 重启 Rift |
| 循环切换当前列宽 | `rift-cli execute layout switch-preset-column-width` |
| 打开设置窗口 | `/opt/homebrew/bin/rift-cli settings`；配置位于只读 Nix store，持久修改应在 `rift.nix` 完成 |
| 查看工作区布局 | `/opt/homebrew/bin/rift-cli query workspace-layout` |
| 手动重启服务 | 普通用户执行 `launchctl kickstart -k gui/501/git.acsandmann.rift`；本机 UID 为 501，兼容 Nushell，不加 `sudo` |

Rift 通过 Homebrew formula `acsandmann/tap/rift` 安装，常驻服务由 Home Manager 单独管理。不要运行 `rift service install`、`rift service restart` 或 `brew services start rift`，以免重写 Nix 管理的 plist 或重复启动。服务 PATH 包含 Nix 用户包、系统包和 Homebrew，使用正常进程优先级。

首次启动需在系统设置中授予辅助功能权限，并在「桌面与程序坞 → 调度中心」中开启「显示器具有单独的空间」。

## 软件来源与更新策略

Homebrew 本体由 nix-homebrew 固定在 Nix store，软件由 nix-darwin 按 Brewfile 管理；`/opt/homebrew` 保存 Cellar、Caskroom、Taps 等状态。当前机器已由 Nix 管理，新机器也无需独立安装；接管既有的手工安装时才临时启用 `autoMigrate`。

| 来源 | 软件／组件 | 理由 |
| --- | --- | --- |
| nixpkgs | Lix、Nix 工具、Git／gh、四种 Shell、终端 CLI、Herdr、Claude Code、Codex、Bun、uv、rustup、Helix、语言服务器／格式化器、WireGuard 工具 | 统一锁定依赖，适合声明式环境；编辑器引用 Nix 语言工具的绝对路径 |
| nixpkgs | mpv | 同时作为 CLI 和播放器，保留 Home Manager 的配置与脚本集成 |
| Homebrew 官方 cask | Blender、Ghostty、Google Chrome、Obsidian、SFM、Shottr、Tabularis、Zed | 使用上游 macOS 应用包，安装到 `/Applications`；Tabularis 使用上游 Apple Silicon DMG，避免维护 Nix 构建覆盖 |
| Homebrew 上游 tap | `acsandmann/tap/rift` | 上游 formula 提供应用和 CLI；避免自行维护打包，服务由 Home Manager 管理 |
| nix-homebrew | Homebrew 本体及运行环境 | 由 Nix 配置安装、由 `flake.lock` 固定源码；不使用独立安装脚本，也不把 `pkgs.brew` 当作完整的前缀安装管理器 |

Ghostty、Chrome、Obsidian、Zed 的 Home Manager 模块使用 `package = null`，只管理设置，避免双重安装。Obsidian 插件、主题、CLI 开关及 Chrome 扩展声明保留；Zed 语言工具仍来自 Nix。Ghostty cask 不链接 CLI，因此 `home.sessionPath` 包含应用自带的 `Contents/MacOS` 目录；Obsidian、Zed、Blender 的 CLI 由 cask 提供。

Homebrew 使用默认 API 安装官方软件，不把庞大的 `homebrew-core`／`homebrew-cask` 仓库加入 Flake；只保留 Rift 的第三方 tap。Apple Silicon 使用 `/opt/homebrew`，未启用额外的 Intel／Rosetta 前缀。nix-homebrew 提供 Bash／Zsh／Fish 集成；系统 PATH 补充 Homebrew 路径供 Nushell 等入口继承，不再启用第二套 shell 集成。

`homebrew.global.brewfile = true` 让手工 `brew bundle` 使用 Nix 生成的同一份清单。nix-darwin 自动为声明的软件生成 `trusted: true`，Rift 使用完整 formula 名称，因此无需重复配置信任或信任整个 tap。通过 nix-homebrew 的启动器统一关闭 analytics。

普通 `darwin-rebuild switch` 采用模块默认值：`autoUpdate = false`、`upgrade = false`、`cleanup = "none"`，只安装缺少的软件。更新时执行上面的 `brew update` 和 `brew bundle`；标记为 `auto_updates` 的 cask 通常由应用自行更新，不启用全局 greedy 升级。Homebrew 的常规缓存清理保持默认；移除声明不会自动卸载软件，可先用 `brew bundle cleanup` 查看待移除列表，再决定是否执行带 `--force` 的清理。不启用会删除应用数据的 `zap`。

`flake.lock` 固定 Nix 输入与 Homebrew 本体，不固定通过 API／可变 tap 获取的 cask 和 formula 版本；Nix 回滚也不会回滚 Homebrew 应用版本。两个来源的更新边界应分别理解。

## 补丁清单

检查范围为本仓库及本次直接涉及的上游打包实现；不是整个 nixpkgs 依赖图的补丁审计。

| 位置／来源 | 补丁或兼容处理 | 处理结果 |
| --- | --- | --- |
| nix-homebrew 上游默认 `patchBrew` | 修改 Homebrew `update.sh`，跳过本体自更新 | 保留上游默认集成，Homebrew 本体由 Nix 更新 |
| nix-homebrew 上游默认 `patchBrew` | 适配 Ruby 路径与 `fiddle` gem 加载 | 保留，使用 Nix 提供的 Ruby 运行环境 |
| nix-homebrew 上游默认 `patchBrew` | 嵌入版本号并调整 Git revision 缓存识别 | 保留，适配 Nix store 中的 Homebrew 源码 |
| nixpkgs 的 Helix 打包 | `mdbook-0.5-support.patch`，并移除旧文档主题模板 | 上游文档构建兼容处理，未在本仓库覆盖 |
| nixpkgs 的 Helix 语法包集合 | Haskell 解析器添加 `-fno-strict-aliasing`；Perl 解析器移除冲突的 `bsearch` 实现 | 上游构建／源码兼容处理，未在本仓库覆盖 |

本仓库无自行维护的源码／构建补丁。上述三项 Homebrew 处理由上游同一个 `patchBrew` 开关控制，默认开启；Ruby 适配按文件结构判断，版本处理要求包提供 `version`。Obsidian 扩展 overlay 是插件／主题包集合，Herdr 钩子直接链接上游脚本，Rift plist 是服务配置，Zed `theme_overrides` 是主题设置，均不属于源码补丁。

## 配置验证（2026-11-18）

- 格式、Flake、完整系统求值及构建检查通过；系统与 Home Manager 无模块警告、无失败断言。
- 系统和用户包清单内部无重复；共同引用的 Bash、Zsh 和补全包使用相同 store 路径，不重复存储。Brewfile 包含 8 个 cask、2 个 formula、9 个 App Store 条目。
- Homebrew Shell 初始化仅由 nix-homebrew 提供；GUI 应用的 Home Manager 模块使用 `package = null`，避免与 Homebrew 双重安装。
- 登录项统一由 Home Manager 管理：AdGuard Mini、Chrome、Ghostty、Quantumult X、Shottr；前者与 Shottr 使用 `open -g`，不抢占前台。五项均不常驻重启；另有 Rift 服务和每周 tealdeer 更新任务。
- Ghostty 使用原生配置校验；编辑器语言服务路径和 Herdr 上游钩子单独检查。未新增自定义激活脚本、轮询任务或源码补丁。

这是包含多 Shell、多编辑器和开发工具的个人工作环境，不是最小安装。`stateVersion` 是兼容基线，不随版本追新。构建验证不等于实际激活或所有应用交互测试；Homebrew 安装和权限检查发生在 `switch` 阶段。本次检查不执行 `switch`，也不更新锁定依赖。

## 激活故障排查

如果普通桌面的菜单栏仍自动隐藏，先用 `defaults read NSGlobalDomain _HIHideMenuBar` 确认值为 `0`。本机 macOS 27.3 曾在偏好已正确写入后保留旧的运行状态；以普通用户执行 `killall MenuBarAgent` 和 `killall ControlCenter`，系统自动重启这两个进程后，已实机确认恢复显示。无需修改全屏偏好，也不必把进程重启加入每次激活。

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
