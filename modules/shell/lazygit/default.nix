#
#
# Lazygit
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
    "lazygit/config.yml" = ./config.yaml;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.lazygit = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable lazygit
          '';
      };
    };

    config = mkIf config.lazygit.enable {
      home-manager.users.${vars.user} = {
        programs = {
          lazygit = {
            enable = true;
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
        home.packages = with pkgs; [
          commitizen
          # gptcommit
        ];
      };
    };
  }
