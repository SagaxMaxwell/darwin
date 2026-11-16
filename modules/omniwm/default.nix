{
  config,
  lib,
  pkgs,
  opacity,
  ...
}:

let

  # nixpkgs still ships 0.7.6; keep OmniShell and its style on the same release.
  version = "0.8.0";

  source = pkgs.fetchzip {
    url = "https://github.com/OmniNull/OmniWM/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-96uhsuIl9sbtBnS8AI13THtaFZSx8Ae+zqgIeDEN0XE=";
  };

  # OmniWM writes through symlinks; hand it real files instead of store links.
  makeWritable = relative: ''
    file=${lib.escapeShellArg "${config.xdg.configHome}/omniwm/${relative}"}
    if [[ -L "$file" ]]; then
      run install -m 600 -- "$(readlink -f -- "$file")" "$file"
    fi
  '';
in
{
  programs.omniwm = {
    enable = true;
    package = pkgs.omniwm.overrideAttrs {
      inherit version;
      src = pkgs.fetchurl {
        url = "https://github.com/OmniNull/OmniWM/releases/download/v${version}/OmniWM-v${version}.zip";
        hash = "sha256-b3+z4hHeOoPncrExgAaAyz0g1MY4gRofAhIP0iXwPMc=";
      };
    };
    launchd.keepAlive = false;
    settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile ./settings.toml)) {
      quakeTerminal = {
        inherit opacity;
        # Match Ghostty's background-blur = true.
        backgroundBlurRadius = 20;
      };
    };
  };

  xdg.configFile = {
    "omniwm/shell/lake".source = "${source}/styles/lake";
    "omniwm/shell/shell.toml" = {
      force = true;
      source = (pkgs.formats.toml { }).generate "omniwm-shell.toml" {
        profile = "lake";
        profiles.lake = {
          theme = "catppuccin";

          # Leave the physical notch clear; keep both sides compact.
          center = [ ];
          widgets.workspaces.compact = true;
          trailing = [
            "notifications"
            "volume"
            "wifi"
            "battery-details"
            "control-center"
            "clock"
          ];
        };
      };
    };
  };

  # Linking runs first every switch; copy the templates before OmniWM launches.
  home.activation.omniwmWritableConfig =
    lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "linkGeneration" ]
      (
        lib.concatMapStrings makeWritable [
          "settings.toml"
          "shell/shell.toml"
        ]
      );
}
