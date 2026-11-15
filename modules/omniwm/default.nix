{ pkgs, ... }:

let
  # nixpkgs still ships 0.7.6; keep OmniShell and its style on the same release.
  version = "0.8.0";
  source = pkgs.fetchzip {
    url = "https://github.com/OmniNull/OmniWM/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-96uhsuIl9sbtBnS8AI13THtaFZSx8Ae+zqgIeDEN0XE=";
  };
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
    settings = ./settings.toml;
  };

  xdg.configFile = {
    "omniwm/shell/vitreus".source = "${source}/styles/vitreus";
    "omniwm/shell/shell.toml" = {
      source = (pkgs.formats.toml { }).generate "omniwm-shell.toml" {
        profile = "vitreus";
        profiles.vitreus.theme = "catppuccin";
      };
      force = true;
    };
  };
}
