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
    openFirewall = true;
    port = 2283;
  };
}