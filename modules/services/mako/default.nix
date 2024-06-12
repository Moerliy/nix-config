#
#  Mako the notification daemon
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}: let
  configFilesToLink = {
    "mako/icons" = ./icons;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.mako = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable mako the notification daemin.
          '';
      };
    };

    config = mkIf config.mako.enable {
      home-manager.users.${vars.user} = {
        services = {
          mako = {
            enable = true;
            anchor = "top-right";
            backgroundColor = "#1e1e2e";
            textColor = "#cdd6f4";
            borderColor = "#8839ef";
            progressColor = "#313244";
            defaultTimeout = 3500;
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
