{
  config,
  lib,
  vars,
  pkgs,
  ...
}: let
  # if ./config/secrets exists, add it to the configFilesToLink
  configFilesToLink = {
    ".local/bin" = ./bin;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.custom-scripts = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable a custom scripts.
          '';
      };
    };

    config = mkIf config.custom-scripts.enable {
      home-manager.users.${vars.user} = {
        programs.zsh.enable = true;
        programs.bash.enable = true;
        home = {
          packages = with pkgs; [
            fzf
            alejandra
            libnotify
            pamixer
            jq
          ];
          # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
          file = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
          sessionPath = ["$HOME/.local/bin"];
        };
      };
    };
  }
