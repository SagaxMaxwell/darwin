{
  description = "macOS configuration";

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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      nix-index-database,
      ...
    }:
    let
      hostName = "Maxwells-MacBook-Pro";

      computerName = "Maxwell's MacBook Pro";

      userName = "maxwellsagax";

      gitUserName = "Maxwell";
      gitUserEmail = "sagax.maxwell@gmail.com";
    in
    {
      darwinConfigurations.${hostName} = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit computerName hostName userName;
        };

        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit gitUserEmail gitUserName;
              };
              users.${userName} = {
                imports = [
                  nix-index-database.homeModules.nix-index
                  ./home.nix
                ];
              };
            };
          }
        ];
      };
    };
}
