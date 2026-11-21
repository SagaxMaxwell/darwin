{ lib, pkgs, ... }:

let
  extraFonts = import ../packages/fonts.nix { inherit lib pkgs; };
in
{
  fonts.packages =
    with pkgs;
    [
      roboto-flex
      (google-fonts.override {
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
      monaspace.variable
      (cascadia-code.override { useVariableFont = true; })
      source-han-sans-vf-ttf
      source-han-serif-vf-ttf
      sarasa-gothic
      lxgw-wenkai
      smiley-sans
    ]
    ++ builtins.attrValues extraFonts;
}
