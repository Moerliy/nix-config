{
  pkgs,
  config,
  lib,
  vars,
  ...
}: let
  # if ./config/secrets exists, add it to the configFilesToLink
  configFilesToLink = {
    "eww/eww.yuck" = ./config/eww.yuck;
    "nvim/eww.scss" = ./config/eww.scss;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.eww = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable eww configuration.
          '';
      };
    };

    config = mkIf config.eww.enable {
      home-manager.users.${vars.user} = {
        programs = {
          eww = {
            enable = true;
            configDir = ./config;
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        # xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
