#
#  grub display manager
#
{
  config,
  lib,
  ...
}:
with lib;
{
  options.gdm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the grub display manager
      '';
    };
  };

  config = mkIf config.gdm.enable {
    # Enable the X11 windowing system.
    services = {
      xserver = {
        enable = true;
        xkb.layout = "de";
      };
      displayManager.gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };
  };
}
