#
#  lightweight display manager
#
{
  config,
  lib,
  ...
}:
with lib;
{
  options.ly = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the ly display manager
      '';
    };
  };

  config = mkIf config.ly.enable {
    services = {
      displayManager.ly = {
        enable = true;
        x11Support = true;
      };
    };
  };
}
