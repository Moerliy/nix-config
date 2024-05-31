#
#
# Wallpapers
#
#
{
  lib,
  pkgs,
  config,
  vars,
  ...
}: let
  configFilesToLink = {
    "wallpaper.png" = ./wallpaper.png;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.wallpaper = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable wallpaper
          '';
      };
    };

    config = mkIf config.wallpaper.enable {
      home-manager.users.${vars.user} = {
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
