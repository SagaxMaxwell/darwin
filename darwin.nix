{ config, pkgs, ... }:

{
  system.stateVersion = 5;

  system.primaryUser = "maxwellsagax";

  nix.enable = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    fzf
    eza
  ];

  system.defaults = {
    dock.autohide = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.AppleShowAllExtensions = true;
  };
}
