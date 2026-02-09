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
      # Set default browser and other stuff
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "chromium-browser.desktop";
          "x-scheme-handler/http" = "chromium-browser.desktop";
          "x-scheme-handler/https" = "chromium-browser.desktop";
          "x-scheme-handler/about" = "chromium-browser.desktop";
          "x-scheme-handler/unknown" = "chromium-browser.desktop";

          # otherwise this defaults to fucking kate???
          "inode/directory" = "org.kde.dolphin.desktop";

          "application/zip" = "peazip.desktop";
          "application/x-zip" = "peazip.desktop";
          "application/x-zip-compressed" = "peazip.desktop";
          "application/x-7z-compressed" = "peazip.desktop";
          "application/x-rar" = "peazip.desktop";
          "application/x-tar" = "peazip.desktop";
          "application/x-bzip2" = "peazip.desktop";
          "application/x-gzip" = "peazip.desktop";
        };
      };

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
