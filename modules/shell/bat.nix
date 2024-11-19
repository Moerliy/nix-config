#
#  Git
#
{
  config,
  lib,
  vars,
  pkgs,
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
    home-manager.users.${vars.user} = {
      programs = {
        bat = {
          enable = true;
          package = pkgs.bat;
          themes = {
            catppuccin-mocha = {
              src = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "bat";
                rev = "main";
                sha256 = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
              };
              file = "/themes/Catppuccin Mocha.tmTheme";
            };
          };
        };
      };
      home.packages = with pkgs; [
      ];
    };
  };
}
