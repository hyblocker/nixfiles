{
  config,
  pkgs,
  lib,
  ...
}:

{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs = {
        git = {
          enable = true;
          userName = "Hyblocker";
          userEmail = "hyblocker@protonmail.com";

          extraConfig = {
            push.autoSetupRemote = true;
            init.defaultBranch = "main";
          };
        };
        hyfetch = {
          enable = true;
          settings = {
            preset = "nonbinary";
            mode = "rgb";
            auto_detect_light_dark = true;
            light_dark = "dark";
            lightness = 0.65;
            color_align = {
              mode = "horizontal";
            };
            backend = "fastfetch";
            args = null;
            distro = null;
            pride_month_disable = false;
          };
        };
        fastfetch = {
          enable = true;
        };
      };
    };
}
