{
  description = "Lux's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixcord.url = "github:kaylorben/nixcord";
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
      ];

      devModules = [
        ./common/lux-gui.nix
        ./apps/all.nix
        ./gui/kde-plasma.nix
        stylix.nixosModules.stylix
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
