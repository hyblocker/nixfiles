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
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_MENU_PREFIX = "plasma-"; # fixes dolphin not finding mime-types
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    nautilus
    xwayland-satellite-unstable
    playerctl
    brightnessctl
    fuzzel
    mako # notification daemon
    polkit_gnome # sudo gui
  ];

  # polkit systemd setup https://yalter.github.io/niri/Important-Software.html#authentication-agent
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "gnome-polkit-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # pls boot into niri on cold boot :3
  services.displayManager.defaultSession = "niri";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.niri.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome-flashback}/libexec/seahorse/ssh-askpass";

  boot.initrd.systemd.enable = true;
  # Give SDDM permission to read LUKS password for autologin
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-shana
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "shana"
          "gtk"
        ];
      };
      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = [ "shana" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "shana" ];
      };
    };
  };

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
        settings.xwayland-satellite = {
          enable = true;
          path = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite";
        };
      };
    };
}
