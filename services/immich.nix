{
  config,
  pkgs,
  inputs,
  lib,
  homelab,
  ...
}:

let
  hostname = config.networking.hostName;
  domain = "${hostname}.local";
  immich_port = 2283;
{
  services.immich = {
    enable = true;
    openFirewall = true;
    # host = "0.0.0.0";
    port = immich_port;
  };

  # reverse proxy
  # services.nginx.virtualHosts."${domain}".locations."/immich" = {
  #   proxyPass = "http://127.0.0.1:2283";
  #   proxyWebsockets = true;
  #   extraConfig = ''
  #     proxy_set_header Upgrade $http_upgrade;
  #     proxy_set_header Connection "upgrade";
  #   '';
  # };
  imports = [
    (homelab.mkServiceProxy "/immich" immich_port)
  ];
}