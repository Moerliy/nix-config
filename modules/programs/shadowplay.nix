#
#  Shadowpay like screen recording
#
{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib;
{
  options.shadowplay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable Shadowpay like screen recording.
      '';
    };
  };

  config = mkIf config.shadowplay.enable {
    programs = {
      gpu-screen-recorder = {
        enable = true;
      };
    };
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    };
  };
}
