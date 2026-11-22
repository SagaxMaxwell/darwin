{
  lib,
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
  imports = [ ./system/fonts.nix ];

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

    # Use locked Flake inputs instead of channels.
    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.substituters = lib.mkAfter [
      "https://nix-community.cachix.org"
    ];
    settings.trusted-public-keys = lib.mkAfter [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    gc = {
      automatic = true;
      interval = [
        {
          Weekday = 7;
          Hour = 3;
          Minute = 15;
        }
      ];
      options = "--delete-older-than 30d";
    };

    optimise = {
      automatic = true;
      interval = [
        {
          Weekday = 7;
          Hour = 4;
          Minute = 15;
        }
      ];
    };
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  networking = {
    inherit computerName hostName;
  };

  services.openssh.enable = true;

  # Initialize completions through Home Manager.
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
      dock.orientation = "right";
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

      # Preserve system transparency.
      universalaccess.reduceTransparency = false;

      # Switch appearance automatically.
      NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    };
  };

  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
