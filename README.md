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

## 已知限制

OmniWM 0.8.0 在新版 macOS 上清理通知可能失败，窗口边缘偶尔会留下 1pt 黑边；天气组件暂未配置。Herdr pane 中的图片显示仍受上游终端识别限制。
