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
    "starship.toml" = ./preset.toml;
    "starship-zsh.toml" = ./preset-zsh.toml;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.starship = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Enable starship prompt
        '';
      };
    };

    config = mkIf config.starship.enable {
      home-manager.users.${vars.user} = {
        programs = {
          starship = {
            enable = true;
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
