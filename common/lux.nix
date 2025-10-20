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

  home-manager.users.lux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        httpie
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        cascadia-code
        mission-center
        #(pkgs.callPackage ../pkgs/icons/hatter-icons.nix)
        hatterIcons
      ];
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];
      programs.nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;
        config = {
          enableReactDevtools = true;
          autoUpdate = true;
          autoUpdateNotification = true;
          useQuickCss = true;
          transparent = true;
          plugins = {
            betterGifAltText.enable = true;
            callTimer.enable = true;
            consoleShortcuts.enable = true;
            experiments.enable = true;
            fakeProfileThemes.enable = true;
            fixImagesQuality.enable = true;
            fixSpotifyEmbeds.enable = true;
            fixYoutubeEmbeds.enable = true;
            fullSearchContext.enable = true;
            mentionAvatars.enable = true;
            noDevtoolsWarning.enable = true;
            noF1.enable = true;
            reactErrorDecoder.enable = true;
            sortFriendRequests.enable = true;
            spotifyCrack.enable = true;
            themeAttributes.enable = true;
            unindent.enable = true;
            unlockedAvatarZoom.enable = true;
            userMessagesPronouns.enable = true;
            USRBG.enable = true;
            validUser.enable = true;
            viewIcons.enable = true;
            voiceChatDoubleClick.enable = true;
            volumeBooster.enable = true;
            youtubeAdblock.enable = true;
            webKeybinds.enable = true;
          };
        };
        quickCss = ''
          ${lib.fileContents ./vencord.css}
        ''; # import for css linting etc to be avail lol
      };
    };

}
