{
  description = "Maxwell's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
};

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
  in
  {
    darwinConfigurations."Maxwells-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager

      {

        home-manager.useGlobalPkgs = true;

        home-manager.useUserPackages = true;

        home-manager.users.maxwellsagax = import ./home.nix;
        home-manager.extraSpecialArgs = {

    inherit (inputs) self;

  };

      }
      ];
    };
  };
}
