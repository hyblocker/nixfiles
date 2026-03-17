{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  services.code-server = {
    enable = true;
    disableTelemetry = true;
    disableUpdateCheck = true;
    disableGettingStartedOverride = true;
    host = "0.0.0.0";
    port = 4444;
  };
  networking.firewall.allowedTCPPorts = [ 4444 ];
}