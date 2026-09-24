#
#  HyprLUI's notification-manager daemon - a real org.freedesktop.Notifications
#  D-Bus service (see demos/notification-manager in Hyprhook/HyprLUI),
#  replacing mako. Toggling this just sets the home-manager option
#  services.hyprlui-notification-daemon.enable - the option itself comes
#  from hyprlui.homeManagerModules.default (added to this host's
#  home-manager sharedModules in hosts/default.nix).
#
{
  config,
  lib,
  vars,
  ...
}:
with lib; {
  options.hyprlui-notification-daemon.enable = mkOption {
    type = types.bool;
    default = false;
    description = mdDoc ''
      Enable HyprLUI's notification-manager daemon (a real
      org.freedesktop.Notifications D-Bus service, not just a demo).
    '';
  };

  config = mkIf config.hyprlui-notification-daemon.enable {
    home-manager.users.${vars.user} = {
      services.hyprlui-notification-daemon.enable = true;
    };
  };
}
