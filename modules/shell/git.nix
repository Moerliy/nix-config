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
  options.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable the Git package.
        '';
    };
  };

  config = mkIf config.git.enable {
    home-manager.users.${vars.user} = {
      programs = {
        git = {
          enable = true;
        };
      };
      home.packages = with pkgs; [
        lucky-commit
      ];
    };
  };
}
