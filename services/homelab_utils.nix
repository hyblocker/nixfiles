{ config, pkgs, lib, ... }:

let
  hostname = config.networking.hostName;
  domain = "${hostname}.local";

  mkServiceProxy = path: port: {
    services.nginx.virtualHosts."${domain}".locations."${path}" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
      '';
    };
  };
in
{
  _module.args.homelab = {
    inherit domain mkServiceProxy;
  };
}