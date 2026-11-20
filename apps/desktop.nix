{
  lib,
  alpha,
  ...
}:

{
  imports = [ ./rift.nix ];

  programs = {
    mpv = {
      enable = true;
      config = {
        hwdec = "auto";
        background-color = "#${alpha}000000";
      };
    };

    google-chrome = {
      enable = true;
      package = null;

      extensions = [

        # AdGuard AdBlocker.
        "bgnkhhnnamicmpeenaelnjfhikgbkllg"
      ];
    };
  };

  launchd.agents =
    lib.mapAttrs
      (_: args: {
        enable = true;
        domain = "gui";
        config = {
          ProgramArguments = [ "/usr/bin/open" ] ++ args;
          RunAtLoad = true;
          LimitLoadToSessionType = "Aqua";
        };
      })
      {
        adguard-mini = [
          "-g"
          "-a"
          "/Applications/AdGuard Mini.app"
        ];
        chrome = [
          "-a"
          "/Applications/Google Chrome.app"
        ];
        ghostty = [
          "-a"
          "/Applications/Ghostty.app"
        ];
        quantumult-x = [
          "-a"
          "/Applications/Quantumult X.app"
        ];
        shottr = [
          "-g"
          "-a"
          "/Applications/Shottr.app"
        ];
      };
}
