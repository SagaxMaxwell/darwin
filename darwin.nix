{
  pkgs,
  opacity,
  ...
}:

let
  hostName = "Macbook";
  computerName = "Macbook";
  userName = "maxwellsagax";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    overwriteBackup = true;
    extraSpecialArgs = { inherit opacity; };

    users.${userName} = {
      imports = [
        ./home.nix
      ];
    };
  };

  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

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

  services.openssh.enable = true;

  # Home Manager owns Zsh completion init.
  programs.zsh.enableGlobalCompInit = false;

  system = {
    stateVersion = 7;

    primaryUser = userName;

    defaults = {
      CustomUserPreferences."com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      WindowManager.GloballyEnabled = false;
      dock.autohide = true;
      dock.showMissionControlGestureEnabled = true;
      dock.showAppExposeGestureEnabled = true;

      # Three-finger vertical swipes switch OmniWM workspaces.
      trackpad.TrackpadThreeFingerVertSwipeGesture = 0;
      trackpad.TrackpadFourFingerVertSwipeGesture = 2;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleShowAllExtensions = true;

      # Follow system appearance.
      NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    };
  };

  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
