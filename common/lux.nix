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
      # vesktop
      parsec-bin
      spotify
      wireshark
      kdePackages.kate
      thunderbird-latest-unwrapped

      # cli
      wget
      clang-tools
      nil
      nixfmt
      dig
      file
      nmap
      htop
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
        cascadia-code
        mission-center
        (pkgs.callPackage ../pkgs/icons/hatter-icons.nix { })
        whitesur-icon-theme
      ];
    };

}
