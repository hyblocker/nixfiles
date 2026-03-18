{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  forgejo_port = 3000;
in
{
  services.forgejo = {
    enable = true;
    settings.server.HTTP_ADDR = "0.0.0.0";
    settings.server.HTTP_PORT = forgejo_port;
  };

  lux.reverseProxy = {
    enable = true;

    proxies.git = {
      port = forgejo_port;
      path = "/git";
    };
  };
}