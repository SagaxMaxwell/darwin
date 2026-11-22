{
  config,
  lib,
  pkgs,
  alpha,
  ...
}:

{
  imports = [ ./rift.nix ];

  home.activation.tabularisAppearance = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.hm.generators.mkImpureConfigMerger {
      inherit pkgs;
      format = "json";
      empty = "{}";
      jqOperation = "$dynamic * $static";
      path = "${config.home.homeDirectory}/Library/Application Support/tabularis/config.json";
      staticSettings = (pkgs.formats.json { }).generate "tabularis-appearance.json" {
        followSystemTheme = true;
      };
    }
  );

  programs = {
    mpv = {
      enable = true;
      config = {
        hwdec = "auto";
        vo = "gpu-next";
        gpu-api = "auto";
        osc = false;
        background-color = "#${alpha}000000";
      };
      scripts = with pkgs.mpvScripts; [
        autosubsync-mpv
        skipsilence
        smartskip
        sponsorblock-minimal
        uosc
        thumbfast
      ];
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

  home.packages = with pkgs; [
    anime4k
    syncplay
  ];

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
