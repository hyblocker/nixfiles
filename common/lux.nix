{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  nix.settings.trusted-users = [ "@wheel" ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lux = {
    initialPassword = "password";
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

      ffmpeg
      yt-dlp
    ];
  };

  # yubikey udev rules
  services.udev.packages = [ pkgs.yubikey-personalization ];

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
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        cascadia-code
        mission-center
        whitesur-icon-theme
        hatter-icons
        papirus-icon-theme
        fluxpose
      ];
    };

  # Enable bitmap font rendering (icons aka emojis)
  fonts.fontconfig.useEmbeddedBitmaps = true;

}
