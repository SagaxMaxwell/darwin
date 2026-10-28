# Darwin 配置

这是 macOS 的 nix-darwin + Home Manager 配置。入口是 `flake.nix`，主机配置和用户配置分开维护。

## 文件

- `flake.nix`：声明依赖、系统目标 `aarch64-darwin` 和 `MacBook` 配置入口。
- `flake.lock`：锁定 flake 依赖版本。
- `darwin.nix`：系统级设置、字体、网络名称、macOS 默认项和用户信息。
- `home.nix`：用户级软件包、Shell、开发工具、编辑器、Obsidian 和 GUI 应用。
- `modules/omniwm/default.nix`：启用 OmniWM 并加载配置，由 `home.nix` 导入。
- `modules/omniwm/settings.toml`：OmniWM 的布局、焦点、手势和快捷键设置。
- `README.md`：构建方式与配置说明。
- `LICENSE`、`.gitignore`：许可证和 Git 忽略规则。

## 安装

```zsh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

## 构建

```zsh
sudo nix run .#darwin-rebuild -- switch --flake .#MacBook
```

需要更新依赖时运行 `nix flake update`。

## OmniWM

修改 `modules/omniwm/settings.toml` 后，运行上面的构建命令应用配置。

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
