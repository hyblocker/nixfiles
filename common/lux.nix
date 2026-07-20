{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 9093 ];

  nix.settings.trusted-users = [ "@wheel" ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lux = {
    packages = with pkgs; [
      # cli
      age
      sops
      wget
      nil
      nixfmt
      dig
      file
      nmap
      htop
      p7zip

      ffmpeg
      yt-dlp
    ];
  };

  # yubikey udev rules
  services.udev.packages = [ pkgs.yubikey-personalization ];

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true; # battery life

      # Spoof Apple host (VID 0x004C) over the DID profile so AirPods and
      # other Apple-aware peripherals expose battery and gesture features
      # otherwise gated to Apple hosts.
      DeviceID = "bluetooth:004C:0000:0000";
    };
  };

  # Disable USB autosuspend on Bluetooth radios. The kernel default of 2s
  # autosuspend drops HID-over-GATT peripherals after idle (re-pairing
  # required to recover). Match by USB Wireless Controller class
  # (e0/01/01) so the rule applies to any Bluetooth radio without
  # hardcoding VID/PID. ACTION=="add|change" covers both udevadm trigger
  # (nixos-rebuild switch) and resume-from-sleep events.
  # ENV{DEVTYPE}=="usb_device" is required: udevadm verify rejects bare
  # DEVTYPE==.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{bDeviceClass}=="e0", ATTR{bDeviceSubClass}=="01", ATTR{bDeviceProtocol}=="01", TEST=="power/control", ATTR{power/control}="on"
  '';

  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        httpie
        htop
        mpv
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        cascadia-code
        mission-center
        whitesur-icon-theme
        hatter-icons
        papirus-icon-theme

        # hytale-launcher # pending https://github.com/NixOS/nixpkgs/pull/479368/
      ];
    };

  # Enable bitmap font rendering (icons aka emojis)
  fonts.fontconfig.useEmbeddedBitmaps = true;

  # sops
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
}
