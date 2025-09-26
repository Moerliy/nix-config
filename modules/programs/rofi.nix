#
#  Rofi window switcher, application launcher and dmenu replacement
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
  options.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable rofi a window switcher, application launcher and dmenu replacement.
      '';
    };
  };

  config = mkIf config.rofi.enable {
    home-manager.users.${vars.user} = {
      programs = {
        rofi = {
          enable = true;
          package = pkgs.rofi;
          cycle = true;
          terminal = "\${pkgs.${vars.terminal}}/bin/${vars.terminal}";
          font = "JetBrainsMono Nerd Font";
          theme = "${pkgs.catppuccin}/rofi/catppuccin-macchiato.rasi";
          extraConfig = {
            modi = "run,drun,window";
            icon-theme = "Oranchelo";
            show-icons = true;
            drun-display-format = "{icon} {name}";
            location = 0;
            disable-history = false;
            hide-scrollbar = true;
            display-drun = "   Apps ";
            display-run = "   Run ";
            display-window = "   Window";
            display-Network = " 󰤨  Network";
            sidebar-mode = true;
          };
        };
      };
    };
  };
}
