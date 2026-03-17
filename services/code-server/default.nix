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
    port = 4444;
  };
  networking.firewall.allowedTCPPorts = [ 4444 ];
}