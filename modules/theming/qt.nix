#
#  QT theming
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
{
  options.qt-theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the qt theme.
      '';
    };
  };

  config = mkIf config.qt-theme.enable {
    home-manager.users.${vars.user} = {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style = {
          name = "gtk2";
        };
      };
      home.packages = with pkgs; [
        libsForQt5.qt5ct
      ];
    };
    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };
}
