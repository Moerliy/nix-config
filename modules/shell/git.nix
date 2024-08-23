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
          userName = "Moritz Gleissner";
          userEmail = "moritz@gleissner.de";
        };
      };
      home.packages = with pkgs; [
        lucky-commit
      ];
    };
  };
}
