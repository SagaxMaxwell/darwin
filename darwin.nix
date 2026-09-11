{
  lib,
  pkgs,
  ...
}:

let
  hostName = "Maxwells-MacBook-Pro";
  computerName = "Maxwell's MacBook Pro";
  userName = "maxwellsagax";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${userName} = {
      imports = [
        ./home.nix
      ];
    };
  };

  nix = {
    # Determinate Nix owns the Nix installation and daemon.
    enable = false;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "chatgpt"
      "google-chrome"
      "obsidian"
      "shottr"
      "vscode"
    ];

  fonts.packages = with pkgs; [
    source-han-sans
    source-han-serif
    source-han-mono
    lxgw-wenkai
    ibm-plex
    nerd-fonts.jetbrains-mono
  ];

  networking = {
    inherit computerName hostName;
  };

  system = {
    stateVersion = 7;

    primaryUser = userName;

    defaults = {
      dock.autohide = true;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleShowAllExtensions = true;
    };
  };

  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
