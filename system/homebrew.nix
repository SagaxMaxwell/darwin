{ config, ... }:

{

  # Pin Homebrew with Nix.
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;

    # Disable Homebrew analytics.
    extraEnv.HOMEBREW_NO_ANALYTICS = "1";
  };

  homebrew = {
    enable = true;
    global.brewfile = true;

    masApps = {
      "AdGuard Mini" = 1440147259;
      Developer = 640199958;
      GarageBand = 682658836;
      iMovie = 408981434;
      Keynote = 361285480;
      Numbers = 361304891;
      Pages = 361309726;
      "Quantumult X" = 1443988620;
      "Screens 5" = 1663047912;
    };

    taps = [ "acsandmann/tap" ];

    brews = [

      # Manage the service in apps/rift.nix.
      "acsandmann/tap/rift"
      "gascity"
      "mas"
    ];

    casks = [
      "anytype"
      "blender"
      "ghostty"
      "google-chrome"
      "shottr"
      "sfm"
      "tabularis"
      "zed"
      "zed-delta"
    ];
  };

  # Include Homebrew in the system PATH.
  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
    "${config.homebrew.prefix}/sbin"
  ];
}
