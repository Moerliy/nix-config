#
#  Git
#
{
  config,
  lib,
  vars,
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
    };
  };
}
