{
  lib,
  pkgs,
  inputs,
  opacity,
  alpha,
  ...
}:

let
  inherit (import ./flake.nix) nixConfig;
  hostName = "MacBook";
  userName = "maxwellsagax";
in
{
  imports = [ ./system/fonts.nix ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs opacity alpha; };

    users.${userName}.imports = [ ./home.nix ];
  };

  nix = {
    package = pkgs.lix;

    # Use locked Flake inputs instead of channels.
    channel.enable = false;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.use-xdg-base-directories = true;
    settings.http3 = true;
    settings.http2 = true;
    settings.http-connections = 50;
    settings.max-substitution-jobs = 32;
    settings.substituters = lib.mkAfter nixConfig.extra-substituters;
    settings.trusted-public-keys = lib.mkAfter nixConfig.extra-trusted-public-keys;

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
    inherit hostName;
    computerName = hostName;
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
      dock.mru-spaces = false;
      dock.show-recents = false;
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

  users.users.${userName}.home = "/Users/${userName}";
}
