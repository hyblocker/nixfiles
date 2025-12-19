{
  config,
  pkgs,
  lib,
  niri,
  ...
}:

{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      #imports = [ niri.homeModules.niri ];
      programs = {
        git = {
          enable = true;
          settings = {
            user.name = "Hyblocker";
            user.email = "hyblocker@protonmail.com";
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
        bash = {
          enable = true;
          shellAliases = {
            wokefetch = "hyfetch";
          };
        };
      };
    };
}
