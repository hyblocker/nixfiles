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
          };
        };
        fastfetch = {
          enable = true;
          settings = {
            "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
            logo = {
              source = ''
                $1          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
                $1          ▜███▙       ▜███▙  ▟███▛
                $1           ▜███▙       ▜███▙▟███▛
                $1            ▜███▙       ▜██████▛
                $1     ▟█████████████████▙ ▜████▛     ▟▙
                $2    ▟███████████████████▙ ▜███▙    ▟██▙
                $2           ▄▄▄▄▖           ▜███▙  ▟███▛
                $2          ▟███▛             ▜██▛ ▟███▛
                $2         ▟███▛               ▜▛ ▟███▛
                $2▟███████████▛                  ▟██████████▙
                $3▜██████████▛                  ▟███████████▛
                $3      ▟███▛ ▟▙               ▟███▛
                $3     ▟███▛ ▟██▙             ▟███▛
                $3    ▟███▛  ▜███▙           ▝▀▀▀▀
                $3    ▜██▛    ▜███▙ ▜██████████████████▛
                $4     ▜▛     ▟████▙ ▜████████████████▛
                $4           ▟██████▙       ▜███▙
                $4          ▟███▛▜███▙       ▜███▙
                $4         ▟███▛  ▜███▙       ▜███▙
                $4         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘'';
              type = "data";
              color = {
                "1" = "yellow";
                "2" = "white";
                "3" = "magenta";
                "4" = "black";
              };
            };
            "modules" = [
              "title"
              "separator"
              "os"
              "host"
              "kernel"
              "uptime"
              "packages"
              "shell"
              "display"
              "de"
              "wm"
              "wmtheme"
              "theme"
              "icons"
              "font"
              "cursor"
              "terminal"
              "terminalfont"
              "cpu"
              "gpu"
              "memory"
              "swap"
              "disk"
              "localip"
              "battery"
              "poweradapter"
              "locale"
              "break"
              "colors"
            ];
          };
        };
      };
    };
}
