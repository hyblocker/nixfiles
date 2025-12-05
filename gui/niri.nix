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
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    xwayland-satellite-unstable
    playerctl
    brightnessctl
    waybar
    fuzzel
  ];

  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs.niri = {
        # settings = {
        # outputs."eDP-1".scale = 2.0;
        # "Mod-Q".action = close-window;
        # "";
        # };
      };
    };
}
