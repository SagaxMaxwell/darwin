# Darwin

---

## 安装

```zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 构建

```zsh
sudo darwin-rebuild switch --flake .#MacBook
```

## 后续构建

```zsh
nix flake update
sudo darwin-rebuild switch --flake .#MacBook
```

## Obsidian 插件

`home.nix` 中的 `programs.obsidian.defaultSettings.communityPlugins` 定义共用的
7 个社区插件：Linter、Templater、Dataview、Homepage、Notebook Navigator、
Advanced Canvas 和 tldraw。使用 [NixOS Wiki](https://wiki.nixos.org/wiki/Obsidian#Community_plugins_and_themes)
介绍的第三方 [nix-obsidian-extensions](https://github.com/karaolidis/nix-obsidian-extensions)
提供插件包，配置中只需列出 `pkgs.obsidianPlugins` 下的插件名称。

目前只保存公共配置，不声明任何库路径，因此重建不会向现有库安装插件。
Obsidian 按库安装插件，没有全局插件目录；以后在 `programs.obsidian.vaults` 中声明的库
会自动继承这份清单。插件的 `data.json` 设置由 Obsidian 保存，不纳入 Nix 管理。

以后执行 `nix flake update obsidian-extensions` 更新插件包集合，也可以随 `nix flake update` 一起更新。
版本、下载地址和校验值由上游包集合维护，`flake.lock` 锁定包集合的修订。未声明库路径时，
更新只改变公共配置的依赖，不会修改现有库中的插件。

## 编辑器扩展

`home.nix` 中的 `programs.vscode.profiles.default.extensions` 管理当前安装的
16 个 VS Code 扩展，使用 [nix-vscode-extensions](https://github.com/nix-community/nix-vscode-extensions)
的正式发布集合。Oxc 使用通用版集合，与本机已安装的发行形式一致。
执行 `nix flake update vscode-extensions` 可更新扩展集合，无需手填版本或哈希。

## C#

使用 .NET 10 SDK，Helix 通过 Roslyn Language Server 提供语言服务，VS Code 使用微软官方 C# 扩展。
C# 文件由 CSharpier 格式化，Python 使用 Ruff，TOML 使用 Oxfmt。CSharpier 的 VS Code 扩展通过 .NET 工具清单查找版本；首次使用前运行
`dotnet tool install --global csharpier --version 1.3.0`。

应用配置前退出 VS Code，再执行 `sudo darwin-rebuild switch --flake .#MacBook`。

## Godot C#

`home.nix` 安装 `godot-mono` 和 `dotnet-sdk_10`；C# 外部编辑器为 VS Code。
通过 `overrideAttrs` 将 Godot 启动脚本使用的 SDK 指定为 `pkgs.dotnet-sdk_10`，
与终端使用的 SDK 保持一致，覆盖 nixpkgs 默认选择的 .NET 8。
Godot 4.7.2 创建 C# 项目时仍会在 `.csproj` 中写入桌面 `net8.0`、Android `net9.0`；
这是项目的目标框架，不是 Godot 实际调用的 SDK 版本。重建系统不会改变 Godot 的项目模板。
当前 .NET 10 SDK 可以编译这个 `net8.0` 项目。用 `dotnet --version` 检查命令行 SDK；
如需项目本身以 .NET 10 为目标，创建后再修改 `.csproj` 的 `TargetFramework`。

### Metal 闪退

2026-09-27：Nix 版 Godot 4.7.2 在 Forward+ / Metal 初始化时触发 `SIGBUS`，
崩溃栈位于 MoltenVK 的 SPIRV-Cross。可先用 Compatibility / OpenGL 打开项目：

```sh
godot-mono --editor --path ~/Documents/this-life \
  --rendering-method gl_compatibility --rendering-driver opengl3
```

若仍闪退，可从 [Godot macOS 下载页](https://godotengine.org/download/macos/)安装官方 .NET 版。
4.7.2 的 `Godot_v4.7.2-stable_mono_macos.universal.zip` 已通过 Metal、C# 编译和 .NET 10 运行测试；
SHA-256：`8af3977b60d2c59802f7c8ff1914b3ca02a5e294f7381fc1104ee777e33cbbd8`。
用 `shasum -a 256` 校验下载文件，保留完整的 `Godot_mono.app`。
标准 `godot-mono` 尚未完成运行验证。

若从 Finder 启动时提示找不到 .NET SDK，在 `darwin.nix` 参数中加入 `config`，
并设置运行时位置与命令搜索路径：

```nix
launchd.user.envVariables = {
  DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
  PATH = lib.replaceStrings [ "$HOME" "$USER" ] [
    config.users.users.${userName}.home
    userName
  ] config.environment.systemPath;
};
```

重建配置并重新启动 Godot。

## Chrome 扩展

`programs.google-chrome.extensions` 按 Chrome 商店 ID 声明 AdGuard AdBlocker，
由 Chrome 下载和更新。首次通过此方式安装时，需要在 Chrome 中确认启用。
