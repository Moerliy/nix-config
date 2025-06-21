{
  pkgs,
  config,
  lib,
  vars,
  host,
  ...
}: let
  patchedYuck =
    pkgs.replaceVars
    ./config/eww.yuck
    {
      monitor = host.mainMonitorNumber;
    };
  # if ./config/secrets exists, add it to the configFilesToLink
  configFilesToLink = {
    "eww-which-key/eww.scss" = ./config/eww.scss;
    "eww-which-key/eww.yuck" = patchedYuck;
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
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
        home.packages = with pkgs; [
          jq
        ];
      };
    };
  }
