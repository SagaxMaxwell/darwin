# Darwin 配置

Apple Silicon；macOS、nix-darwin + Home Manager、Lix、OmniWM + Lake。

`flake.nix` 是入口（`MacBook`）：`darwin.nix` 系统，`home.nix` 用户应用，`modules/omniwm/` 窗口布局与桌面样式。

## 约定

用户级应用、工具和 dotfiles 由 Home Manager 管理，优先 `programs.<name>.enable`，其次 `home.packages`；系统服务、macOS 默认项与字体由 nix-darwin 管理。Home Manager 随 `darwin-rebuild` 生效；冲突文件备份为 `*.hm-backup`，只保留最近一份。

Zed、Herdr 保留可变配置，Nix 声明优先；删除 Nix 字段后用户文件中的旧值需手动清理。OmniWM 的界面修改需同步回仓库，下次应用以仓库为准。

## 部署

先核对 `darwin.nix` 中的用户名与主机名。仅尚无 Nix/Lix 时安装 Lix，之后重新打开终端；安装器自动准备 `/nix`，无需手动挂载。以下命令均在仓库目录执行；新增文件不必提交即可构建，无缓存的软件可能本地编译。

| 用途 | 命令 |
| --- | --- |
| 安装 Lix（已有则跳过） | `curl -sSf -L https://install.lix.systems/lix \| sh -s -- install` |
| 首次构建 | `nix build .#darwinConfigurations.MacBook.system` |
| 首次应用 | `sudo ./result/sw/bin/darwin-rebuild switch --flake .#MacBook` |
| 应用配置 | `sudo darwin-rebuild switch --flake .#MacBook` |
| 更新依赖 | `nix flake update` |
| 将新增配置文件纳入 flake | `git add 文件路径` |
| 检查 flake，不编译 | `nix flake check --no-build` |
| 查看构建计划，不编译 | `nix build --dry-run --no-link .#darwinConfigurations.MacBook.system` |
| 完整构建，不应用 | `nix build --no-link .#darwinConfigurations.MacBook.system` |
| 回到上一代配置 | `sudo darwin-rebuild switch --rollback` |

回滚不修改仓库文件，也不回退 macOS 版本。

## 桌面

- macOS 自动切换浅深色；Ghostty、Zed、OmniWM 和 mpv 标题栏跟随系统外观。
- `flake.nix` 的 `opacity = 0.8` 统一 Ghostty、OmniWM 快捷终端、Zed 与 mpv；Ghostty 与快捷终端用标准模糊 20，Zed 用原生模糊。Ghostty 应用后需重启，原生全屏下不透明。
- OmniWM 用 niri 滚动布局：宽度预设 50%、70%、100%，新窗口默认 70%，间距 8pt，聚焦边框 4pt（沿用默认色），鼠标移入即聚焦、切换焦点时鼠标跟随，触控板 `snap` 吸附。
- Lake＋Catppuccin，关闭模拟灵动岛；顶部栏中央留空，两侧显示工作区与状态，媒体和性能信息放控制中心。Lake 会隐藏原生菜单栏，点左侧应用图标访问“文件、编辑”。内建屏按 UUID 顶部留 40pt（32pt 刘海＋8pt 间距）。布局与快捷键在 `modules/omniwm/settings.toml`，样式入口在同目录 `default.nix`。
- Ghostty、Zed 用原生 Metal 渲染；Chrome 保留默认硬件加速，Blender 的 Cycles 设备在应用内选 Metal。
- Helix、Zed 用 Nix 提供的语言服务器；Python 用 ty＋ruff，TOML 用 Tombi。
- Herdr 启用自动深浅主题、Agent 会话恢复、SSH 保活与复用、Nushell pane、屏幕历史、worktree 管理及完成／等待通知。
- SSH 支持 SFTP/SCP 与远程开发：`ssh maxwellsagax@<Mac-IP>`；Obsidian 笔记库在 `~/Documents/notes`。
- 禁止在网络盘与 USB 存储写入 `.DS_Store`；不影响本机磁盘或已有文件。

## 软件与组件选择

| 软件／方案 | 取舍 | 当前方案 |
| --- | --- | --- |
| Nix 实现 | nix-darwin 统一管理 | `nix.package = pkgs.lix` |
| OmniWM 版本 | 当前锁定 nixpkgs 为 0.7.6，且 release 包不含 Lake 样式 | 官方 0.8.0 安装包，Lake 取自同版本源码；待收录后移除 |
| OmniWM 可写配置 | 保存时跟随符号链接，写入会落到只读的 Nix store | `home.activation` 在链接后用 `install` 复制为可写文件；下次应用仍以仓库声明覆盖 |
| Tabularis | `zstd-sys` 需系统 zstd，且由 `zip` 经 `zstd-safe` 传递引入 | 补 `zstd` 构建依赖，待上游修复后移除 |

## 已知问题

- 通知清理：OmniWM 0.8.0 的 `Clear All`／单条删除会在新版 macOS 上打开后立即关闭通知中心，导致清理失败；本机日志与 [#1235](https://github.com/OmniNull/OmniWM/issues/1235) 吻合。暂用系统原生通知中心清理，等待 [#1239](https://github.com/OmniNull/OmniWM/pull/1239) 修复。
- 窗口残边：OmniWM 在每块屏左右各常驻一条 1pt 纯黑遮罩，用来盖住停放窗口露出的残边；与间距无关，0.8.0 无开关。macOS 又限制窗口完全移出屏幕，其他工作区窗口停放后仍可能留下可拖动边缘，鼠标移到屏幕边缘也可能触发聚焦与滚动。
- Herdr 内 Agent 图片：已开启 `terminal.kitty_graphics = true`；Claude Code／Codex 在 pane 中发图仍受上游终端识别限制。跟踪：[Codex](https://github.com/openai/codex/issues/57541)、[Claude Code](https://github.com/anthropics/claude-code/issues/101306)、[Herdr](https://github.com/herdrdev/herdr/issues/5922)。
- WireGuard：已提供 `wg`、`wg-quick` 及 macOS 后端，连接参数待配置。
- OmniWM 天气：暂不设置；当前版本需指定城市或经纬度，不支持自动定位。
</content>
