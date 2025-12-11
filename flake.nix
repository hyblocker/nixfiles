{
  description = "Lux's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = "https://niri.cachix.org";
    extra-trusted-public-keys = "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-bleeding,
      home-manager,
      nixcord,
      nixos-hardware,
      niri,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlays.additions ];
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        overlays = [ overlays.additions ];
      };
      pkgs-bleeding = import nixpkgs-bleeding {
        inherit system;
        overlays = [ overlays.additions ];
      };
    in

    {

      baseModules = [
        ./common/base.nix
        ./common/lux.nix
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
      ];

      devModules = [
        ./common/lux-gui.nix
        ./common/dev.nix
        ./apps/all.nix
        ./gui/kde-plasma.nix
        ./gui/niri
      ]
      ++ self.baseModules;

      nixosConfigurations.fartwork = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-stable pkgs-bleeding; };
        system = "x86_64-linux";
        modules = [
          {
            _module.args = { inherit inputs; };
          }
          {
            nixpkgs.overlays = [ overlays.additions ];
          }
          ./devices/fartwork/configuration.nix
          ./devices/fartwork/hardware-configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
        ]
        ++ self.devModules;
      };
    };
}
