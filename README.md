# Darwin 配置

面向 Apple Silicon 的 macOS 配置，使用 nix-darwin、Home Manager、Lix、OmniWM 和 Lake。

## 文件

| 文件 | 用途 |
| --- | --- |
| `flake.nix` / `flake.lock` | `MacBook` 入口、依赖锁定与共享主题参数 |
| `darwin.nix` | 系统服务、macOS 默认项、字体与 Home Manager 接入 |
| `home.nix` | 用户软件、Shell、终端和应用开关 |
| `helix.nix` / `zed.nix` | 编辑器与语言工具 |
| `herdr.nix` | Herdr 及 Claude Code／Codex 会话钩子 |
| `omniwm.nix` / `omniwm.toml` | OmniWM 安装、Lake 样式、窗口规则和快捷键 |

配置保持单一来源：系统设置在 `darwin.nix`，用户设置在 `home.nix` 或对应应用模块；透明度由 `flake.nix` 统一传入 Ghostty、OmniWM、Zed 和 mpv。OmniWM 的可写配置由 Home Manager 在切换时复制，运行时修改会在下一次应用时以仓库内容覆盖。

## 使用

先确认 `darwin.nix` 中的用户名和主机名，然后在仓库目录执行：

```sh
# 检查配置，不编译
nix flake check --no-build

# 构建并应用
sudo darwin-rebuild switch --flake .#MacBook

# 更新依赖
nix flake update
```

首次安装 Lix 时使用官方安装器；已有 Nix/Lix 无需重复安装。新增文件需要先 `git add`，这样 Flake 才会将其纳入输入。

## 当前约定

- Home Manager 管理用户软件、Shell 和 dotfiles；nix-darwin 管理系统服务、字体和 macOS 默认项。
- Zed、Herdr 保留可变配置，Nix 声明优先；删除声明字段后需手动清理用户配置中的旧值。
- OmniWM 使用 niri 布局、8pt 间距、4pt 聚焦边框和三指垂直工作区切换；详细规则见 `omniwm.toml`。
- Python 使用 ty＋ruff，TOML 使用 Tombi，Nix 使用 nixd＋nixfmt。
- Obsidian 笔记库位于 `~/Documents/notes`；SSH 服务已启用，WireGuard 工具已安装但连接参数待配置。

## 软件与组件取舍

记录评估过的替代方案、暂时采用的兼容处理，以及后来移除的工具。版本与兼容性结论来自当时锁定的依赖和实机记录，更新后可重新评估。后续精简 README 时保留本章及各项理由。

| 方案 | 取舍原因 | 当前选择／状态 |
| --- | --- | --- |
| Nix 实现与安装方式 | 2026 年 10 月将首次安装说明从 Determinate 安装器改为 Lix；历史未记录性能比较，不据此推断优劣 | 首次安装用 Lix 官方安装器，之后通过 `nix.package = pkgs.lix` 由 nix-darwin 统一管理版本与服务 |
| nixpkgs 默认 OmniWM | 当前配置记录的锁定版本为 0.7.6，未满足 0.8.0 的 OmniShell 与样式需求；官方 release 包也未包含所需 Lake 样式 | 固定官方 0.8.0 安装包，Lake 从同版本源码获取；待 nixpkgs 与上游打包满足需求后移除覆盖 |
| OmniWM 样式 Vitreus | 曾使用 Vitreus＋Catppuccin，后改为 Lake；历史未单独说明更换原因 | Lake＋Catppuccin，顶部中央留空、两侧显示工作区与状态 |
| OmniWM 配置直接链接到 Nix store | OmniWM 保存时跟随符号链接，会写入只读 store，无法正常保存 | Home Manager 链接后在 activation 中复制成可写文件；下次应用仍以仓库声明覆盖 |
| Tabularis 原包直接构建 | `zip` 经 `zstd-safe` 引入 `zstd-sys`，Rust 构建需要系统 zstd | 在 overlay 中补充 `zstd` 构建依赖；待上游修复后移除 |
| Nix 版 Godot Mono 的 Metal 渲染（历史） | 2026-09-27 记录 Godot 4.7.2 在 Forward+／Metal 初始化时触发 `SIGBUS`，崩溃栈位于 MoltenVK 的 SPIRV-Cross；相关说明于 10 月被删除 | 当时建议先用 Compatibility／OpenGL；官方 4.7.2 .NET 包曾通过 Metal、C# 编译与 .NET 10 测试。Godot／C# 工具链后来已移除，当前不安装；不能将旧测试结论推广到新版本 |

Godot、.NET SDK、Roslyn、CSharpier 和 VS Code 属于曾安装后移除的工具，2026-11-12 的 `c01bc03` 明确移除了 C# 工具链；历史没有记录这次移除的具体取舍原因。当前编辑器为 Helix 与 Zed，不能据此认定它们已经替代了完整的 C# 开发环境。

## 已知限制

OmniWM 0.8.0 在新版 macOS 上清理通知可能失败，窗口边缘偶尔会留下 1pt 黑边；天气组件暂未配置。Herdr pane 中的图片显示仍受上游终端识别限制。
