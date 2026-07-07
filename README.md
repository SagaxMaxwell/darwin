# Darwin

---

## 安装

```zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 构建

```zsh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .
```

> 修改自定义配置，再构建

## 配置

- helix
- wezterm

> 移动到 `~/.config` 下
