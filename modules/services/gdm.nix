#
#  grub display manager
#
{
  config,
  lib,
  ...
}:
with lib; {
  options.gdm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable the grub display manager
        '';
    };
  };

  config = mkIf config.gdm.enable {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
    # Configure keymap in X11
    services.xserver.xkb.layout = "de";
  };
}
