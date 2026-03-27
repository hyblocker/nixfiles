{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  code_server_port = 4444;
in
{
  services.code-server = {
    enable = true;
    disableTelemetry = true;
    disableUpdateCheck = true;
    disableGettingStartedOverride = true;
    extraGroups = [ "users" ];
    host = "0.0.0.0";
    port = code_server_port;
  };
  networking.firewall.allowedTCPPorts = [ code_server_port ];

  lux.reverseProxy = {
    enable = true;

    services.code = {
      port = code_server_port;
    };
  };
}
