#
#  Git
#
{
  config,
  lib,
  vars,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options.bat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable the Bat package.
        '';
    };
  };

  config = mkIf config.bat.enable {
    programs = {
      bat = {
        enable = true;
        package = pkgs.bat;
        themes = {
          catppuccin-mocha = {
            src = inputs.bat-catppuccin;
            file = "/themes/Catppuccin Mocha.tmTheme";
          };
        };
      };
    };
    home.packages = with pkgs; [
    ];
  };
}
