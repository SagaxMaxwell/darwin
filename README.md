# Darwin

---

## 安装

```zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 构建

```zsh
nix run .#darwin-rebuild -- switch --flake .#Maxwells-MacBook-Pro
```

## 后续构建

```zsh
nix flake update
nix run .#darwin-rebuild -- switch --flake .#Maxwells-MacBook-Pro
```
