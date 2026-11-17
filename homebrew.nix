{ config, ... }:

{

  # Pin Homebrew with Nix.
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;

    # Disable analytics for all brew commands.
    extraEnv.HOMEBREW_NO_ANALYTICS = "1";
  };

  homebrew = {
    enable = true;
    global.brewfile = true;

    taps = [ "acsandmann/tap" ];

    # Manage the Rift service only in rift.nix.
    brews = [ "acsandmann/tap/rift" ];

    casks = [
      "blender"
      "ghostty"
      "google-chrome"
      "obsidian"
      "shottr"
      "tabularis"
      "zed"
    ];
  };

  # Expose Homebrew commands to Nushell too.
  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
    "${config.homebrew.prefix}/sbin"
  ];
}
