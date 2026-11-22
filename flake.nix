{
  description = "macOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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

    # Install Homebrew through Nix.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-index-database,
      nix-homebrew,
      ...
    }:
    let
      system = "aarch64-darwin";

      # Share background opacity and hex alpha.
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
            system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
          }
          ./darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          ./system/homebrew.nix
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
