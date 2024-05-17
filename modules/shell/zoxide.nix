#
#  Better cd
#

{ config, lib, vars, ... }:

with lib;
{
  options.zoxide = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc
        ''
        Enable zoxide, a faster way to navigate your filesystem.
        '';
    };
  };

  config = mkIf config.zoxide.enable {
    home-manager.users.${vars.user} = {
      programs = {
        zoxide = {
          enable = true;
          enableZshIntegration = true;
          enableFishIntegration = true;
          options = [ "--cmd cd" ];
        };
      };
    };
  };
}
