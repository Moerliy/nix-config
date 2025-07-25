#
#  Shell
#
{
  lib,
  config,
  pkgs,
  vars,
  home-manager,
  ...
}:
with lib;
{
  options.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable zsh shell.
      '';
    };
  };

  config = mkIf config.zsh.enable {
    users.users.${vars.user} = {
      #shell = pkgs.zsh;
    };
    home-manager.users.${vars.user} = {
      home.packages = with pkgs; [
        neofetch
        starship
        lf
        fzf
      ];
      programs = {
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          history.size = 10000;
          initContent = ''
            STARSHIP_CONFIG=~/.config/starship-zsh.toml
            eval "$(${pkgs.starship}/bin/starship init zsh)"
            autoload -U promptinit; promptinit

            # use ubuntu tmux
            alias tmux="/usr/bin/tmux"

            function enix() {
              export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
            }

            function dnix() {
              export PATH="$(echo $PATH | tr ':' '\n' | grep -v '/etc/profiles/per-user' | paste -sd: -)"
            }

            # Install Axii.
            if [ -f "$HOME/dev/axii/scripts/install_axii.sh" ]; then
                source "$HOME/dev/axii/scripts/install_axii.sh"
            fi
            eval "$(register-python-argcomplete armarx)"
          '';
        };
      };
    };
  };
}
