{ config, pkgs, ... }:

let
  settings = {
    settings = {
      default_disable = false;
      animate = true;

      layout = {
        mode = "scrolling";
        gaps.inner = {
          horizontal = 8;
          vertical = 8;
        };
        scrolling = {
          column_width_ratio = 0.7;
          preset_column_widths = [
            0.5
            0.7
            0.9
          ];
          max_column_width_ratio = 0.9;

          # Use the default column width.
          preserve_window_sizes = false;
        };
      };
    };

    # Desktop shortcuts.
    modifier_combinations = {
      comb1 = "Alt + Shift";
    };
    keys = {
      "Alt + 0" = {
        switch_to_workspace = 0;
      };
      "Alt + 1" = {
        switch_to_workspace = 1;
      };
      "Alt + 2" = {
        switch_to_workspace = 2;
      };
      "Alt + 3" = {
        switch_to_workspace = 3;
      };
      "Alt + Comma" = "toggle_stack";
      "Alt + Ctrl + E" = "unjoin_windows";
      "Alt + Ctrl + Q" = "save_and_exit";
      "Alt + Ctrl + S" = "serialize";
      "Alt + Enter" = {
        exec = [
          "/usr/bin/open"
          "-n"
          "-a"
          "/Applications/Ghostty.app"
        ];
      };
      "Alt + F" = "toggle_fullscreen";
      "Alt + H" = {
        move_focus = "left";
      };
      "Alt + J" = {
        move_focus = "down";
      };
      "Alt + K" = {
        move_focus = "up";
      };
      "Alt + L" = {
        move_focus = "right";
      };
      "Alt + Shift + D" = "debug";
      "Alt + Shift + Down" = {
        join_window = "down";
      };
      "Alt + Shift + Equal" = "resize_window_grow";
      "Alt + Shift + F" = "toggle_fullscreen_within_gaps";
      "Alt + Shift + Left" = {
        join_window = "left";
      };
      "Alt + Shift + Minus" = "resize_window_shrink";
      "Alt + Shift + Right" = {
        join_window = "right";
      };
      "Alt + Shift + Space" = "toggle_window_floating";
      "Alt + Shift + Up" = {
        join_window = "up";
      };
      "Alt + Slash" = "toggle_orientation";
      "Alt + Tab" = "switch_to_last_workspace";
      "Alt + Z" = "toggle_space_activated";
      "comb1 + 0" = {
        move_window_to_workspace = 0;
      };
      "comb1 + 1" = {
        move_window_to_workspace = 1;
      };
      "comb1 + 2" = {
        move_window_to_workspace = 2;
      };
      "comb1 + 3" = {
        move_window_to_workspace = 3;
      };
      "comb1 + Ctrl + Space" = "toggle_focus_floating";
      "comb1 + H" = {
        move_node = "left";
      };
      "comb1 + J" = {
        move_node = "down";
      };
      "comb1 + K" = {
        move_node = "up";
      };
      "comb1 + L" = {
        move_node = "right";
      };
    };
  };
  configFile = (pkgs.formats.toml { }).generate "rift.toml" settings;
in
{

  # Share the config across launch methods.
  xdg.configFile."rift/config.toml".source = configFile;

  # Manage the Rift service.
  launchd.agents.rift = {
    enable = true;
    restartTriggers = [ configFile ];

    # Run at graphical login.
    domain = "gui";

    config = {
      Label = "git.acsandmann.rift";
      ProgramArguments = [
        "/opt/homebrew/opt/rift/Rift.app/Contents/MacOS/rift"
        "--config"
        "${config.xdg.configHome}/rift/config.toml"
      ];
      EnvironmentVariables = {
        PATH = "${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        RUST_LOG = "info";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      ProcessType = "Interactive";
      LimitLoadToSessionType = "Aqua";
      StandardOutPath = "/tmp/rift_${config.home.username}.out.log";
      StandardErrorPath = "/tmp/rift_${config.home.username}.err.log";
    };
  };
}
