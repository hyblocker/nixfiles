{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri-unstable;

  programs.niri.enable = true;
  environment.variables.NIXOS_OZONE_WL = "1";
  environment.variables.QT_QPA_PLATFORMTHEME = "gtk3";
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    nautilus
    xwayland-satellite-unstable
    xdg-desktop-portal-shana
    playerctl
    brightnessctl
    fuzzel
    mako # notification daemon
  ];

  # pls boot into niri on cold boot :3
  services.displayManager.defaultSession = "niri";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # The default /etc/pam.d/sddm-autologin doesn't invoke auth pam_kwallet5.so
  # Thus we need to manually do it with auth include sddm
  security.pam.services.sddm-autologin.text = pkgs.lib.mkBefore ''
    auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
    auth include sddm
  '';
  boot.initrd.systemd.enable = true;
  # Give SDDM permission to read LUKS password for autologin
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";

  imports = [
    ./noctalia.nix
  ];

  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs.niri = {
        config = ''
          ${lib.fileContents ./niri-config.kdl}
        '';
      };
    };
}
