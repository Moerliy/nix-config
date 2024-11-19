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
with lib; {
  options.qt-theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
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
          name = "kvantum";
          package = pkgs.catppuccin-kvantum.override {
            variant = "mocha";
            accent = "mauve";
          };
        };
      };
    };
    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };
}
