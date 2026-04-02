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
        settings = {
          auth_fails = 3; # special animation looks broken?
          animation = "gameoflife"; # "doom", "matrix", "colormix"
          animation_timeout_sec = 300; # 5 minutes
          full_color = true;
          bg = "0x021E1E2E";
          fg = "0x01CDD6F4";
          error_bg = "0x021E1E2E";
          error_fg = "0x01F38BA8";
          border_fg = "0x01CBA6F7";
          gameoflife_fg = "0x0074C7EC";
          gameoflife_frame_delay = 6;
          box_title = "null"; # text above the box
          clear_password = true;
          clock = "%A, %d.%m.%y @ %H:%M:%S";
          default_input = "password";
          hide_borders = false;
          hide_version_string = false;
          hide_key_hints = false;
          input_len = 69;
          lang = "en";
          load = true;
          save = true;
          vi_default_mode = "insert";
          vi_mode = true;
        };
      };
    };
  };
}
