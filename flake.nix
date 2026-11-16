{
  description = "macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    obsidian-extensions = {
      url = "git+https://github.com/karaolidis/nix-obsidian-extensions?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-index-database,
      obsidian-extensions,
      ...
    }:
    let
      system = "aarch64-darwin";

      # Shared background opacity and its #RRGGBBAA alpha.
      opacity = 0.8;
      alpha = nixpkgs.lib.fixedWidthString 2 "0" (
        nixpkgs.lib.toLower (nixpkgs.lib.toHexString (builtins.floor (opacity * 255 + 0.5)))
      );
    in
    {
      apps.${system}.darwin-rebuild = {
        type = "app";
        program = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
      };

      darwinConfigurations."MacBook" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit opacity alpha; };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.overlays = [
              obsidian-extensions.overlays.default
              (final: prev: {

                # Rust setup hook needs system zstd for zstd-sys.
                tabularis = prev.tabularis.overrideAttrs (old: {
                  buildInputs = (old.buildInputs or [ ]) ++ [ final.zstd ];
                });
              })
            ];
            system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
          }
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
              nix-index-database.homeModules.nix-index
            ];
          }
        ];
      };
    };
}
