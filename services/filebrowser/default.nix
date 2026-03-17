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
    settings.address = "0.0.0.0";
    settings.port = 8080;
  };
}