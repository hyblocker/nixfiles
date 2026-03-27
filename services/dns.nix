{
  config,
  lib,
  ...
}:
let
  hostname = config.networking.hostName;
  domain = "${hostname}.local";
in
{
  services.dnsmasq = {
    enable = true;

    settings = {
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  # allow dns queries
  networking.firewall.allowedUDPPorts = [ 53 ];
}
