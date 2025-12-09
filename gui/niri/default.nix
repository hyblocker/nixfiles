{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri-unstable;

  programs.niri.enable = true;
  environment.variables.NIXOS_OZONE_WL = "1";
  environment.variables.QT_QPA_PLATFORMTHEME = "gtk3";
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    nautilus
    xwayland-satellite-unstable
    xdg-desktop-portal-shana
    playerctl
    brightnessctl
    waybar
    fuzzel
    mako # notification daemon
  ];

  imports = [
    ./noctalia.nix
  ];

  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs.niri = {
        config = ''
          ${lib.fileContents ./niri-config.kdl}
        '';
      };
    };
}
