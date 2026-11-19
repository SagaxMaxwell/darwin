{
  lib,
  pkgs,
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

    obsidian = {
      enable = true;
      package = null;
      cli.enable = true;

      vaults.notes = {
        target = "Documents/notes";
        settings.app.restrictedMode = false;
      };

      defaultSettings.communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-linter
        {
          pkg = obsidian-style-settings;
          settings = {
            "Appearance-light@@card-layout-open-light" = true;
            "Appearance-dark@@card-layout-open-dark" = true;
            "Appearance-light@@mod-left-split-background-select-light" =
              "mod-left-split-background-transparent-light";
            "Appearance-light@@mod-root-split-background-select-light" =
              "mod-root-split-background-transparent-light";
            "Appearance-light@@mod-right-split-background-select-light" =
              "mod-right-split-background-transparent-light";
            "Appearance-dark@@mod-left-split-background-select-dark" =
              "mod-left-split-background-transparent-dark";
            "Appearance-dark@@mod-root-split-background-select-dark" =
              "mod-root-split-background-transparent-dark";
            "Appearance-dark@@mod-right-split-background-select-dark" =
              "mod-right-split-background-transparent-dark";
          };
        }
        {
          pkg = update-time;
          settings = {
            createdPropertyName = "date created";
            updatedPropertyName = "date updated";
          };
        }
        templater-obsidian
        dataview
        notebook-navigator
        jupyter-viewer
        advanced-canvas
        tldraw
      ];

      defaultSettings.themes = [ pkgs.obsidianThemes.border ];

      defaultSettings.appearance.translucency = true;
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
