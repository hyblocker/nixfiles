{ config, lib, pkgs, ... }:

let
  cfg = config.lux.reverseProxy;
  hostname = config.networking.hostName;
  mkVHost = name: proxy: {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString proxy.port}";
      proxyWebsockets = proxy.websockets;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '' + lib.optionalString proxy.websockets ''
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_read_timeout 86400s;
        proxy_send_timeout 86400s;
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
        forceSSL = false;
      }
    ) cfg.services;

    services.dnsmasq = {
      settings = {
        cname = lib.mapAttrsToList (name: _: "${name}.${cfg.domain},${cfg.domain}") cfg.services;

        # fallback dns
        server = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
        ];
        domain-needed = true;
        bogus-priv = true;
        interface = [ "wlo1" "tailscale0" ];
        interface-name = "${cfg.domain},tailscale0";
        address = [ "/${cfg.domain}/100.75.140.47" ];
        bind-dynamic = true;
      };
    };
  };
}
