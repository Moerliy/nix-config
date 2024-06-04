#
#  Terminal Emulator
#
{
  lib,
  config,
  pkgs,
  vars,
  ...
}:
with lib; {
  options.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable kitty terminal emulator.
        '';
    };
  };

  config = mkIf config.kitty.enable {
    users.users.${vars.user} = {
      #shell = pkgs.fish;
    };
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })
      ];
    };

    # programs = {
    #   bash = {
    #     interactiveShellInit = ''
    #       if [[ $(${pkgs.procps}/bin/ps -p "$PPID" -o command | tail -n 1) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #       then
    #         shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #         exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #       fi
    #     '';
    #   };
    # };
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        fish
      ];
      programs = {
        kitty = {
          enable = true;
          theme = "Catppuccin-Mocha";
          font = {
            name = "JetBrainsMono Nerd Font";
            size = 13;
          };
          settings = {
            # shell = "${pkgs.fish}/bin/fish";
            hide_window_decorations = "titlebar-only";
            macos_show_window_title_in = "window";
            linux_display_server = "wayland";
            wayland_titlebar_color = "background";
            confirm_os_window_close = 0;
            enable_audio_bell = "no";
            resize_debounce_time = "0";
            background_opacity = "0.9";
            cursor_shape = "block";
          };
          shellIntegration = {
            enableFishIntegration = true;
            enableZshIntegration = true;
            mode = "no-cursor";
          };
        };
      };
    };
  };
}
