{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ]; # Enable proton ge for better game compat
    };
  };

  # Hardware support
  hardware.steam-hardware.enable = true;
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
  hardware.opentabletdriver.enable = true;
  services.udev.packages = [ pkgs.dolphin-emu ]; # dolphin gamecube controller udev rules

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
