{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib;
{
  options.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the greetd display manager
      '';
    };
  };

  config = mkIf config.greetd.enable {
    environment.etc."greetd/tuigreet-config.toml".source = ./config.toml;

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'start-hyprland' --config /etc/greetd/tuigreet-config.toml";
            user = "greeter";
          };
        };
      };
    };

    environment.systemPackages = [ pkgs.tuigreet ];
  };
}
