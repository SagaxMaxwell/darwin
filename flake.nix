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
  };

  outputs =
    inputs@{
      nix-darwin,
      home-manager,
      nix-index-database,
      ...
    }:
    let
      system = "aarch64-darwin";
    in
    {
      apps.${system}.darwin-rebuild = {
        type = "app";
        program = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
      };

      darwinConfigurations."MacBook" = nix-darwin.lib.darwinSystem {
        modules = [
          {
            nixpkgs.hostPlatform = system;
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
