#
#  Rofi window switcher, application launcher and dmenu replacement
#
{
  config,
  lib,
  vars,
  ...
}:
with lib; {
  options.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable rofi a window switcher, application launcher and dmenu replacement.
        '';
    };
  };

  config = mkIf config.rofi.enable {
    home-manager.users.${vars.user} = {
      programs = {
        rofi = {
          enable = true;
          cycle = true;
          terminal = "\${pkgs.${vars.terminal}}/bin/${vars.terminal}";
          font = "JetBrainsMono Nerd Font";
        };
      };
    };
  };
}
