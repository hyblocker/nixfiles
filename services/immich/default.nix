{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  services.immich = {
    enable = true;
    disableTelemetry = true;
    disableUpdateCheck = true;
    disableGettingStartedOverride = true;
    port = 2283;
  };
}