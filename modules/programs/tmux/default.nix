#
#  Terminal multiplexer
#
{
  pkgs,
  vars,
  ...
}: let
  configFilesToLink = {
    "tmux/config.yaml" = ./config/config.yaml;
    "tmux/statusline.conf" = ./config/statusline.conf;
    "tmux/tmux.conf" = ./config/tmux.conf;
    "tmux/utility.conf" = ./config/utility.conf;
    "tmux/util" = ./config/util;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in {
  environment = {
    systemPackages = with pkgs; [
    ];
  };
  home-manager.users.${vars.user} = {
    xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
    programs = {
      tmux = {
        enable = true;
      };
    };
  };
}
