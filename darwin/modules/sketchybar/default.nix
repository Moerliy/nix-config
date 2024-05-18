#
#  Top toolbar
#  Enable with "sketchybar.enable = true;"
#
{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib; {
  options.sketchybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Toolbar for MacOS
      '';
    };
  };

  config = mkIf config.sketchybar.enable {
    home-manager.users.${vars.user} = {
      xdg.configFile."sketchybar" = {
        source = ./config;
      };
      home.packages = with pkgs; [
        jankyborders
        lua
        jq
        gh
        sketchybar-app-font
      ];
    };
    homebrew = {
      casks = [
        "sf-symbols"
      ];
      brews = [
        "switchaudio-osx"
      ];
    };
    services = {
      sketchybar = {
        enable = true;
        package = pkgs.sketchybar;
      };
    };
  };
}
