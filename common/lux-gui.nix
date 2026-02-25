{
  pkgs,
  lib,
  config,
  ...
}:

{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        httpie
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        cascadia-code
        signal-desktop
        blender
        streamcontroller
      ];
      fonts.fontconfig.enable = true;
    };
}
