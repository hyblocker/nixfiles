{ config, lib, ... }:

let
  cfg = config.lux.reverseProxy;
  hostname = config.networking.hostName;

  mkVHost = name: proxy: {
    locations."/" = {
      proxyPass = "http://localhost:${toString proxy.port}";
      proxyWebsockets = proxy.websockets;

      extraConfig = lib.optionalString proxy.websockets ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
      '';
    };
  };

in
{
  options.lux.reverseProxy = {
    enable = lib.mkEnableOption "reverse proxy";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "${hostname}.local";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            port = lib.mkOption {
              type = lib.types.int;
            };

            websockets = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts = lib.mapAttrs (
      name: proxy:
      mkVHost name proxy
      // {
        serverName = "${name}.${cfg.domain}";
      }
    ) cfg.services;

    services.dnsmasq = {
      settings = {
        cname = lib.mapAttrsToList (name: _: "${name}.${cfg.domain},${cfg.domain}") cfg.services;
      };
    };
  };
}
