#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#
{
  config,
  lib,
  pkgs,
  hyprland,
  hyprhook,
  hypridle,
  hyprlock,
  system,
  vars,
  host,
  ...
}: let
  mainMod = "SUPER";
  hyprlandPkg = hyprland.packages.${pkgs.system}.hyprland;
  hyprlockPkg = hyprlock.packages.${pkgs.system}.hyprlock;
  hypridlePkg = hypridle.packages.${pkgs.system}.hypridle;
  hyprhookPkg = hyprhook.packages.${pkgs.system}.hyprhook;
in
  with lib;
  with host; {
    options = {
      hyprland = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description =
            mdDoc
            ''
              Enable hyprland a WM
            '';
        };
      };
    };

    config = mkIf (config.hyprland.enable) {
      wlwm.enable = true; # mainly good to know

      environment = {
        variables = {
          # WLR_NO_HARDWARE_CURSORS="1"; # Needed for VM
          # WLR_RENDERER_ALLOW_SOFTWARE="1";
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
        };
        sessionVariables =
          if hostName == "nvidia"
          then {
            LIBVA_DRIVER_NAME = "nvidia";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            NVD_BACKEND = "direct";
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
            GBM_BACKEND = "nvidia";

            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
          }
          else {
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
          };
        systemPackages = with pkgs; [
          grimblast # Screenshot
          hyprpaper # Wallpaper
          wl-clipboard # Clipboard
          #wlr-randr # Monitor Settings # TODO: needed?
          xwayland # X session
          kitty
          eww
        ];
      };

      programs.hyprland = {
        enable = true;
        package = hyprlandPkg; #.override {debug = true;};
      };

      security.pam.services.hyprlock = {
        text = "auth include login";
        # fprintAuth = if hostName == "asahi" then true else false; # fingerprint not working yet on asahi
        enableGnomeKeyring = true;
      };

      systemd.sleep.extraConfig = ''
        AllowSuspend=yes
        AllowHibernation=no
        AllowSuspendThenHibernate=no
        AllowHybridSleep=yes
      ''; # Clamshell Mode (closed laptop use)

      # nix.settings = {
      #   substituters = ["https://hyprland.cachix.org"];
      #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      # };

      home-manager.users.${vars.user} = let
        lid =
          if hostName == "xps"
          then "LID0"
          else "LID"; # TODO: needed?
        lockScript = pkgs.writeShellScript "lock-script" ''
          action=$1
          ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
          if [ $? == 1 ]; then
            if [ "$action" == "lock" ]; then
              ${pkgs.hyprlock}/bin/hyprlock
            elif [ "$action" == "suspend" ]; then
              ${pkgs.systemd}/bin/systemctl suspend
            fi
          fi
        '';
        customScripts = "$HOME/.local/bin";
      in {
        imports = [
          hyprland.homeManagerModules.default
        ];

        programs.hyprlock = {
          enable = true;
          package = hyprlockPkg;
          settings = {
            general = {
              hide_cursor = true;
              no_fade_in = false;
              disable_loading_bar = true;
              grace = 0;
            };
            background = [
              {
                monitor = "";
                path = "$HOME/.config/wallpaper.png";
                color = "rgba(25, 20, 20, 1.0)";
                blur_passes = 1;
                blur_size = 0;
                brightness = 0.2;
              }
            ];
            input-field = [
              {
                monitor = "";
                size = "250, 60";
                outline_thickness = 2;
                dots_size = 0.2;
                dots_spacing = 0.2;
                dots_center = true;
                outer_color = "rgba(0, 0, 0, 0)";
                inner_color = "rgba(0, 0, 0, 0.5)";
                font_color = "rgb(200, 200, 200)";
                fade_on_empty = false;
                placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
                hide_input = false;
                position = "0, -120";
                halign = "center";
                valign = "center";
              }
            ];
            label = [
              {
                monitor = "";
                text = "$TIME";
                font_size = 120;
                position = "0, 80";
                valign = "center";
                halign = "center";
              }
            ];
          };
        };

        services.hypridle = {
          enable = true;
          package = hypridlePkg;
          settings = {
            general = {
              before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
              after_sleep_cmd = "${hyprlandPkg}/bin/hyprctl dispatch dpms on";
              ignore_dbus_inhibit = true;
              lock_cmd = "pidof ${hyprlockPkg}/bin/hyprlock || ${hyprlockPkg}/bin/hyprlock";
            };
            listener = [
              {
                timeout = 300;
                on-timeout = "${lockScript.outPath} lock";
              }
              {
                timeout = 1800;
                on-timeout = "${lockScript.outPath} suspend";
              }
            ];
          };
        };

        services.hyprpaper = {
          enable = true;
          settings = {
            ipc = true;
            splash = false;
            preload = "$HOME/.config/wallpaper.png";
            wallpaper = ",$HOME/.config/wallpaper.png";
          };
        };

        wayland.windowManager.hyprland = {
          enable = true;
          package = hyprlandPkg; #.override {debug = true;};
          xwayland.enable = true;
          plugins = [
            hyprhookPkg
          ];
          settings = {
            general = {
              border_size = 2;
              gaps_in = 5;
              gaps_out = 3;
              "col.active_border" = "0xffcba6f7"; # mauve
              "col.inactive_border" = "0xff6c7086";
              resize_on_border = true;
              hover_icon_on_border = false;
              layout = "dwindle";
            };
            decoration = {
              rounding = 5;
              active_opacity = 1;
              #inactive_opacity = 0.9;
              fullscreen_opacity = 1;
              blur = {
                enabled = true;
                size = 3;
                passes = 3;
                new_optimizations = true;
              };
              drop_shadow = false;
            };
            monitor =
              [
                ",preferred,auto,1,mirror,${toString mainMonitor}"
              ]
              ++ (
                if hostName == "asahi"
                then [
                  "${toString buildInMonitor},preferred,auto,1.6"
                  "${toString mainMonitor},preferred,auto,1,mirror,${toString buildInMonitor}"
                  "${toString secondMonitor},3840x2160@60.00,-3840x0,1"
                ]
                else if hostName == "nvidia"
                then [
                  "${toString mainMonitor},2560x1440@143.86,0x0,1}"
                  "${toString secondMonitor},3840x2160@60.00,-3840x0,1"
                ]
                else [
                  "${toString mainMonitor},preferred,auto,1"
                ]
              );
            workspace =
              if hostName == "asahi"
              then [
                "1, monitor:${toString mainMonitor},default:true"
                "2, monitor:${toString mainMonitor}"
                "3, monitor:${toString mainMonitor}"
                "4, monitor:${toString mainMonitor}"
                "8, monitor:${toString secondMonitor}"
              ]
              else if hostName == "nvidia"
              then [
                "1, monitor:${toString mainMonitor},default:true"
                "2, monitor:${toString mainMonitor}"
                "3, monitor:${toString mainMonitor}"
                "4, monitor:${toString mainMonitor}"
                "8, monitor:${toString secondMonitor}"
              ]
              else [];
            animations = {
              enabled = true;
              bezier = [
                "simple, 0.16, 1, 0.3, 1"
                "tehtarik, 0.68, -0.55, 0.265, 1.55"
                "overshot, 0.05, 0.9, 0.1, 1.05"
                "smoothOut, 0.36, 0, 0.66, -0.56"
                "smoothIn, 0.25, 1, 0.5, 1"
                "rotate,0,0,1,1"
              ];
              animation = [
                "windows, 1, 5, overshot, popin"
                # "windowsIn, 1, 4, tehtarik, slide"
                "windowsOut, 1, 4, tehtarik, slide"
                # "windowsMove, 1, 3, smoothIn, slide"
                # "border, 1, 5, default"
                "fade, 1, 10, simple"
                # "fadeDim, 1, 4, smoothIn"
                "workspaces, 1, 6, simple, slide"
                # "borderangle, 1, 20, rotate, loop"
                "specialWorkspace, 1, 6, simple, slidevert"
              ];
            };
            input = {
              kb_layout = "de,us";
              sensitivity = 0.25;
              accel_profile = "flat";
              follow_mouse = 1;
              numlock_by_default = true;
              repeat_delay = 250;
              repeat_rate = 75;
              touchpad =
                if hostName == "asahi"
                then {
                  scroll_factor = 0.2;
                  natural_scroll = false;
                  tap-to-click = true;
                  drag_lock = true;
                  disable_while_typing = true;
                  middle_button_emulation = true;
                }
                else {};
            };
            gestures =
              if hostName == "asahi"
              then {
                workspace_swipe = true;
                workspace_swipe_fingers = 3;
                workspace_swipe_invert = false;
              }
              else {};
            device = {
              name = "urchin-keyboard";
              kb_layout = "us";
            };
            dwindle = {
              pseudotile = true;
              force_split = 2;
              preserve_split = true;
              special_scale_factor = 0.8;
            };
            binds = {
              workspace_back_and_forth = true;
            };
            # master = {
            #   pseudotile = true;
            # preserve_split = true;
            # special_scale_factor = 0.8;
            # };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              mouse_move_enables_dpms = true;
              mouse_move_focuses_monitor = true;
              no_direct_scanout = true;
              # focus_on_activation = true;
              enable_swallow = true;
              key_press_enables_dpms = true;
              background_color = "0x111111";
            };
            debug = {
              damage_tracking = 2;
              # overlay = true;
              # damage_blink = true;
            };
            "$mainMod" = "${toString mainMod}";
            bind = [
              "$mainMod, return, exec, ${pkgs.${vars.terminal}}/bin/${vars.terminal}"
              "$mainMod, B, exec, ${pkgs.firefox}/bin/firefox"
              "$mainMod, Q, killactive"
              "$mainMod, C, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
              "$mainMod, F, togglefloating"

              "$mainMod, 1, workspace, 1"
              "$mainMod, 2, workspace, 2"
              "$mainMod, 3, workspace, 3"
              "$mainMod, 4, workspace, 4"
              "$mainMod, 5, workspace, 5"
              "$mainMod, 6, workspace, 6"
              "$mainMod, 7, workspace, 7"
              "$mainMod, 8, workspace, 8"
              "$mainMod, 9, workspace, 9"
              "$mainMod, 0, workspace, 10"

              "$mainMod SHIFT, 1, movetoworkspace, 1"
              "$mainMod SHIFT, 2, movetoworkspace, 2"
              "$mainMod SHIFT, 3, movetoworkspace, 3"
              "$mainMod SHIFT, 4, movetoworkspace, 4"
              "$mainMod SHIFT, 5, movetoworkspace, 5"
              "$mainMod SHIFT, 6, movetoworkspace, 6"
              "$mainMod SHIFT, 7, movetoworkspace, 7"
              "$mainMod SHIFT, 8, movetoworkspace, 8"
              "$mainMod SHIFT, 9, movetoworkspace, 9"
              "$mainMod SHIFT, 0, movetoworkspace, 10"
              "$mainMod SHIFT, bracketleft, movetoworkspace, -1"
              "$mainMod SHIFT, bracketright, movetoworkspace, +1"

              ",XF86AudioMute,exec,${customScripts}/volume --toggle"
              ",XF86AudioMicMute,exec,${customScripts}/volume --toggle-mic"
            ];
            binde = [
              ",XF86AudioLowerVolume,exec,${customScripts}/volume --dec"
              ",XF86AudioRaiseVolume,exec,${customScripts}/volume --inc"
              ",XF86MonBrightnessDown,exec,${customScripts}/brightness --dec"
              ",XF86MonBrightnessUP,exec,${customScripts}/brightness --inc"
            ];
            windowrule = [
              "float, Rofi"
            ];
            exec-once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"
              "$HOME/.config/hypr/script/sync-clipboard.sh &"
              "${pkgs.eww}/bin/eww daemon"
              "[workspace special silent] ${pkgs.${vars.terminal}}/bin/${vars.terminal}"
              "[workspace 1] ${pkgs.${vars.terminal}}/bin/${vars.terminal}"
              "[workspace 2 silent] ${pkgs.firefox}/bin/firefox"
              "[workspace 8 silent] ${pkgs.webcord-vencord}/bin/webcord"
            ];
            # bindl =
            #   if hostName == "asahi" then [
            #     ",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh" # clamshell not working
            #   ] else [ ];
          };
          extraConfig = ''
            # bindmd = $mainMod, mouse:272, test123, resizewindow
            # bindm = $mainMod, mouse:273, resizewindow
            # bindm = $mainMod, mouse:274, movewindow

            bindd = $mainMod, Space, +submaps, submap, supmaper
            submap = supmaper
            bindd = , escape, Reset submap, submap, reset
            bindd = , O, +open, submap, open
            bindd = , L, +layout, submap, masterlayout
            bindd = , B, +backlight, submap, backlight
            bindd = , V, +volume, submap, volume
            bindd = , R, +resize, submap, resize
            bindd = , M, +move, submap, move
            bindd = , F, +focus, submap, focus
            bindd = , G, +screenshot, submap, grimblast
            bindd = , S, Special Workspace, togglespecialworkspace,
            bindd = , S, Reset submap, submap, reset
            bindd = SHIFT, S, Move To Special Workspace, movetoworkspace, special
            bindd = SHIFT, S, Reset submap, submap, reset
            submap = reset

            submap = open
            bind = , escape, submap, reset
            bindd = , Q, Close Window, killactive
            bind = , Q, submap, reset
            bindd = , T, Open Terminal, exec, ${pkgs.${vars.terminal}}/bin/${vars.terminal}
            bind = , T, submap, reset
            bindd = , F, Open Files, exec, ${pkgs.pcmanfm}/bin/pcmanfm
            bind = , F, submap, reset
            bindd = , B, Open Browser, exec, [workspace 2] ${pkgs.firefox}/bin/firefox
            bind = , B, submap, reset
            bindd = , D, Open Discord, exec, [workspace 8]${pkgs.webcord-vencord}/bin/webcord
            bind = , D, submap, reset
            bindd = , C, Open Controll Center, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun
            bind = , C, submap, reset
            # bind = , M, exec, $music $electron_flags
            # bind = , M, submap, reset
            # bind = , A, exec, anki
            # bind = , A, submap, reset
            submap = reset

            submap = masterlayout
            bind = , escape, submap, reset
            bindd = , I, Not Working, layoutmsg, addmaster
            bind = , I, submap, reset
            bindd = , D, Not Working, layoutmsg, removemaster
            bind = , D, submap, reset
            submap = reset

            submap = backlight
            bind = , escape, submap, reset
            bindd = , K, Increase Screen Brightness, exec, ${customScripts}/brightness --inc
            bindd = , J, Decrease Screen Brightness, exec, ${customScripts}/brightness --dec
            bindd = , H, Decrease Keyboard Brightness, exec, ${customScripts}/kbd-brightness --dec
            bindd = , L, Increase Keyboard Brightness, exec, ${customScripts}/kbd-brightness --inc
            bindd = , up, Increase Screen Brightness, exec, ${customScripts}/brightness --inc
            bindd = , down, Decrease Screen Brightness, exec, ${customScripts}/brightness --dec
            bindd = , left, Decrease Keyboard Brightness, exec, ${customScripts}/kbd-brightness --dec
            bindd = , right, Increase Keyboard Brightness, exec, ${customScripts}/kbd-brightness --inc
            submap = reset

            submap = volume
            bind = , escape, submap, reset
            binded = , K, Increase Volume, exec, ${customScripts}/volume --inc
            binded = , J, Decrease Volume, exec, ${customScripts}/volume --dec
            binded = , up, Increase Volume, exec, ${customScripts}/volume --inc
            binded = , down, Decrease Volume, exec, ${customScripts}/volume --dec
            binded = , D, Deff Speakers, exec, ${customScripts}/volume --toggle
            binde = , D, submap, reset
            binded = , M, Muste Mice, exec, ${customScripts}/volume --toggle-mic
            binde = , M, submap, reset
            submap = reset

            submap = resize
            bind = , escape, submap, reset
            binded = , H, Resize Left, resizeactive,-50 0
            binded = , L, Resize Right, resizeactive,50 0
            binded = , K, Resize Up, resizeactive,0 -50
            binded = , J, Resize Down, resizeactive,0 50
            binded = , left, Resize Left, resizeactive,-50 0
            binded = , right, Resize Right, resizeactive,50 0
            binded = , up, Resize Up, resizeactive,0 -50
            binded = , down, Resize Down, resizeactive,0 50
            submap = reset

            submap = move
            bind = , escape, submap, reset
            bindd = , F, +focus, submap, focus
            bindd = , H, Move Left, movewindow, l
            bindd = , L, Move Right, movewindow, r
            bindd = , K, Move Up, movewindow, u
            bindd = , J, Move Down, movewindow, d
            bindd = , left, Move Left, movewindow, l
            bindd = , right, Move Right, movewindow, r
            bindd = , up, Move Up, movewindow, u
            bindd = , down, Move Down, movewindow, d
            bindd = , 1, Move Workspace 1, exec, hyprctl dispatch movetoworkspace 1
            bindd = , 2, Move Workspace 2, exec, hyprctl dispatch movetoworkspace 2
            bindd = , 3, Move Workspace 3, exec, hyprctl dispatch movetoworkspace 3
            bindd = , 4, Move Workspace 4, exec, hyprctl dispatch movetoworkspace 4
            bindd = , 5, Move Workspace 5, exec, hyprctl dispatch movetoworkspace 5
            bindd = , 6, Move Workspace 6, exec, hyprctl dispatch movetoworkspace 6
            bindd = , 7, Move Workspace 7, exec, hyprctl dispatch movetoworkspace 7
            bindd = , 8, Move Workspace 8, exec, hyprctl dispatch movetoworkspace 8
            bindd = , 9, Move Workspace 9, exec, hyprctl dispatch movetoworkspace 9
            bindd = , 0, Move Workspace 10, exec, hyprctl dispatch movetoworkspace 10
            bindd = SHIFT, H, Move Workspace Left, exec, hyprctl dispatch movetoworkspace e-1
            bindd = SHIFT, L, Move Workspace Right, exec, hyprctl dispatch movetoworkspace e+1
            bindd = SHIFT, left, Move Workspace Left, exec, hyprctl dispatch movetoworkspace e-1
            bindd = SHIFT, right, Move Workspace Right, exec, hyprctl dispatch movetoworkspace e+1
            submap = reset

            submap = focus
            bindd = , Q, Close Window, killactive
            bind = , escape, submap, reset
            bindd = , M, +move, submap, move
            bindd = , left, Focus Left, movefocus, l
            bindd = , right, Focus Right, movefocus, r
            bindd = , up, Focus Up, movefocus, u
            bindd = , down, Focus Down, movefocus, d
            bindd = , H, Focus Left, movefocus, l
            bindd = , L, Focus Right, movefocus, r
            bindd = , K, Focus Up, movefocus, u
            bindd = , J, Focus Down, movefocus, d
            bindd = , 1, Focus Workspace 1, exec, hyprctl dispatch workspace 1
            bindd = , 2, Focus Workspace 2, exec, hyprctl dispatch workspace 2
            bindd = , 3, Focus Workspace 3, exec, hyprctl dispatch workspace 3
            bindd = , 4, Focus Workspace 4, exec, hyprctl dispatch workspace 4
            bindd = , 5, Focus Workspace 5, exec, hyprctl dispatch workspace 5
            bindd = , 6, Focus Workspace 6, exec, hyprctl dispatch workspace 6
            bindd = , 7, Focus Workspace 7, exec, hyprctl dispatch workspace 7
            bindd = , 8, Focus Workspace 8, exec, hyprctl dispatch workspace 8
            bindd = , 9, Focus Workspace 9, exec, hyprctl dispatch workspace 9
            bindd = , 0, Focus Workspace 10, exec, hyprctl dispatch workspace 10
            bindd = SHIFT, H, Focus Workspace Left, exec, hyprctl dispatch workspace e-1
            bindd = SHIFT, L, Focus Workspace Right, exec, hyprctl dispatch workspace e+1
            bindd = SHIFT, left, Focus Workspace Left, exec, hyprctl dispatch workspace e-1
            bindd = SHIFT, right, Focus Workspace Right, exec, hyprctl dispatch workspace e+1
            submap = reset

            submap = grimblast
            bind = , escape, submap, reset
            bindd = , O, Screenshot ?, exec, ${pkgs.grimblast}/bin/grimblast --notify -n copy output
            bind = , O, submap, reset
            bindd = , S, Screenshot Screen Clipboard, exec, ${pkgs.grimblast}/bin/grimblast --notify -n copy screen
            bind = , S, submap, reset
            bindd = , W, Screenshot Window Clipboard, exec, ${pkgs.grimblast}/bin/grimblast --notify -n copy active
            bind = , W, submap, reset
            bindd = , A, Screenshot Area Clipboard, exec, ${pkgs.grimblast}/bin/grimblast --notify -n copy area
            bind = , A, submap, reset
            submap = reset

            plugin {
              hyprhook:submap=$HOME/.local/bin/which-key
            }
          '';
          # settings = {
          #   bind = [
          #     "SUPER,Escape,exit,"
          #     "SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend"
          #     "SUPER,L,exec,${pkgs.hyprlock}/bin/hyprlock"
          #     # "SUPER,E,exec,GDK_BACKEND=x11 ${pkgs.pcmanfm}/bin/pcmanfm"
          #     "SUPER,E,exec,${pkgs.pcmanfm}/bin/pcmanfm"
          #     "SUPER,F,togglefloating,"
          #     "SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
          #     "SUPER,P,pseudo,"
          #     ",F11,fullscreen,"
          #     "SUPER,R,forcerendererreload"
          #     "SUPERSHIFT,R,exec,${config.programs.hyprland.package}/bin/hyprctl reload"
          #     "SUPER,T,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal} -e nvim"
          #     "SUPER,K,exec,${config.programs.hyprland.package}/bin/hyprctl switchxkblayout keychron-k8-keychron-k8 next"
          #
          #     "SUPER,Z,layoutmsg,togglesplit"
          #   ];
          #   exec-once = [
          #     "${pkgs.waybar}/bin/waybar -c $HOME/.config/waybar/config"
          #   ]
          # };
        };

        xdg.configFile = {
          "hypr/script/sync-clipboard.sh" = {
            # wrong path
            text = ''
              #!/usr/bin/env bash
              # Kill any running instances of wl-paste
              killall wl-paste 2>/dev/null

              # Start wl-paste in watch mode to monitor clipboard changes on wayland
              wl-paste -w 'xclip' 2>/dev/null &

              lastclip=""

              while true; do
                # Get the current x clipboard
                clip="$(xclip -o 2>/dev/null)"

                # clipboard changed and not "noText"
                if [[ "$clip" != "$lastclip" && "$clip" != "noText" ]]; then
                  wlpaste="$(wl-paste)"
                  # wl-paste contains other then text and clip content comes from wl-paste
                  if [[ $(wl-paste -l | grep -c "text") -eq 0 && "$wlpaste" == "$clip" ]]; then
                    echo "noText" | xclip
                  else
                    wl-copy "$clip"
                  fi

                  # Update the last clipboard content
                  lastclip="$clip"
                fi

                # Sleep for a short interval before checking again
                sleep 0.1
              done
            '';
            executable = true;
          };
          "hypr/script/clamshell.sh" = {
            # wrong path
            text = ''
              #!/bin/sh

              if grep open /proc/acpi/button/lid/${lid}/state; then
                ${hyprlandPkg}/bin/hyprctl keyword monitor "${toString mainMonitor}, 1920x1080, 0x0, 1"
              else
                if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                  ${hyprlandPkg}/bin/hyprctl keyword monitor "${toString mainMonitor}, disable"
                else
                  ${hyprlockPkg}/bin/hyprlock
                  ${pkgs.systemd}/bin/systemctl suspend
                fi
              fi
            '';
            executable = true;
          };
        };
      };
    };
  }
