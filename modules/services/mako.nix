#
#  Mako the notification daemon
#
{
  config,
  lib,
  vars,
  ...
}:
with lib; {
  options.mako = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable mako the notification daemin.
        '';
    };
  };

  config = mkIf config.mako.enable {
    home-manager.users.${vars.user} = {
      services = {
        mako = {
          enable = true;
          anchor = "bottom-right";
          backgroundColor = "#1e1e2e";
          textColor = "#cdd6f4";
          borderColor = "#8839ef";
          progressColor = "#313244";
          defaultTimeout = 3500;
        };
      };
    };
  };
}
