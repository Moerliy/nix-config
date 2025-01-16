#
#  GTK theming
#
{
  config,
  lib,
  vars,
  pkgs,
  pkgs-stable,
  ...
}:
with lib; {
  options.gtk-theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable the gtk theme.
        '';
    };
  };

  config = mkIf config.gtk-theme.enable {
    home-manager.users.${vars.user} = {
      gtk = {
        enable = true;
        theme = {
          name = "Kanagawa-B";
          package =
            pkgs.kanagawa-gtk-theme.override {
            };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "catppuccin-mocha-dark-cursors";
          package = pkgs-stable.catppuccin-cursors.mochaDark;
        };
        font = {
          name = "JetBrainsMono Nerd Font";
        };
      };
      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs-stable.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 18;
      };
    };
  };
}
