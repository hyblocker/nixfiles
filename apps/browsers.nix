{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        # "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        # "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        # "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        # "--ignore-gpu-blocklist"
        # "--enable-zero-copy"
        "--disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
      ];

    })
  ];
  programs.chromium = {
    enable = true;
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "en-GB"
      ];
    };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      # "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    ];
  };

  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs = {
        firefox = {
          enable = true;
          languagePacks = [ "en-GB" ];
          policies = {
            DisablePocket = true;
            DisableFirefoxStudies = true;
            DisableFeedbackCommands = true;
            DisableMasterPasswordCreation = true;
            DisableTelemetry = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;

            Extensions = {
              Install = [
                "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/deadname-remover/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
              ];
            };
            FirefoxHome = {
              SponsoredTopSites = false;
              Pocket = false;
              SponsoredPocker = false;
            };
            Preferences = {
              general.smoothScroll = true;
              browser.search.region = "GB";
              browser.startup.page = 3; # restore previous tabs
              trailhead.firstrun.didSeeAboutWelcome = true;
              # make firefox not mess with pipewire
              media.getusermedia.agc = 0;
              media.getusermedia.agc2_forced = false;
              media.getusermedia.agc_enabled = false;
              # use KDE file picker
              widget.use-xdg-desktop-portal.file-picker = 1;
            };
          };
        };
      };
    };
}
