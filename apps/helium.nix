{
  config,
  pkgs,
  ...
}:
{
  programs.helium = {
    enable = true;

    flags = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization"
      "--disable-features=UseChromeOSDirectVideoDecoder,WaylandWpColorManagerV1"
      "--enable-accelerated-video-decode"
      "--enable-gpu-rasterization"
      "--use-gl=egl"
      "--no-default-browser-check"
      "--show-avatar-button=never"
    ];

    policies = {
      # 5 = Open New Tab Page
      # 1 = Restore the last session
      # 4 = Open a list of URLs
      # 6 = Open a list of URLs and restore the last session
      "RestoreOnStartup" = 1;
      # "RestoreOnStartupURLs" = [];

      # 0 = Predict network actions on any network connection
      # 2 = Do not predict network actions on any network connection
      "NetworkPredictionOptions" = 0;

      "AIModeSettings" = 1; # fuck gen ai
      "DevToolsGenAiSettings" = 2;
      "GenAIInlineImageSettings" = 2;
      "GenAIPhotoEditingSettings" = 2;
      "GenAISmartGroupingSettings" = 2;
      "GenAIVcBackgroundSettings" = 2;
      "GenAIWallpaperSettings" = 2;
      "GenAiChromeOsSmartActionsSettings" = 2;
      "GenAILocalFoundationalModelSettings" = 1;
      "GenAiDefaultSettings" = 2;
      "HelpMeReadSettings" = 2;
      "HelpMeWriteSettings" = 2;
      "HistorySearchSettings" = 2;
      "SearchContentSharingSettings" = 1;
      "SmartTabSharingSettings" = 1;
      "TabCompareSettings" = 2;
      "ThirdPartyAiChatSettings" = 1;
      "VoiceTypingSettings" = 2;
      "AutofillPredictionSettings" = 2;
      "ChromeSuggestionsSettings" = 1;
      "CreateThemesSettings" = 2;
      "FindsSettings" = 2;
      "GeminiActOnWebAllowedForURLs" = [ ];
      "GeminiActOnWebSettings" = 1;
      "GeminiSettings" = 1;
      "GeminiSparkSettings" = 1;
      "BrowserSignin" = 0;
      "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "SyncDisabled" = true;

      DefaultBrowserSettingEnabled = false;
      DeveloperToolsAvailability = 1;

      "HttpsOnlyMode" = "force_enabled";
      "MemorySaverModeSavings" = 1;
      "SearchSuggestEnabled" = true;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "en-GB"
      ];

      SigninAllowed = false;

      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      SafeBrowsingEnabled = false;
      MetricsReportingEnabled = false;
      SpellCheckServiceEnabled = false;
      DefaultCookiesSetting = 1;
      DefaultGeolocationSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultPopupsSetting = 2;

      DnsOverHttpsMode = "automatic";

      ExtensionInstallForcelist = [
        "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      ];
    };
  };
}
