{
  config,
  pkgs,
  pkgs-stable,
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
      Experimental = true; # battery life
    };
  };

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
  
  sops.age.keyFile = "/home/lux/.config/sops/age/keys.txt";

  sops.secrets."forgejo-runner-token" = {
    owner = "gitea-runner";
    group = "gitea-runner";
  };
}
