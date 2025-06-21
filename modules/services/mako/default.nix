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
        description = mdDoc ''
          Enable mako the notification daemin.
        '';
      };
    };

    config = mkIf config.mako.enable {
      home-manager.users.${vars.user} = {
        services = {
          mako = {
            enable = true;
            settings = {
              default-timeout = 3500;
              progress-color = "#313244";
              border-color = "#cba6f7";
              text-color = "#cdd6f4";
              background-color = "#1e1e2e";
              anchor = "top-right";
            };
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
