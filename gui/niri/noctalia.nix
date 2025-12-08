# noctalia is a desktop shell for wayland using quickshell, replaces waybar afaik?
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
      };
    };
}
