#
#  GTK theming
#
{
  config,
  lib,
  vars,
  pkgs,
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
          name = "Catppuccin-Mocha-Compact-Mauve-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = ["mauve"];
            size = "compact";
            variant = "mocha";
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Catppuccin-Mocha-Dark-Cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
        };
        font = {
          name = "JetBrainsMono Nerd Font";
        };
      };
      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark-Cursors";
        size = 64;
      };
    };
  };
}
