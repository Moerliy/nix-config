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
        shellInit = ''
          if [[ $(${pkgs.procps}/bin/ps -p "$PPID" -o command | tail -n 1) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
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
      ];
      programs = {
        fish = {
          enable = true;
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

            # Spaceship
            eval (starship init fish)

            # lf file manager
            function lfcd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
              # `command` is needed in case `lfcd` is aliased to `lf`.
              # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
              cd "$(command lf -print-last-dir $argv)"
            end
          '';
        };
      };
    };
  };
}
