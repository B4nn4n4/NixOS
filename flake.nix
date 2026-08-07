{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-freerdp.url = "github:NixOS/nixpkgs/bd0ff2d3eac2";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forticlient-nixos = {
      url = "github:jplana/forticlient-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-freerdp, nixos-hardware, home-manager, forticlient-nixos, nixvim, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      NixOS = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/hosts/Laptop.nix
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.microsoft-surface-common
          forticlient-nixos.nixosModules.default

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.fabian = {
              imports = [
                nixvim.homeModules.nixvim
                ./home.nix
              ];
            };
          }
        ];
      };

      AlienSpaceship = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  ./configuration.nix
          ./AlienSpaceShip.nix
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.fabian = {
              imports = [
                nixvim.homeModules.nixvim
                ./home.nix
              ];
            };
          }
        ];
      };
    };
  };
}

