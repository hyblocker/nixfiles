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
    settings.port = 8080;
  };
}