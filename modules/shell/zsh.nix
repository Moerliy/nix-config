#
#  Shell
#
{
  lib,
  config,
  pkgs,
  vars,
  ...
}:
with lib; {
  options.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable zsh shell.
        '';
    };
  };

  config = mkIf config.zsh.enable {
    users.users.${vars.user} = {
      #shell = pkgs.zsh;
    };
    home-manager.users.${vars.user} = {
      programs = {
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          history.size = 10000;
          oh-my-zsh = {
            enable = true;
            plugins = ["git"];
            # custom = "$HOME/.config/zsh_nix/custom";
          };
          initExtra = ''
            source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
            autoload -U promptinit; promptinit
          '';
        };
      };
    };
  };
}
