{
  pkgs,
  lib,
  config,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.stateVersion = "23.11";
      home.packages = with pkgs; [
        atool
        httpie
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        cascadia-code
      ];
      fonts.fontconfig.enable = true;
    };
}
