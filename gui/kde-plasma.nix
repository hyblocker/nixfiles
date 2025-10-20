{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml"; # @FIXME: TEMP
  stylix.icons.enable = true;
  stylix.icons.package = pkgs.hatterIcons;
  stylix.icons.dark = "Hatter-dark";
  stylix.icons.light = "Hatter-light";
}
