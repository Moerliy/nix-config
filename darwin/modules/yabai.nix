#
#  Tiling Window Manager for MacOS
#  Enable with "yabai.enable = true;"
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  options.yabai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Tiling Window Manager for MacOS
      '';
    };
  };

  config = mkIf config.yabai.enable {
    environment.systemPackages = with pkgs; [
      jankyborders
    ];
    services = {
      yabai = {
        enable = true;
        enableScriptingAddition = true;
        package = pkgs.yabai;
        config = {
          layout = "bsp";
          external_bar = "all:40:0";
          auto_balance = "off";
          split_ratio = "0.50";
          window_border = "on";
          window_border_width = "2";
          window_placement = "second_child";
          window_shadow = "float";
          window_opacity = "on";
          window_opacity_duration = "0.2";
          active_window_opacity = "1.0";
          normal_window_opacity = "0.8";
          window_animation_duration = "0.5";
          window_animatiom_easing = "ease_out_quint";
          insert_feedback_color = "0xff9dd274";
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          top_padding = "8";
          bottom_padding = "8";
          left_padding = "8";
          right_padding = "8";
          window_gap = "10";
        };
        extraConfig = ''
          # Enable border for active window (jankyboarders)
          borders style=round active_color=0xffe1e3e4 inactive_color=0xff494d64 background_color=0x302c2e34 width=6.0 hidpi off &

          # Exclude problematic apps from being managed:
          yabai -m rule --add app="^(LuLu|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor)$" manage=off
          yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
          yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
          yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
          yabai -m rule --add label="Select file to save to" app="^Inkscape$" title="Select file to save to" manage=off
          yabai -m rule --add title='Preferences' manage=off layer=above
          yabai -m rule --add title='^(Opening)' manage=off layer=above
          yabai -m rule --add title='Library' manage=off layer=above
          yabai -m rule --add app='^System Preferences$' manage=off layer=above
          yabai -m rule --add app='Activity Monitor' manage=off layer=above
          yabai -m rule --add app='Finder' manage=off layer=above
          yabai -m rule --add app='^System Information$' manage=off layer=above
        '';
      };
    };
  };
}
