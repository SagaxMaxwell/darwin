{
  pkgs,
  opacity,
  alpha,
  ...
}:

let
  hostName = "MacBook";
  computerName = "MacBook";
  userName = "maxwellsagax";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit opacity alpha; };

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

  # Let Home Manager initialize Zsh completions.
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
      dock.autohide-delay = 0.5;
      dock.tilesize = 48;
      dock.showMissionControlGestureEnabled = true;
      dock.showAppExposeGestureEnabled = true;

      # Use four fingers for Mission Control.
      trackpad.TrackpadThreeFingerVertSwipeGesture = 0;
      trackpad.TrackpadFourFingerVertSwipeGesture = 2;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleShowAllExtensions = true;

      # Keep the desktop menu bar visible.
      NSGlobalDomain._HIHideMenuBar = false;

      # Follow system appearance.
      NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    };
  };

  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
