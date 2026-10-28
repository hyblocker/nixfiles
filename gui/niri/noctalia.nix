# noctalia is a desktop shell for wayland using quickshell, replaces waybar and adds some nice things :D
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

      programs.noctalia = {
        enable = true;
        settings = {
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          bar = {
            default = {
              background_opacity = 0.5;
              compositor_blur = true;
              margin_ends = 0;
              concave_edge_corners = false;
            };
          };

          wallpaper = {
            enabled = true;
            directory = "/home/lux/Pictures/Wallpapers";

            automation = {
              enabled = true;
              interval_seconds = 1800;
              order = "random";
            };
          };

          backdrop = {
            enabled = true;
            blur_intensity = 0.5;
            tint_intensity = 0.3;
          };
        };
      };
    };
}
