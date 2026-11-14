{ lib, opacity, ... }:

{
  programs.omniwm = {
    enable = true;
    launchd.keepAlive = false;
    settings = lib.recursiveUpdate (fromTOML (builtins.readFile ./settings.toml)) {
      quakeTerminal.opacity = opacity;
    };
  };
}
