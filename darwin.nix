{
  computerName,
  hostName,
  pkgs,
  userName,
  ...
}:

{
  nix = {
    enable = false;
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

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
    stateVersion = 5;

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
