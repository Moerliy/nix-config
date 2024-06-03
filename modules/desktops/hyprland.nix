#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#
{
  config,
  lib,
  pkgs,
  hyprland,
  hyprspace,
  vars,
  host,
  ...
}: let
  mainMod = "SUPER";
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
          }
          else {
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";
          };
        systemPackages = with pkgs; [
          grimblast # Screenshot
          hyprpaper # Wallpaper
          wl-clipboard # Clipboard
          #wlr-randr # Monitor Settings # TODO: needed?
          xwayland # X session
          kitty
        ];
      };

      programs.hyprland = {
        enable = true;
        package = hyprland.packages.${pkgs.system}.hyprland;
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

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

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
      in {
        imports = [
          hyprland.homeManagerModules.default
        ];

        programs.hyprlock = {
          enable = true;
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
          settings = {
            general = {
              before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
              after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
              ignore_dbus_inhibit = true;
              lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
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
          package = hyprland.packages.${pkgs.system}.hyprland;
          xwayland.enable = true;
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
            ];
            windowrule = [
              "float, Rofi"
            ];
            # bindl =
            #   if hostName == "asahi" then [
            #     ",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh" # clamshell not working
            #   ] else [ ];
          };
          extraConfig = ''
            bind = $mainMod, Space, submap, supmaper
            submap = supmaper
            bind = , escape, submap, reset
            bind = , O, submap, open
            bind = , L, submap, masterlayout
            bind = , B, submap, backlight
            bind = , V, submap, volume
            bind = , R, submap, resize
            bind = , M, submap, move
            bind = , F, submap, focus
            bind = , G, submap, grimblast
            bind = , S, togglespecialworkspace,
            bind = , S, submap, reset
            bind = SHIFT, S, movetoworkspace, special
            bind = SHIFT, S, submap, reset
            submap = reset

            submap = open
            bind = , escape, submap, reset
            bind = , Q, killactive
            bind = , Q, submap, reset
            bind = , T, exec, ${pkgs.${vars.terminal}}/bin/${vars.terminal}
            bind = , T, submap, reset
            bind = , F, exec, $files
            bind = , F, submap, reset
            bind = , E, exec, emacsclient -c -a emacs
            bind = , E, submap, reset
            bind = , B, exec, [workspace 2] MOZ_USE_XINPUT2=1 $browser
            bind = , B, submap, reset
            bind = , D, exec, $discord
            bind = , D, submap, reset
            bind = , C, exec, ${pkgs.rofi}/bin/rofi -show drun
            bind = , C, submap, reset
            bindr = SHIFT, C, exec, pkill bemenu || $scriptsDir/bemenu_input -l    # terminal command without terminal
            bindr = SHIFT, C, submap, reset
            bind = , M, exec, $music $electron_flags
            bind = , M, submap, reset
            bind = , A, exec, anki
            bind = , A, submap, reset
            bind = , S, exec, emacsclient -e '(make-orgcapture-frame)'
            bind = , S, submap, reset
            bind = , P, exec, postman $electron_flags
            bind = , P, submap, reset
            bind = , U, exec, pomotroid --no-sandbox
            bind = , U, submap, reset
            submap = reset

            submap = masterlayout
            bind = , escape, submap, reset
            bind = , I, layoutmsg, addmaster
            bind = , I, submap, reset
            bind = , D, layoutmsg, removemaster
            bind = , D, submap, reset
            submap = reset

            submap = backlight
            bind = , escape, submap, reset
            binde = , K, exec, $backlight --inc
            binde = , J, exec, $backlight --dec
            binde = , H, exec, $kbd_backlight --dec
            binde = , L, exec, $kbd_backlight --inc
            binde = , up, exec, $backlight --inc
            binde = , down, exec, $backlight --dec
            binde = , left, exec, $kbd_backlight --dec
            binde = , right, exec, $kbd_backlight --inc
            submap = reset

            submap = volume
            bind = , escape, submap, reset
            binde = , K, exec, $volume --inc
            binde = , J, exec, $volume --dec
            binde = , up, exec, $volume --inc
            binde = , down, exec, $volume --dec
            binde = , D, exec, $volume --toggle
            binde = , D, submap, reset
            binde = , M, exec, $volume --toggle-mic
            binde = , M, submap, reset
            submap = reset

            submap = resize
            bind = , escape, submap, reset
            binde = , H, resizeactive,-50 0
            binde = , L, resizeactive,50 0
            binde = , K, resizeactive,0 -50
            binde = , J, resizeactive,0 50
            binde = , left, resizeactive,-50 0
            binde = , right, resizeactive,50 0
            binde = , up, resizeactive,0 -50
            binde = , down, resizeactive,0 50
            submap = reset

            submap = move
            bind = , escape, submap, reset
            bind = , F, submap, focus
            bind = , H, movewindow, l
            bind = , L, movewindow, r
            bind = , K, movewindow, u
            bind = , J, movewindow, d
            bind = , left, movewindow, l
            bind = , right, movewindow, r
            bind = , up, movewindow, u
            bind = , down, movewindow, d
            bind = , 1, exec, hyprctl dispatch movetoworkspace 1
            bind = , 2, exec, hyprctl dispatch movetoworkspace 2
            bind = , 3, exec, hyprctl dispatch movetoworkspace 3
            bind = , 4, exec, hyprctl dispatch movetoworkspace 4
            bind = , 5, exec, hyprctl dispatch movetoworkspace 5
            bind = , 6, exec, hyprctl dispatch movetoworkspace 6
            bind = , 7, exec, hyprctl dispatch movetoworkspace 7
            bind = , 8, exec, hyprctl dispatch movetoworkspace 8
            bind = , 9, exec, hyprctl dispatch movetoworkspace 9
            bind = , 0, exec, hyprctl dispatch movetoworkspace 10
            bind = SHIFT, H, exec, hyprctl dispatch movetoworkspace e-1
            bind = SHIFT, L, exec, hyprctl dispatch movetoworkspace e+1
            bind = SHIFT, left, exec, hyprctl dispatch movetoworkspace e-1
            bind = SHIFT, right, exec, hyprctl dispatch movetoworkspace e+1
            submap = reset

            submap = focus
            bind = , Q, killactive
            bind = , escape, submap, reset
            bind = , M, submap, move
            bind = , left, movefocus, l
            bind = , right, movefocus, r
            bind = , up, movefocus, u
            bind = , down, movefocus, d
            bind = , H, movefocus, l
            bind = , L, movefocus, r
            bind = , K, movefocus, u
            bind = , J, movefocus, d
            bind = , 1, exec, hyprctl dispatch workspace 1
            bind = , 2, exec, hyprctl dispatch workspace 2
            bind = , 3, exec, hyprctl dispatch workspace 3
            bind = , 4, exec, hyprctl dispatch workspace 4
            bind = , 5, exec, hyprctl dispatch workspace 5
            bind = , 6, exec, hyprctl dispatch workspace 6
            bind = , 7, exec, hyprctl dispatch workspace 7
            bind = , 8, exec, hyprctl dispatch workspace 8
            bind = , 9, exec, hyprctl dispatch workspace 9
            bind = , 0, exec, hyprctl dispatch workspace 10
            bind = SHIFT, H, exec, hyprctl dispatch workspace e-1
            bind = SHIFT, L, exec, hyprctl dispatch workspace e+1
            bind = SHIFT, left, exec, hyprctl dispatch workspace e-1
            bind = SHIFT, right, exec, hyprctl dispatch workspace e+1
            submap = reset

            submap = grimblast
            bind = , escape, submap, reset
            bind = , O, exec, ${pkgs.grimblast}/bin/grimblast -n copy output
            bind = , O, submap, reset
            bind = , S, exec, ${pkgs.grimblast}/bin/grimblast -n copy screen
            bind = , S, submap, reset
            bind = , W, exec, ${pkgs.grimblast}/bin/grimblast -n copy active
            bind = , W, submap, reset
            bind = , A, exec, ${pkgs.grimblast}/bin/grimblast -n copy area
            bind = , A, submap, reset
            submap = reset
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
          #     "SUPER,left,movefocus,l"
          #     "SUPER,right,movefocus,r"
          #     "SUPER,up,movefocus,u"
          #     "SUPER,down,movefocus,d"
          #     "SUPERSHtIFT,left,movewindow,l"
          #     "SUPERSHIFT,right,movewindow,r"
          #     "SUPERSHIFT,up,movewindow,u"
          #     "SUPERSHIFT,down,movewindow,d"
          #     "ALT,1,workspace,1"
          #     "ALT,2,workspace,2"
          #     "ALT,3,workspace,3"
          #     "ALT,4,workspace,4"
          #     "ALT,5,workspace,5"
          #     "ALT,6,workspace,6"
          #     "ALT,7,workspace,7"
          #     "ALT,8,workspace,8"
          #     "ALT,9,workspace,9"
          #     "ALT,0,workspace,10"
          #     "ALT,right,workspace,+1"
          #     "ALT,left,workspace,-1"
          #     "ALTSHIFT,1,movetoworkspace,1"
          #     "ALTSHIFT,2,movetoworkspace,2"
          #     "ALTSHIFT,3,movetoworkspace,3"
          #     "ALTSHIFT,4,movetoworkspace,4"
          #     "ALTSHIFT,5,movetoworkspace,5"
          #     "ALTSHIFT,6,movetoworkspace,6"
          #     "ALTSHIFT,7,movetoworkspace,7"
          #     "ALTSHIFT,8,movetoworkspace,8"
          #     "ALTSHIFT,9,movetoworkspace,9"
          #     "ALTSHIFT,0,movetoworkspace,10"
          #     "ALTSHIFT,right,movetoworkspace,+1"
          #     "ALTSHIFT,left,movetoworkspace,-1"
          #
          #     "SUPER,Z,layoutmsg,togglesplit"
          #     ",print,exec,${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png"
          #     ",XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10"
          #     ",XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10"
          #     ",XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t"
          #     "SUPER_L,c,exec,${pkgs.pamixer}/bin/pamixer --default-source -t"
          #     "CTRL,F10,exec,${pkgs.pamixer}/bin/pamixer -t"
          #     ",XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t"
          #     ",XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 10"
          #     ",XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 10"
          #   ];
          #   windowrulev2 = [
          #     "float,title:^(Volume Control)$"
          #     "keepaspectratio,class:^(firefox)$,title:^(Picture-in-Picture)$"
          #     "noborder,class:^(firefox)$,title:^(Picture-in-Picture)$"
          #     "float, title:^(Picture-in-Picture)$"
          #     "size 24% 24%, title:(Picture-in-Picture)"
          #     "move 75% 75%, title:(Picture-in-Picture)"
          #     "pin, title:^(Picture-in-Picture)$"
          #     "float, title:^(Firefox)$"
          #     "size 24% 24%, title:(Firefox)"
          #     "move 74% 74%, title:(Firefox)"
          #     "pin, title:^(Firefox)$"
          #     "opacity 0.9, class:^(kitty)"
          #     "tile,initialTitle:^WPS.*"
          #   ];
          #   exec-once = [
          #     "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          #     "${pkgs.hyprlock}/bin/hyprlock"
          #     "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"
          #     "${pkgs.waybar}/bin/waybar -c $HOME/.config/waybar/config"
          #     "${pkgs.eww}/bin/eww daemon"
          #     # "$HOME/.config/eww/scripts/eww" # When running eww as a bar
          #     "${pkgs.blueman}/bin/blueman-applet"
          #     "${pkgs.swaynotificationcenter}/bin/swaync"
          #     # "${pkgs.hyprpaper}/bin/hyprpaper"
          #   ] ++ (if hostName == "work" then [
          #     "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          #     "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive --vfs-cache-mode=writes"
          #     # "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GDrive"
          #   ] else [ ]) ++ (if hostName == "xps" then [
          #     "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
          #   ] else [ ]);
          # };
        };

        home.file = {
          ".config/hypr/script/clamshell.sh" = {
            # wrong path
            text = ''
              #!/bin/sh

              if grep open /proc/acpi/button/lid/${lid}/state; then
                ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, 1920x1080, 0x0, 1"
              else
                if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                  ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, disable"
                else
                  ${pkgs.hyprlock}/bin/hyprlock
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
