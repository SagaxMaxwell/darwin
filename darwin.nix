{
  lib,
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

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "chatgpt"
      "google-chrome"
      "obsidian"
      "shottr"
      "claude-code"
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

  # Home Manager initializes Zsh completion.
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

      # Reserve three-finger vertical swipes for OmniWM workspaces.
      trackpad.TrackpadThreeFingerVertSwipeGesture = 0;
      trackpad.TrackpadFourFingerVertSwipeGesture = 2;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleShowAllExtensions = true;

      # Follow light and dark mode like Noctalia's auto theme on NixOS.
      NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
    };
  };

  users.users.${userName} = {
    home = "/Users/${userName}";
  };
}
