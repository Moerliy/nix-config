#
#
# Sane defaults
#
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib; {
  options.sane-defaults = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable sane defaults for home-manager.
        '';
    };
  };

  config = mkIf config.sane-defaults.enable {
    home-manager.users.${vars.user} = {
      home = {
        packages = with pkgs; [
          # Tools
          eza
          bat
          bat-extras.batman
          fd
          fzf
          tldr
          htop
          ripgrep
          tree
          alejandra
        ];
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          ".3" = "cd ../../..";
          ".4" = "cd ../../../..";
          ".5" = "cd ../../../../..";

          # Changing "ls" to "exa"
          ls = "eza -al --color=always --group-directories-first"; # my preferred listing
          la = "eza -a --color=always --group-directories-first"; # all files and dirs
          ll = "eza -l --color=always --group-directories-first"; # long format
          lt = "eza -aT --color=always --group-directories-first"; # tree listing
          "l." = "eza -a | egrep '^\.'";

          # Colorize grep output (good for log files)
          grep = "grep --color=auto";
          egrep = "egrep --color=auto";
          fgrep = "fgrep --color=auto";

          # confirm before overwriting something
          cp = "cp -i";
          mv = "mv -i";
          rm = "rm -i";

          # vim
          v = "nvim";
          vi = "nvim";
          vim = "nvim";

          # bat as a replacement for cat
          cat = "bat";
          man = "batman";

          # git aliases
          addup = "git add -u";
          addall = "git add .";
          branch = "git branch";
          checkout = "git checkout";
          clone = "git clone";
          commit = "git commit";
          fetch = "git fetch";
          pull = "git pull";
          push = "git push";
          tag = "git tag";
          newtag = "git tag -a";
          gst = "git status";

          # rickroll
          rr = "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";

          # find with fzf
          pfzf = "rg --heading --line-number --column . | fzf --layout=reverse";
          pfzff = "rg --heading --line-number --column --files . | fzf --layout=reverse";
        };
      };
    };
  };
}
