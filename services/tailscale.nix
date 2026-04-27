{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";

    extraSetFlags = [
      "--advertise-exit-node"
    ];
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}