{
  config,
  pkgs,
  lib,
  ...
}:

let
  immich_port = 2283;
in
{
  services.immich = {
    enable = true;
    openFirewall = true;
    port = immich_port;
    host = "0.0.0.0";
    mediaLocation = "/mnt/storage/immich";
  };

  services.redis.servers."" = {
    enable = true;
  };

  lux.reverseProxy = {
    enable = true;

    services.immich = {
      port = immich_port;
    };
  };
}
