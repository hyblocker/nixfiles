{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # --- boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- security ---
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    busybox
    android-tools
  ];

  # --- User account ---
  users.groups.realtime = { };
  users.users.lux = {
    # note: set a password with 'passwd'
    isNormalUser = true;
    description = "lux";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "realtime"
      "audio"
    ];
  };

  # for audio shit (jack / ASIO)
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
  ];

  # --- hardware acceleration ---
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # --- locale / timezone ---
  time.timeZone = "Europe/Malta";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "mt_MT.UTF-8";
    LC_MONETARY = "mt_MT.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "mt_MT.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "mt_MT.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # --- Nix ---
  nixpkgs = {
    config = {
      allowUnfreePredicate = _: true;
      allowUnfree = true;
    };
  };
  programs.nix-ld.enable = true; # Make it easier to run Steam crap
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11"; # Did you read the comment?

  # --- minimise old generations ---
  boot.loader.systemd-boot.configurationLimit = 35;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # --- Home Manager ---
  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.username = "lux";
      home.homeDirectory = "/home/lux";
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";
}
