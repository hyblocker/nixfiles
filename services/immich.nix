{ config, pkgs, lib, ... }:

let
  immich_port = 2283;
in
{
  services.immich = {
    enable = true;
    openFirewall = true;
    port = immich_port;
  };

  lux.reverseProxy = {
    enable = true;

    proxies.immich = {
      port = immich_port;
      path = "/immich";
    };
  };
}