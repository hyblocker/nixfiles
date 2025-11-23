{
  config,
  pkgs,
  lib,
  niri,
  ...
}:

{
  nixpkgs.overlays = [ niri.overlays.niri ];

  #programs.niri.enable = true;
  #programs.niri.package = pkgs.niri-unstable;
  #environment.variables.NIXOS_OZONE_WL = "1";
}
