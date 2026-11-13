# Darwin 配置

这是 macOS 的 nix-darwin + Home Manager 配置。入口是 `flake.nix`，主机配置和用户配置分开维护。

## 文件

- `flake.nix`：声明依赖、系统目标 `aarch64-darwin`、`MacBook` 配置入口，以及所有半透明界面共用的 `opacity`。
- `flake.lock`：锁定 flake 依赖版本。
- `darwin.nix`：系统级设置、字体、网络名称、macOS 默认项和用户信息。
- `home.nix`：用户级软件包、Shell、开发工具、编辑器、Obsidian 和 GUI 应用。
- `modules/omniwm/default.nix`：启用 OmniWM 并加载配置，由 `home.nix` 导入。
- `modules/omniwm/settings.toml`：OmniWM 的布局、焦点、手势和快捷键设置。
- `README.md`：构建方式与配置说明。
- `LICENSE`、`.gitignore`：许可证和 Git 忽略规则。

## 首次使用

仅首次安装、系统尚无 Nix/Lix 时执行；已有安装则跳过：

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

安装后重新打开终端。安装器自动准备 `/nix`，无需手动挂载；之后由 nix-darwin 管理 Lix。

若尚无 `darwin-rebuild`，在仓库目录首次构建并应用：

```sh
nix build .#darwinConfigurations.MacBook.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#MacBook
```

## 常用命令

均在仓库目录执行。应用配置：

```sh
sudo darwin-rebuild switch --flake .#MacBook
```

升级软件：先运行 `nix flake update`，再应用配置。新增配置文件先 `git add 文件路径`；不必提交。

<details>
<summary>检查、构建与回滚（按需执行）</summary>

| 用途 | 命令 |
| --- | --- |
| 检查 flake 求值，不编译 | `nix flake check --no-build` |
| 查看构建计划，不编译 | `nix build --dry-run --no-link .#darwinConfigurations.MacBook.system` |
| 完整构建，不应用 | `nix build --no-link .#darwinConfigurations.MacBook.system` |
| 回到上一代系统 | `sudo darwin-rebuild switch --rollback` |

回滚不修改仓库文件。

</details>

## 应用

- 禁止在网络盘和 USB 存储上写入 `.DS_Store`；不影响本机磁盘或已有文件。
- 系统外观自动切换浅深色；Ghostty、Zed、OmniWM 和 mpv 标题栏跟随系统外观。
- 背景不透明度统一用 `flake.nix` 里的 `opacity`（当前 0.8）：Ghostty、Zed 和 OmniWM 下拉终端启用原生背景模糊；mpv 仅设置背景颜色及透明度。Ghostty 应用后需重启，原生全屏模式下不透明。
- Ghostty、Zed 使用原生 Metal 渲染；Chrome 保留默认硬件加速，Blender 的 Cycles 渲染设备在应用内选择 Metal。
- Helix 与 Zed 使用 Nix 提供的语言服务器；Python 使用 ty＋ruff，TOML 使用 Tombi。
- Zed 保留界面内修改的设置，应用配置时 Nix 声明优先；删除 Nix 字段后，旧值可能仍需在应用内清理。
- Obsidian 笔记库为 `~/Documents/notes`。

## OmniWM

布局与快捷键在 `modules/omniwm/settings.toml` 中维护，下拉终端透明度由 Nix 统一设置。界面内的修改需同步回仓库，否则下次应用配置会恢复仓库设置。

间距、边框宽度、焦点行为和窗口宽度与 NixOS 上的 Umbriel 保持一致：间距 8pt，边框 4pt，边框颜色为 Noctalia WhiteBlue 的主色 `#629EE8`。

默认使用 niri 布局，窗口宽度预设为 50%、70%、100%，新窗口默认宽度为 70%：

```toml
[niri]
containerPrimarySpanPresets = [0.50, 0.70, 1.0]
defaultContainerPrimarySpan = 0.70
```

焦点相关设置：

```toml
[focus]
followsMouse = true
moveMouseToFocusedWindow = true
```

- `followsMouse`：鼠标移到窗口上时，该窗口获得焦点。
- `moveMouseToFocusedWindow`：切换聚焦窗口时，鼠标自动移到该窗口。

当前观察到，开启 `followsMouse` 时，鼠标移到屏幕右边缘可能让屏幕外的窗口获得焦点并触发布局滚动。若需避免此行为，可将其设为 `false`；此时需要点击窗口或用快捷键切换焦点。

触控板滑动当前使用吸附模式：

```toml
[gestures]
scrollEnabled = true
trackpadScrollStyle = "snap"
```

`trackpadScrollStyle` 支持两种取值：

| 值 | 行为 |
| --- | --- |
| `"snap"` | 滑动结束后吸附到窗口列。 |
| `"momentum"` | 按惯性滑动，不自动吸附到窗口列，窗口可能只显示一部分。 |

### 已知问题

- **屏幕两侧的 1pt 黑边**：OmniWM 会在普通显示器的可见区域左右各创建一条约 1pt 的黑色边缘遮罩。因此，即使当前工作区有多个窗口并且已经滚动到最右侧或最左侧窗口，边缘仍可能显示黑线。这是 OmniWM 当前的固定遮罩设计，不是窗口间距配置造成的。
- **隐藏窗口残边仍可拖动**：切换工作区后，OmniWM 会把非当前工作区的窗口停放到屏幕外。macOS 不允许窗口完全移出屏幕，所以窗口仍可能在左右边缘保留可交互的可见条带；从边缘按住拖动时，可能会把其他工作区的窗口拖入当前工作区。这与 macOS 的窗口停放限制和 OmniWM 当前的窗口停放机制有关。
