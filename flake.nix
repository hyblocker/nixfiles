{
  description = "Lux's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-bleeding.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://niri-epireyn.cachix.org" # niri nix builds
      "https://noctalia.cachix.org" # noctalia nix builds
    ];
    extra-trusted-public-keys = [
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA=" # niri nix builds
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" # noctlia  nix builds
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-bleeding,
      home-manager,
      nixcord,
      noctalia,
      nixos-hardware,
      niri,
      sops-nix,
      nix-vscode-extensions,
      helium-flake,
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
        config.allowUnfree = true;
      };
      pkgs-bleeding = import nixpkgs-bleeding {
        inherit system;
        overlays = [ overlays.additions ];
      };
    in

    {

      flakeModules = [
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        sops-nix.nixosModules.sops
        helium-flake.nixosModules.default
      ];

      baseModules = [
        ./common/base.nix
        ./common/lux.nix
      ]
      ++ self.flakeModules;

      devModules = [
        ./common/dev.nix
        ./apps/all.nix
      ]
      ++ self.baseModules;

      guiModules = [
        ./common/lux-gui.nix
        ./gui/kde-plasma.nix
        ./gui/niri
      ]
      ++ self.devModules;

      serverModules = [
        ./common/server.nix
      ];

      nixosConfigurations.fartwork = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-stable pkgs-bleeding; };
        system = "x86_64-linux";
        modules = [
          {
            _module.args = { inherit inputs; };
          }
          {
            nixpkgs.overlays = [
              overlays.additions
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          ./devices/fartwork/configuration.nix
          ./devices/fartwork/hardware-configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
        ]
        ++ self.guiModules;
      };

      nixosConfigurations.chungus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-stable pkgs-bleeding; };
        system = "x86_64-linux";
        modules = [
          {
            _module.args = { inherit inputs; };
          }
          {
            nixpkgs.overlays = [
              overlays.additions
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          ./devices/chungus/configuration.nix
          ./devices/chungus/hardware-configuration.nix
          ./devices/chungus/services.nix
        ]
        ++ self.devModules
        ++ self.serverModules;
      };
    };
}
