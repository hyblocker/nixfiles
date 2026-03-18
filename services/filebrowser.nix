{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  filebrowser_port = 8080;
in
{
  services.filebrowser = {
    enable = true;
    openFirewall = true;
    settings.address = "0.0.0.0";
    settings.port = filebrowser_port;
  };

  lux.reverseProxy = {
    enable = true;

    services.files = {
      port = filebrowser_port;
    };
  };
}