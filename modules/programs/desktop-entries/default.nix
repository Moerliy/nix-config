#
#  Desktop entrys configuration for home-manager
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
let
  homeFilesToLink = {
    ".local/share/applications/scanner.desktop" = ./scanner.desktop;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: { source = dotfilesPath; };
in
with lib;
{
  options.desktop-entries = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable desktop entries configuration for home-manager.
      '';
    };
  };

  config = mkIf config.desktop-entries.enable {
    home-manager.users.${vars.user} = {
      home.file = pkgs.lib.attrsets.mapAttrs toSource homeFilesToLink;
    };
  };
}
