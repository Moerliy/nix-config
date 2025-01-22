#
#
# Starship prompt
# https://starship.rs/
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
    "neofetch/config.conf" = ./dotfetch.conf;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.neofetch = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable neofetch config.
          '';
      };
    };

    config = mkIf config.neofetch.enable {
      home.packages = with pkgs; [
        neofetch
      ];
      # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
      xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
    };
  }
