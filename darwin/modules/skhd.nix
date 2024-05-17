#
#  Hotkey Daemon
#  Enable with "skhd.enable = true;"
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  options.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Simple Hotkey Daemon for MacOS
      '';
    };
  };

  config = mkIf config.skhd.enable {
    home-manager.users.${vars.user} = {
      home = {
        packages = with pkgs; [
          kitty
          discord
        ];
      };
    };
    services = {
      skhd = {
        enable = true;
        package = pkgs.skhd;
        skhdConfig = ''
          :: default : borders style=round active_color=0xffcba6f7 inactive_color=0xff6c7086 background_color=0x302c2e34 width=6.0 hidpi off &
          :: main @ : borders active_color=0xfff38ba8 inactive_color=0xff6c7086
          :: open @ : borders active_color=0xffa6e3a1 inactive_color=0xff6c7086
          :: focus @ : borders active_color=0xff74c7ec inactive_color=0xff6c7086
          :: move @ : borders active_color=0xffb4befe inactive_color=0xff6c7086
          :: resize @ : borders active_color=0xfffab387 inactive_color=0xff6c7086
          :: toggle @ : borders active_color=0xfff5c2e7 inactive_color=0xff6c7086

          cmd - space ; main
          main < o ; open
          main < f ; focus
          main < m ; move
          main < r ; resize
          main < t ; toggle
          main < escape ; default
          open < escape ; default
          focus < escape ; default
          move < escape ; default
          resize < escape ; default
          toggle < escape ; default

          move < f ; focus
          focus < m ; move
          
          # open
          open < t : /Users/${vars.user}/Applications/Home\ Manager\ Apps/Kitty.App/Contents/MacOS/kitty --single-instance -d ~
          open < d : open -na /Users/${vars.user}/Applications/Home\ Manager\ Apps/Discord.app
          open < b : /Applications/Firefox.app/Contents/MacOS/firefox

          # Open Terminal
          cmd - return : /Users/${vars.user}/Applications/Home\ Manager\ Apps/Kitty.App/Contents/MacOS/kitty --single-instance -d ~
          cmd - q : yabai -m window --close

          # Toggle Window
          toggle < t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
          toggle < f : yabai -m window --toggle zoom-fullscreen

          # Focus Window
          focus < up : yabai -m window --focus north
          focus < down : yabai -m window --focus south
          focus < left : yabai -m window --focus west
          focus < right : yabai -m window --focus east

          # move Window
          move < up : yabai -m window --swap north
          move < down : yabai -m window --swap south
          move < left : yabai -m window --swap west
          move < right : yabai -m window --swap east

          # Resize Window
          resize < left : yabai -m window --resize left:-50:0 && yabai -m window --resize right:-50:0
          resize < right : yabai -m window --resize left:50:0 && yabai -m window --resize right:50:0
          resize < up : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0
          resize < down : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0

          # Focus Space
          focus < 1 : yabai -m space --focus 1
          focus < 2 : yabai -m space --focus 2
          focus < 3 : yabai -m space --focus 3
          focus < 4 : yabai -m space --focus 4
          focus < 5 : yabai -m space --focus 5
          focus < 6 : yabai -m space --focus 6
          focus < 7 : yabai -m space --focus 7
          focus < 8 : yabai -m space --focus 8
          focus < 9 : yabai -m space --focus 9
          focus < 0 : yabai -m space --focus 10
          focus < shift - left : yabai -m space --focus prev
          focus < shift - right: yabai -m space --focus next

          # move to Space
          move < 1 : yabai -m window --space 1 && yabai -m space --focus 1
          move < 2 : yabai -m window --space 2 && yabai -m space --focus 2
          move < 3 : yabai -m window --space 3 && yabai -m space --focus 3
          move < 4 : yabai -m window --space 4 && yabai -m space --focus 4
          move < 5 : yabai -m window --space 5 && yabai -m space --focus 5
          move < 6 : yabai -m window --space 6 && yabai -m space --focus 6
          move < 7 : yabai -m window --space 7 && yabai -m space --focus 7
          move < 8 : yabai -m window --space 8 && yabai -m space --focus 8
          move < 9 : yabai -m window --space 9 && yabai -m space --focus 9
          move < 0 : yabai -m window --space 10 && yabai -m space --focus 10
          move < shift - left : yabai -m window --space prev && yabai -m space --focus prev
          move < shift - right : yabai -m window --space next && yabai -m space --focus next
        '';
      };
    };
    system = {
      keyboard = {
        enableKeyMapping = true;
      };
    };
  };
}
