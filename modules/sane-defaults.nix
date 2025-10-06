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
with lib;
{
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
      xdg = {
        mime.enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "image/jpeg" = [
              "com.github.weclaw1.ImageRoll.desktop"
              "feh.desktop"
            ];
            "image/jpg" = [
              "com.github.weclaw1.ImageRoll.desktop"
              "feh.desktop"
            ];
            "image/png" = [
              "com.github.weclaw1.ImageRoll.desktop"
              "feh.desktop"
            ];
            "application/pdf" = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
            "application/zip" = "org.gnome.FileRoller.desktop";
            "application/x-tar" = "org.gnome.FileRoller.desktop";
            "application/x-bzip2" = "org.gnome.FileRoller.desktop";
            "application/x-gzip" = "org.gnome.FileRoller.desktop";
            "x-scheme-handler/http" = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
            "x-scheme-handler/https" = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
            "x-scheme-handler/about" = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
            "x-scheme-handler/discord" = "vesktop.desktop";
            "x-scheme-handler/unknown" = [
              "firefox.desktop"
              "google-chrome.desktop"
            ];
            "x-scheme-handler/mailto" = [ "gmail.desktop" ];
            "audio/mp3" = "mpv.desktop";
            "audio/x-matroska" = "mpv.desktop";
            "video/webm" = "mpv.desktop";
            "video/mp4" = "mpv.desktop";
            "video/x-matroska" = "mpv.desktop";
            "inode/directory" = "pcmanfm.desktop";

            # programming languages
            "text/plain" = "nvim.desktop";
            # Web / JS / TS
            "application/javascript" = "nvim.desktop"; # .js
            "application/ecmascript" = "nvim.desktop"; # .es/.mjs
            "application/typescript" = "nvim.desktop"; # .ts
            "text/javascript" = "nvim.desktop"; # fallback
            "text/typescript" = "nvim.desktop";
            "text/html" = "nvim.desktop"; # .html
            "text/css" = "nvim.desktop"; # .css
            "text/x-scss" = "nvim.desktop"; # .scss
            "text/x-less" = "nvim.desktop"; # .less
            "text/x-vue" = "nvim.desktop"; # .vue

            # Python / Ruby / PHP / Perl / Lua / Shell
            "text/x-python" = "nvim.desktop"; # .py
            "text/x-ruby" = "nvim.desktop"; # .rb
            "application/x-php" = "nvim.desktop"; # .php
            "text/x-perl" = "nvim.desktop"; # .pl
            "text/x-lua" = "nvim.desktop"; # .lua
            "text/x-shellscript" = "nvim.desktop"; # .sh, .bash

            # C / C++ / Objective-C / Rust / Go / Java / Kotlin
            "text/x-c" = "nvim.desktop"; # .c
            "text/x-c++src" = "nvim.desktop"; # .cpp, .cc, .cxx
            "text/x-objectivec" = "nvim.desktop"; # .m
            "text/x-rust" = "nvim.desktop"; # .rs
            "text/x-go" = "nvim.desktop"; # .go
            "text/x-java-source" = "nvim.desktop"; # .java
            "text/x-kotlin" = "nvim.desktop"; # .kt, .kts

            # C# / F# / VB
            "text/x-csharp" = "nvim.desktop"; # .cs
            "text/x-fsharp" = "nvim.desktop"; # .fs
            "text/x-vb" = "nvim.desktop"; # .vb

            # Functional / scripting languages
            "text/x-haskell" = "nvim.desktop"; # .hs
            "text/x-elisp" = "nvim.desktop"; # .el
            "text/x-lisp" = "nvim.desktop"; # .lisp
            "text/x-clojure" = "nvim.desktop"; # .clj
            "text/x-scheme" = "nvim.desktop"; # .scm, .ss
            "text/x-r" = "nvim.desktop"; # .r
            "text/x-julia" = "nvim.desktop"; # .jl

            # SQL / Data / Config
            "text/x-sql" = "nvim.desktop"; # .sql
            "text/csv" = "nvim.desktop"; # .csv
            "text/yaml" = "nvim.desktop"; # .yaml, .yml
            "application/json" = "nvim.desktop"; # .json
            "application/ld+json" = "nvim.desktop"; # .jsonld
            "text/xml" = "nvim.desktop"; # .xml
            "application/x-toml" = "nvim.desktop"; # .toml
            "text/ini" = "nvim.desktop"; # .ini

            # Markdown / LaTeX / Documentation
            "text/markdown" = "firefox.desktop"; # .md
            "text/x-markdown" = "nvim.desktop"; # fallback
            "application/x-tex" = "nvim.desktop"; # .tex
            "application/vnd.latex-x" = "nvim.desktop"; # some tex MIME

            # Others / Misc
            "text/x-dockerfile" = "nvim.desktop"; # Dockerfile
            "text/x-makefile" = "nvim.desktop"; # Makefile
            "text/x-cmake" = "nvim.desktop"; # CMakeLists.txt
          };
        };
        # desktopEntries.image-roll = {
        #   name = "image-roll";
        #   exec = "${stable.image-roll}/bin/image-roll %F";
        #   mimeType = [ "image/*" ];
        # };
        # desktopEntries.gmail = {
        #   name = "Gmail";
        #   exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
        #   mimeType = [ "x-scheme-handler/mailto" ];
        # };
      };
    };
  };
}
