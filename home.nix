{
  config,
  gitUserEmail,
  gitUserName,
  pkgs,
  ...
}:

{
  home.stateVersion = "24.05";

  xdg.enable = true;

  # Copy Home Manager GUI apps into ~/Applications so Spotlight can index them.
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = true;
  };

  programs.home-manager.enable = true;

  # curl and wget do not have Home Manager modules, so keep them as packages.
  home.packages = with pkgs; [
    curl
    wget
  ];

  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.fzf.enable = true;
  programs.wezterm.enable = true;
  programs.helix.enable = true;
  programs.vscode.enable = true;
  programs.obsidian.enable = true;
  programs.uv.enable = true;
  programs.codex.enable = true;

  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim;
  };

  # Uses the Git identity placeholders from flake.nix.
  programs.git = {
    enable = true;
    settings.user = {
      name = gitUserName;
      email = gitUserEmail;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };
}
