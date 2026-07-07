{
  computerName,
  hostName,
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

  # Uses the HostName and ComputerName placeholders from flake.nix.
  networking = {
    inherit computerName hostName;
  };

  system = {
    stateVersion = 5;

    # Uses the macOS short user name placeholder from flake.nix.
    primaryUser = userName;

    defaults = {
      dock.autohide = true;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleShowAllExtensions = true;
    };
  };

  # Uses the macOS short user name placeholder from flake.nix.
  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
