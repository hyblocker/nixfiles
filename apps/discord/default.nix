{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;
        vesktop.useSystemVencord = false;
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
            usrbg.enable = true;
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
