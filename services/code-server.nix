{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  hostname = config.networking.hostName;
  domain = "${hostname}.local";
in
{
  services.code-server = {
    enable = true;
    disableTelemetry = true;
    disableUpdateCheck = true;
    disableGettingStartedOverride = true;
    extraGroups = [ "users" ];
    host = "0.0.0.0";
    port = 4444;
  };
  networking.firewall.allowedTCPPorts = [ 4444 ];

  # reverse proxy
  services.nginx.virtualHosts."${domain}".locations."/code" = {
    proxyPass = "http://127.0.0.1:4444";
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
    '';
  };
}