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
  networking.firewall.allowedTCPPorts = [ 9093 ];

  nix.settings.trusted-users = [ "@wheel" ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lux = {
    packages = with pkgs; [
      # gui
      prismlauncher
      peazip
      parsec-bin
      spotify
      wireshark
      kdePackages.kate
      thunderbird-latest-unwrapped
      vrcx

      # cli
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

      # WE GAMING
      unnamed-sdvx-clone
      parsec-bin

      # this will be so fucking funny if it worked
      pkgs-stable.sdvx7
      qjackctl
    ];
  };

  # yubikey udev rules
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # sdvx requires 44100Hz sample rate
  services.pipewire = {
    extraConfig.pipewire."92-samplerates" = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.allowed-rates" = [ 44100 ];
      };
    };
    # low latency
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
      };
    };
  };

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
        fluxpose

        # hytale-launcher # pending https://github.com/NixOS/nixpkgs/pull/479368/
      ];
    };

  # Enable bitmap font rendering (icons aka emojis)
  fonts.fontconfig.useEmbeddedBitmaps = true;

}
