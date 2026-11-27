{ ... }:

{
  imports = [
    ./editor/helix.nix
    ./editor/zed.nix
    ./apps/terminal.nix
    ./apps/development.nix
    ./apps/desktop.nix
  ];

  _module.args.terminalFonts = [
    "Monaspace Neon Var"
    "Cascadia Code NF"
    "Maple Mono NF"
    "Maple Mono NF CN"
    "Recursive"
    "Sarasa Mono SC"
    "Sarasa Term SC"
  ];

  home.stateVersion = "26.11";
  xdg.enable = true;
}
