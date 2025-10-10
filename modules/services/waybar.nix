#
#  waybar
#
{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  bar-number = false;
  simplebar = false;
  clock24h = true;

  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  base00 = "#181825";
  base01 = "#181825";
  base03 = "#cba6f7";
  base04 = "#f38ba8";
  base05 = "#cba6f7";
  base07 = "#89b4fa";
  base08 = "#f5c2e7";
  base09 = "#f38ba8";
  base0A = "#fab387";
  base0B = "#a6e3a1";
  base0D = "#585b70";
  base0E = "#cba6f7";
  base0F = "#89b4fa";
in
with lib;
{
  options.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable waybar configuration.
      '';
    };
  };

  config = mkIf config.waybar.enable {
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        pavucontrol
      ];
      services.playerctld.enable = true;
      programs = {
        waybar = {
          enable = true;
          settings = [
            {
              layer = "top";
              position = "top";
              exclusive = true;

              modules-center = [ "hyprland/workspaces" ];
              modules-left = [
                "custom/startmenu"
                "hyprland/window"
                "cpu"
                "memory"
                "disk"
                "power-profiles-daemon"
              ];
              modules-right = [
                "mpris"
                "custom/hyprbindings"
                "custom/exit"
                "idle_inhibitor"
                "network"
                "pulseaudio"
                "battery"
                "clock"
                "tray"
              ];

              "hyprland/workspaces" = {
                format = if bar-number == true then "{name}" else "{icon}";
                format-icons = {
                  "1" = "一";
                  "2" = "二";
                  "3" = "三";
                  "4" = "四";
                  "5" = "五";
                  "6" = "六";
                  "7" = "七";
                  "8" = "八";
                  "9" = "九";
                  "10" = "十";
                  # active = " ";
                };
                on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e+1";
                on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e-1";
              };
              "mpris" = {
                format = "{player_icon} Nothing playing";
                format-playing = "{status_icon} {dynamic}";
                format-paused = "{status_icon} <i>{dynamic}</i>";
                format-stopped = "{status_icon} Nothing playing";
                max-length = 30;
                on-click = "$HOME/.config/rofi/bin/musicmenu";
                on-scroll-up = "playerctl next";
                on-scroll-down = "playerctl previous";
                player-icons = {
                  default = "";
                  mpv = "🎵";
                };
                status-icons = {
                  playing = "";
                  paused = "";
                  stopped = "";
                };
              };
              "clock" = {
                format = if clock24h == true then '' {:%H:%M}'' else '' {:%I:%M %p}'';
                #format = " {:%H:%M}";
                tooltip = true;
                tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
              };
              "hyprland/window" = {
                max-length = 25;
                separate-outputs = false;
              };
              "memory" = {
                interval = 1;
                format = " {}%";
                tooltip = true;
              };
              "cpu" = {
                interval = 1;
                format = " {usage:2}%";
                tooltip = true;
              };
              "disk" = {
                format = " {free}";
                tooltip = true;
              };
              "network" = {
                format-icons = [
                  "󰤯"
                  "󰤟"
                  "󰤢"
                  "󰤥"
                  "󰤨"
                ];
                format-ethernet = " {bandwidthDownOctets}";
                format-wifi = "{icon} {signalStrength}%";
                format-disconnected = "󰤮";
                on-click = "${pkgs.${vars.terminal}}/bin/${vars.terminal} --title 'nmtui-session' -e 'nmtui'";
                tooltip = false;
              };
              "tray" = {
                spacing = 12;
              };
              "pulseaudio" = {
                format = "{icon} {volume}% {format_source}";
                format-bluetooth = "{volume}% {icon} {format_source}";
                format-bluetooth-muted = "  {icon} {format_source}";
                format-muted = "  {format_source}";
                format-source = " {volume}%";
                format-source-muted = "";
                format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
                on-click = "$HOME/.config/rofi/bin/volume";
              };
              "custom/exit" = {
                tooltip = false;
                format = "";
                on-click = "$HOME/.config/rofi/bin/powermenu";
              };
              "custom/startmenu" = {
                tooltip = false;
                format = " ";
                # exec = "rofi -show drun";
                on-click = "${pkgs.rofi}/bin/rofi -show drun";
              };
              "custom/hyprbindings" = {
                tooltip = false;
                format = " Bindings";
                on-click = "sleep 0.1 && $HOME/.local/bin/which-key -b";
              };
              "idle_inhibitor" = {
                start-activated = true;
                format = "{icon}";
                format-icons = {
                  activated = "";
                  deactivated = "";
                };
                tooltip = "true";
              };
              "battery" = {
                interval = 1;
                states = {
                  warning = 25;
                  critical = 10;
                };
                format = "{icon} {capacity}%";
                format-charging = "󰂄 {capacity}%";
                format-plugged = "󱘖 {capacity}%";
                format-icons = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁽"
                  "󰁾"
                  "󰁿"
                  "󰂀"
                  "󰂁"
                  "󰂂"
                  "󰁹"
                ];
                on-click = "";
                tooltip = true;
              };
            }
          ];
          style = concatStrings [
            ''
                   * {
              font-size: 16px;
              font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
                 	font-weight: bold;
                   }
                   window#waybar {
              ${
                if simplebar == true then
                  ''
                    background-color: rgba(26,27,38,0);
                    border-bottom: 1px solid rgba(26,27,38,0);
                    border-radius: 0px;
                    color: ${base0F};
                  ''
                else
                  ''
                    background-color: ${base00};
                    border-bottom: 1px solid ${base00};
                    border-radius: 0px;
                    color: ${base0F};
                  ''
              }
                   }
                   #workspaces {
              ${
                if simplebar == true then
                  ''
                    color: ${base00};
                           background: transparent;
                    margin: 4px;
                    border-radius: 0px;
                    border: 0px;
                    font-style: normal;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 0px 1px;
                    border-radius: 10px;
                    border: 0px;
                    font-style: normal;
                    color: ${base00};
                  ''
              }
                   }
                   #workspaces button {
              ${
                if simplebar == true then
                  ''
                    color: ${base03};
                           background: ${base00};
                    margin: 4px 3px;
                    opacity: 1;
                    border: 0px;
                    border-radius: 15px;
                    transition: ${betterTransition};
                  ''
                else
                  ''
                    padding: 0px 5px;
                    margin: 4px 3px;
                    border-radius: 10px;
                    border: 0px;
                    color: ${base00};
                           background: linear-gradient(45deg, ${base0E}, ${base0F}, ${base0D}, ${base09});
                           background-size: 300% 300%;
                           animation: gradient_horizontal 15s ease infinite;
                    opacity: 0.5;
                           transition: ${betterTransition};
                  ''
              }
                   }
                   #workspaces button.active {
              ${
                if simplebar == true then
                  ''
                    color: ${base00};
                           background: linear-gradient(118deg, ${base0D} 5%, ${base0F} 5%, ${base0F} 20%, ${base0D} 20%, ${base0D} 40%, ${base0F} 40%, ${base0F} 60%, ${base0D} 60%, ${base0D} 80%, ${base0F} 80%, ${base0F} 95%, ${base0D} 95%);
                           background-size: 300% 300%;
                           animation: swiping 15s linear infinite;
                    border-radius: 15px;
                    margin: 4px 3px;
                    opacity: 1.0;
                    border: 0px;
                    min-width: 45px;
                    transition: ${betterTransition};
                  ''
                else
                  ''
                    padding: 0px 5px;
                    margin: 4px 3px;
                    border-radius: 10px;
                    border: 0px;
                    color: ${base00};
                           background: linear-gradient(45deg, ${base0E}, ${base0F}, ${base0D}, ${base09});
                           background-size: 300% 300%;
                           animation: gradient_horizontal 15s ease infinite;
                           transition: ${betterTransition};
                    opacity: 1.0;
                    min-width: 40px;
                  ''
              }
                   }
                   #workspaces button:hover {
              ${
                if simplebar == true then
                  ''
                    color: ${base05};
                    border: 0px;
                    border-radius: 15px;
                    transition: ${betterTransition};
                  ''
                else
                  ''
                    border-radius: 10px;
                    color: ${base00};
                           background: linear-gradient(45deg, ${base0E}, ${base0F}, ${base0D}, ${base09});
                           background-size: 300% 300%;
                           animation: gradient_horizontal 15s ease infinite;
                    opacity: 0.8;
                           transition: ${betterTransition};
                  ''
              }
                   }
                   @keyframes gradient_horizontal {
              0% {
                background-position: 0% 50%;
              }
              50% {
                background-position: 100% 50%;
              }
              100% {
                background-position: 0% 50%;
              }
                   }
                   @keyframes swiping {
                     0% {
                background-position: 0% 200%;
              }
              100% {
                background-position: 200% 200%;
              }
                   }
                   tooltip {
              background: ${base00};
              border: 1px solid ${base0E};
              border-radius: 10px;
                   }
                   tooltip label {
              color: ${base07};
                   }
                   #window {
              ${
                if simplebar == true then
                  ''
                    color: ${base03};
                    background: ${base00};
                    margin: 6px 4px;
                    border-radius: 15px;
                    padding: 0px 10px;
                  ''
                else
                  ''
                    margin: 4px;
                    padding: 2px 10px;
                    color: ${base05};
                    background: ${base01};
                    border-radius: 10px;
                  ''
              }
                   }
                   #memory {
                	color: ${base0F};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #clock {
                 	color: ${base0B};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #cpu {
                 	color: ${base07};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #disk {
                 	color: ${base0F};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   } 
                   #battery {
                 	color: ${base08};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #battery.critical {
                     color: ${base01};
              ${
                if simplebar == true then
                  ''
                    background: ${base09};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base09};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #battery.warning {
                     color: ${base01};
              ${
                if simplebar == true then
                  ''
                    background: ${base08};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base08};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #network {
                 	color: ${base09};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #custom-hyprbindings {
                 	color: ${base0E};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #mpris {
                 	color: ${base07};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #tray {
                 	color: ${base05};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #pulseaudio {
                 	color: ${base03};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #custom-startmenu {
                 	color: ${base03};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 4px;
                    padding: 0px 8px 0px 10px;
                    border-radius: 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px;
                    padding: 2px 10px;
                    border-radius: 10px;
                  ''
              }
                   }
                   #idle_inhibitor {
                 	color: ${base09};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 0px;
                    padding: 0px 18px 0px 14px;
                    border-radius: 0px 15px 15px 0px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px 0px;
                    padding: 2px 14px;
                    border-radius: 0px 10px 10px 0px;
                  ''
              }
                   }
                   #custom-exit {
                 	color: ${base0E};
              ${
                if simplebar == true then
                  ''
                    background: ${base00};
                    margin: 6px 0px 6px 4px;
                    padding: 0px 5px 0px 10px;
                    border-radius: 15px 0px 0px 15px;
                  ''
                else
                  ''
                    background: ${base01};
                    margin: 4px 0px;
                    padding: 2px 5px 2px 10px;
                    border-radius: 10px 0px 0px 10px;
                  ''
              }
                   } ''
          ];
        };
      };
    };
  };
}
