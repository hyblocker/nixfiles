{
  pkgs,
  pkgs-stable,
  lib,
  config,
  ...
}:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lux = {
    packages = with pkgs; [
      # gui
      prismlauncher
      peazip
      parsec-bin
      spotify
      # wireshark # broken in nixpkgs for now
      kdePackages.kate
      thunderbird-latest-unwrapped
      vrcx
      scrcpy

      # WE GAMING
      unnamed-sdvx-clone
      parsec-bin

      # this will be so fucking funny if it worked
      pkgs-stable.sdvx7
      qjackctl

      stremio-linux-shell
    ];
  };

  # sdvx requires 44100Hz sample rate
  services.pipewire = {
    # force disable hands free mode
    wireplumber = {
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];
    };
  };

  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        httpie
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        cascadia-code
        signal-desktop
        blender
        streamcontroller
        fluxpose
      ];
      fonts.fontconfig.enable = true;
    };
}
