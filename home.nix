{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
  ];

  programs.git = {
    enable = true;
    userName = "Maxwell";
    userEmail = "your@email.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
