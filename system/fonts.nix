{ lib, pkgs, ... }:

let
  extraFonts = import ../packages/fonts.nix { inherit lib pkgs; };
in
{
  fonts.packages = [
    pkgs.roboto-flex
    (pkgs.google-fonts.override {
      fonts = [
        "Roboto Serif"
        "Inter"
        "Recursive"
        "Shantell Sans"
        "Playwrite US Modern"
        "Nabla"
        "Honk"
        "STIX Two Math"
      ];
    })
    pkgs.monaspace.variable
    (pkgs.cascadia-code.override { useVariableFont = true; })
    pkgs.source-han-sans-vf-ttf
    pkgs.source-han-serif-vf-ttf
    pkgs.sarasa-gothic
    pkgs.lxgw-wenkai
    pkgs.smiley-sans
  ]
  ++ builtins.attrValues extraFonts;
}
