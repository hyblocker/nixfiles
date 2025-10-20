{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS 25.05
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixcord,
      nixos-hardware,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlays.additions ];
      };
    in

    {

      baseModules = [
        ./common/base.nix
        ./common/lux.nix
        home-manager.nixosModules.home-manager
        stylix.nixosModules.default
        {
          nixpkgs.overlays = [ overlays.additions ];
        }
      ];

      devModules = [
        ./common/lux-gui.nix
        ./apps/all.nix
        ./gui/kde-plasma.nix
      ]
      ++ self.baseModules;

      nixosConfigurations.fartwork = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            _module.args = { inherit inputs; };
          }
          ./devices/fartwork/configuration.nix
          ./devices/fartwork/hardware-configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
        ]
        ++ self.devModules;
      };
    };
}
