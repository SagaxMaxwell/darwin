# Darwin 配置

这是 macOS 的 nix-darwin + Home Manager 配置。入口是 `flake.nix`，主机配置和用户配置分开维护。

## 文件

- `flake.nix`：声明依赖、系统目标 `aarch64-darwin` 和 `MacBook` 配置入口。
- `flake.lock`：锁定 flake 依赖版本。
- `darwin.nix`：系统级设置、字体、网络名称、macOS 默认项和用户信息。
- `home.nix`：用户级软件包、Shell、开发工具、编辑器、Obsidian 和 GUI 应用。
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

其余专题说明见本文件原有章节。
