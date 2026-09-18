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
