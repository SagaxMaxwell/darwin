# Darwin

---

## 安装

```zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## 构建

```zsh
sudo -H nix run .#darwin-rebuild -- switch --flake .#MacBook
```

## 后续构建

```zsh
nix flake update
sudo -H nix run .#darwin-rebuild -- switch --flake .#MacBook
```
