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
      description = mdDoc ''
        Enable sane defaults for home-manager.
      '';
    };
  };

  config = mkIf config.sane-defaults.enable {
    home-manager.users.${vars.user} = {
      home = {
        packages = with pkgs; [
          # Tools
          git
          curl
          eza
          bat
          bat-extras.batman
          fd
          fzf
          tldr
          htop
          ripgrep
          gnugrep
          tree
          neovim-unwrapped
        ];
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          ".3" = "cd ../../..";
          ".4" = "cd ../../../..";
          ".5" = "cd ../../../../..";

          # Changing "ls" to "exa"
          ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first"; # my preferred listing
          la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first"; # all files and dirs
          ll = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first"; # long format
          lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first"; # tree listing
          "l." = "${pkgs.eza}/bin/eza -a | ${pkgs.gnugrep}/bin/egrep '^\.'";

          # Colorize grep output (good for log files)
          grep = "grep --color=auto";
          egrep = "${pkgs.gnugrep}/bin/egrep --color=auto";
          fgrep = "${pkgs.gnugrep}/bin/fgrep --color=auto";

          # confirm before overwriting something
          cp = "cp -i";
          mv = "mv -i";
          rm = "rm -i";

          # vim
          v = "${pkgs.neovim-unwrapped}/bin/nvim";
          vi = "${pkgs.neovim-unwrapped}/bin/nvim";
          vim = "${pkgs.neovim-unwrapped}/bin/nvim";

          # bat as a replacement for cat
          cat = "${pkgs.bat}/bin/bat";
          man = "${pkgs.bat-extras.batman}/bin/batman";

          # git aliases
          addup = "${pkgs.git}/bin/git add -u";
          addall = "${pkgs.git}/bin/git add .";
          branch = "${pkgs.git}/bin/git branch";
          checkout = "${pkgs.git}/bin/git checkout";
          clone = "${pkgs.git}/bin/git clone";
          commit = "${pkgs.git}/bin/git commit";
          fetch = "${pkgs.git}/bin/git fetch";
          pull = "${pkgs.git}/bin/git pull";
          push = "${pkgs.git}/bin/git push";
          tag = "${pkgs.git}/bin/git tag";
          newtag = "${pkgs.git}/bin/git tag -a";
          gst = "${pkgs.git}/bin/git status";

          # rickroll
          rr = "${pkgs.curl}/bin/curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";

          # find with fzf
          pfzf = "${pkgs.ripgrep}/bin/rg --heading --line-number --column . | ${pkgs.fzf}/bin/fzf --layout=reverse";
          pfzff = "${pkgs.ripgrep}/bin/rg --heading --line-number --column --files . | ${pkgs.fzf}/bin/fzf --layout=reverse";
        };
      };
    };
  };
}
