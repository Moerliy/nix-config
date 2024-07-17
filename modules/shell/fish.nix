#
#  Shell
#
{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib; {
  imports = [
    ../theming/starship/default.nix
  ];

  options.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable fish shell.
        '';
    };
  };

  config = mkIf config.fish.enable {
    users.users.${vars.user} = {
      #shell = pkgs.fish;
    };
    programs = {
      bash = {
        interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps -p "$PPID" -o command | tail -n 1 | sed 's|.*/||' ) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
    };
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        neofetch
        starship
        lf
        fzf
      ];
      programs = {
        fish = {
          enable = true;
          plugins = [
            {
              name = "fzf-fish";
              src = pkgs.fishPlugins.fzf-fish.src;
            }
            {
              name = "done";
              src = pkgs.fishPlugins.done.src;
            }
            {
              name = "sponge";
              src = pkgs.fishPlugins.sponge.src;
            }
            {
              name = "autopair";
              src = pkgs.fishPlugins.autopair.src;
            }
            {
              name = "puffer";
              src = pkgs.fishPlugins.puffer.src;
            }
          ];
          interactiveShellInit = ''
            set fish_greeting # Disable greeting
            neofetch
          '';
          shellInit = ''
            # set PATH so it includes user's private ~/.local/bin if it exists
            fish_add_path --path "$HOME/.local/bin"
            fish_add_path --path "$HOME/go/bin"
            fish_add_path --path "$HOME/.ghcup/bin"
            fish_add_path --path "$HOME/.cargo/bin"
            #fish_add_path --path "$HOME/.setup/scripts/bin"

            eval (starship init fish)

            # lf file manager
            function lfcd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
              # `command` is needed in case `lfcd` is aliased to `lf`.
              # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
              cd "$(command lf -print-last-dir $argv)"
            end
          '';
          functions = {
            nix-shell = {
              wraps = "nix-shell";
              body = ''
                for ARG in $argv
                  if [ "$ARG" = --run ]
                    command nix-shell $argv
                    return $status
                  end
                end
                command nix-shell $argv --run "exec fish"
              '';
            };
            "nixd" = {
              wraps = "nix develop";
              body = ''
                command nix develop $argv -c fish
              '';
            };
          };
        };
      };
    };
  };
}
