{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  services.filebrowser = {
    enable = true;
    openFirewall = true;
  };
}