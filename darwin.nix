{ config, pkgs, ... }:

{
  system.stateVersion = 5;

  system.primaryUser = "maxwellsagax";

  nix.enable = false;

  users.users.maxwellsagax = {
    home = "/Users/maxwellsagax";  # ⭐关键
  };

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
