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
  # disable sleeping when closing lid
  # https://discourse.nixos.org/t/prevent-laptop-from-suspending-when-lid-is-closed-if-on-ac/12630/6

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "eric";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # enable mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
  };

  # enable nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."${domain}" = {
      addSSL = false;
      forceSSL = false;
      enableACME = false;
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}