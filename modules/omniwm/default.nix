{ ... }:

{
  programs.omniwm = {
    enable = true;
    launchd.keepAlive = false;
    settings = ./settings.toml;
  };
}
