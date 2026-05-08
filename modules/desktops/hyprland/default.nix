#
#  Hyprland Configuration
#  Enable with "hyprland.enable = true;"
#
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  vars,
  host,
  ...
}:
let
  hyprlandPkg = pkgs.hyprland.override {
    # legacyRenderer = true;
    # debug = true;
  };
in
with lib;
with host;
{
  options = {
    hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Enable hyprland a WM
        '';
      };
    };
  };

  config = mkIf config.hyprland.enable {
    wlwm.enable = true; # mainly good to know

    environment = {
      variables = {
        # WLR_NO_HARDWARE_CURSORS="1"; # Needed for VM
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        DESKTOP_SESSION = "hyprland";

        HYPRCURSOR_THEME = "Bibata-Original-Ice-Hyprcursor";
        HYPRCURSOR_SIZE = "24";
        HYPRLAND_LUA_STUBS = "${pkgs.hyprland}/share/hypr/stubs";
      };
      sessionVariables =
        if hostName == "nvidia" then
          {
            LIBVA_DRIVER_NAME = "nvidia";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            GBM_BACKEND = "nvidia-drm";
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
            NVD_BACKEND = "direct";
          }
        else
          {
            WLR_DRM_DEVICES = "/dev/dri/card2";
          };
      systemPackages = with pkgs; [
        bibata-hyprcursor-original
        grimblast # Screenshot
        hyprpaper # Wallpaper
        wl-clipboard # Clipboard
        xwayland # X session
        kitty
        eww
        clipse
        chafa
        jq
        fzf
        grim
      ];
    };

    programs.hyprland = {
      enable = true;
      package = hyprlandPkg; # .override {debug = true;};
    };

    security.pam.services.hyprlock = {
      text = "auth include login";
      # fprintAuth = if hostName == "asahi" then true else false; # fingerprint not working yet on asahi
      enableGnomeKeyring = true;
    };

    # systemd.sleep.settings.Sleep = ''
    #   AllowSuspend=yes
    #   AllowHibernation=no
    #   AllowSuspendThenHibernate=no
    #   AllowHybridSleep=yes
    # ''; # Clamshell Mode (closed laptop use)

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    home-manager.users.${vars.user} =
      let
        lid = if hostName == "xps" then "LID0" else "LID"; # TODO: needed?
        lockScript = pkgs.writeShellScript "lock-script" ''
          action=$1
          ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
          # if [ $? == 1 ]; then
            if [ "$action" == "lock" ]; then
              "${pkgs.hyprlock}/bin/hyprlock"
            elif [ "$action" == "suspend" ]; then
              ${pkgs.systemd}/bin/systemctl suspend
            fi
          # fi
        '';
      in
      {
        programs.hyprlock = {
          enable = true;
          package = pkgs.hyprlock;
          settings = {
            general = {
              # hide_cursor = true;
              screencopy_mode = 1; # 0 - gpu accelerated, 1 - cpu based (slow)
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

        services = {
          hypridle = {
            enable = true;
            package = pkgs.hypridle;
            settings = {
              general = {
                before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
                after_sleep_cmd = "${hyprlandPkg}/bin/hyprctl dispatch 'hl.dsp.dpms({action=\"on\"})'";
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

          hyprsunset = {
            enable = true;
            package = pkgs.hyprsunset;
            settings = {
              max-gamma = 150;
              profile = [
                {
                  time = "6:30";
                  identity = true;
                }
                {
                  time = "19:00";
                  temperature = 5000;
                }
              ];
            };
          };

          hyprpaper = {
            enable = true;
            settings = {
              ipc = true;
              splash = false;
              preload = "$HOME/.config/wallpaper.png";
              wallpaper = [
                {
                  monitor = toString secondMonitor;
                  path = "$HOME/.config/wallpaper.png";
                }
                {
                  monitor = toString mainMonitor;
                  path = "$HOME/.config/wallpaper.png";
                }
                (
                  if host.hostName == "asahi" then
                    {
                      monitor = toString buildInMonitor;
                      path = "$HOME/.config/wallpaper.png";
                    }
                  else
                    { }
                )
              ];
            };
          };
        };

        wayland.windowManager.hyprland = {
          enable = true;
          package = hyprlandPkg;
          portalPackage = pkgs.xdg-desktop-portal-hyprland;
          sourceFirst = false;
          xwayland.enable = true;
        };
        xdg.configFile = {
          "hypr/hyprland.lua" = {
            source = ./config/hyprland.lua;
          };
          "hypr/modules" = {
            source = ./config/modules;
          };
          "hypr/core" = {
            source = ./config/core;
          };
          "hypr/globals.lua" = {
            text =
              builtins.replaceStrings
                [ "MONITOR_MAIN" "MONITOR_SECOND" "MONITOR_BUILDIN" "HOST" "TERMINAL" ]
                [
                  "${toString mainMonitor}"
                  (if secondMonitor != null then "${toString secondMonitor}" else "")
                  (if hostName == "asahi" && buildInMonitor != null then "${toString buildInMonitor}" else "")
                  "${toString hostName}"
                  "${toString vars.terminal}"
                ]
                (builtins.readFile ./config/globals.lua);
          };
          "hypr/xdph.conf" = {
            # wrong path
            text = ''
              screencopy {
                allow_token_by_default = true
              }
            '';
            executable = false;
          };
          "hypr/script/clamshell.sh" = {
            # wrong path
            text = ''
              #!/usr/bin/env bash

              if grep open /proc/acpi/button/lid/${lid}/state; then
                ${hyprlandPkg}/bin/hyprctl keyword monitor "${toString mainMonitor}, 1920x1080, 0x0, 1"
              else
                if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
                  ${hyprlandPkg}/bin/hyprctl keyword monitor "${toString mainMonitor}, disable"
                else
                  ${pkgs.hyprlock}/bin/hyprlock &
                  ${pkgs.systemd}/bin/systemctl suspend
                fi
              fi
            '';
            executable = true;
          };
          "hypr/script/alttab/alttab.sh" = {
            text = ''
              #!/usr/bin/env bash
              hyprctl -q dispatch "hl.dsp.submap('alttab')"
              hyprctl dispatch "hl.dsp.focus({window='class:alttab'})"
              start=$1
              address=$(hyprctl -j clients | jq -r 'sort_by(.focusHistoryID) | .[] | select(.workspace.id >= 0) | "\(.address)\t\(.title)"' |
                      fzf --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red \
                    --cycle \
                    --sync \
                    --bind tab:down,shift-tab:up,start:$start,double-click:ignore \
                    --wrap \
                    --delimiter=$'\t' \
                    --with-nth=2 \
                    --preview "$HOME/.config/hypr/script/alttab/preview.sh {}" \
                    --preview-window=down:80% \
                    --layout=reverse |
                      awk -F"\t" '{print $1}')

              if [ -n "$address" ] ; then
                echo "$address" > $XDG_RUNTIME_DIR/hypr/alttab/address
              fi

              hyprctl -q dispatch "hl.dsp.submap('reset')"
            '';
            executable = true;
          };
          "hypr/script/alttab/preview.sh" = {
            text = ''
              #!/usr/bin/env bash
              line="$1"

              IFS=$'\t' read -r addr _ <<< "$line"
              dim=''${FZF_PREVIEW_COLUMNS}x''${FZF_PREVIEW_LINES}

              grim -t png -l 0 -w "$addr" $XDG_RUNTIME_DIR/hypr/alttab/preview.png
              chafa --animate false --dither=none -s "$dim" "$XDG_RUNTIME_DIR/hypr/alttab/preview.png"
            '';
            executable = true;
          };
          "hypr/script/alttab/enable.sh" = {
            text = ''
              #!/usr/bin/env bash
              mkdir -p $XDG_RUNTIME_DIR/hypr/alttab
              hyprctl -q eval 'hl.config({animations={enabled=false}})'
              kitty --class alttab $HOME/.config/hypr/script/alttab/alttab.sh "$1"
              address="$(cat $XDG_RUNTIME_DIR/hypr/alttab/address)"
              hyprctl -q dispatch "hl.dsp.focus({window=\"address:$address\"})"
              hyprctl -q dispatch 'hl.dsp.window.alter_zorder({mode="top"})'
            '';
            executable = true;
          };
        };
      };
  };
}
