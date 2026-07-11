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

## 后续构建

```zsh
nix flake update
darwin-rebuild switch --flake .
```
