#
#  Better Discord
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
{
  options.vesktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable Vesktop, a better Discord client for Linux.
      '';
    };
  };

  config = mkIf config.vesktop.enable {
    home-manager.users.${vars.user} = {
      catppuccin.vesktop = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
      };
      programs = {
        vesktop = {
          enable = true;
          package = pkgs.vesktop;
          vencord = {
            settings = {
              autoUpdate = false;
              autoUpdateNotification = false;
              useQuickCss = true;
              eagerPatches = false;
              enableReactDevtools = false;
              frameless = false;
              transparent = false;
              winCtrlQ = false;
              disableMinSize = true;
              winNativeTitleBar = false;
              plugins = {
                FakeNitro.enabled = true;
                AccountPanelServerProfile.enabled = true;
                ClearURLs.enabled = true;
                CopyFileContents.enabled = true;
                CopyStickerLinks.enabled = true;
                Dearrow.enabled = true;
                FavoriteEmojiFirst.enabled = true;
                FavoritGifSearch.enabled = true;
                FixYoutubetEmbeds.enabled = true;
                FriendsSince.enabled = true;
                GameActivityToggle.enabled = true;
                GifPaste.enabled = true;
                ImageFilename.enabled = true;
                IrcColors.enabled = true;
                MentionAvatars.enabled = true;
                MessageLinkEmbeds.enabled = true;
                petpet.enabled = true;
                PreviewMessage.enabled = true;
                ReadAllNotificationButton.enabled = true;
                ReplyTimestamp.enabled = true;
                ShikiCodeblocks = {
                  enabled = true;
                  theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/catppuccin-mocha.json";
                  tryHljs = "PRIMARY";
                  useDevIcon = "GREYSCALE";
                  bgOpacity = 100;
                };
                ShowMeYourName.enabled = true;
                SilenmMessageToggle.enabled = true;
                SilentTyping.enabled = true;
                Translate = {
                  enabled = true;
                  showChatBarButton = true;
                  service = "deepl";
                  deeplApiKey = "";
                  autoTranslate = false;
                  showAutoTranslateTooltip = true;
                  receivedInput = "";
                  receivedOutput = "en-us";
                  sentInput = "";
                  sentOutput = "en-us";
                };
                UserVoiceShow.enabled = true;
                ViewRaw.enabled = true;
                VoiceMessages.enabled = true;
                WhoReacted.enabled = true;
                YoutubeAdblock.enabled = true;
              };
            };
          };
          settings = {
            discordBranch = "stable";
            minimizeToTray = true;
            arRPC = true;
            spellCheckLanguages = [
              "en-US"
              "en"
            ];
            hardwareAcceleration = true;
            checkUpdates = false;
            disableMinSize = true;
            tray = true;
            splashTheming = true;
          };
        };
      };
    };
  };
}
