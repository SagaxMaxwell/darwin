# Darwin

---

## 安装

```zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 构建

```zsh
sudo nix run .#darwin-rebuild -- switch --flake .#Maxwells-MacBook-Pro
```

## 后续构建

```zsh
nix flake update
sudo nix run .#darwin-rebuild -- switch --flake .#Maxwells-MacBook-Pro
```
