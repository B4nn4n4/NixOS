{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only used for FreeRDP downgrade
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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-freerdp,
    nixos-hardware,
    home-manager,
    forticlient-nixos,
    ...
  }:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # Overlay: use FreeRDP from older nixpkgs only
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              freerdp = nixpkgs-freerdp.legacyPackages.${prev.system}.freerdp;
            })
          ];
        })

        ./configuration.nix
        home-manager.nixosModules.home-manager
        nixos-hardware.nixosModules.microsoft-surface-common
        forticlient-nixos.nixosModules.default

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.adm-kalbf = import ./home.nix;
        }
      ];
    };
  };
}
