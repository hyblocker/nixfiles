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
    settings.host = "0.0.0.0";
    settings.port = 8080;
  };
}