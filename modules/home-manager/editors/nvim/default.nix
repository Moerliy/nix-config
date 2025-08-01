{
  pkgs,
  config,
  lib,
  vars,
  host,
  pkgs-stable,
  ...
}: let
  configFilesToLink = {
    "nvim/init.lua" = ./config/init.lua;
    "nvim/lua/plugins" = ./config/lua/plugins;
    "nvim/lua/util" = ./config/lua/util;
    "nvim/lua/config/autocmds.lua" = ./config/lua/config/autocmds.lua;
    "nvim/lua/config/lazy.lua" = ./config/lua/config/lazy.lua;
    "nvim/lua/config/keymaps.lua" = ./config/lua/config/keymaps.lua;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};

  customNodePkg = import ../../../../node/default.nix {};
in
  with lib;
  with host; {
    options.neovim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Enable neovim configuration.
        '';
      };
    };

    config = mkIf config.neovim.enable {
      programs = {
        neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;
          withNodeJs = true;
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
        };
      };
      # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
      xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      home = {
        file = {
          ".config/nvim/lua/config/options.lua" = {
            text =
              (builtins.readFile ./config/lua/config/options.lua)
              + ''
                opt.shell = ${
                  if hostName == "hht"
                  then "zsh"
                  else "fish"
                }
              '';
          };
        };
        packages = let
          omnisharp-wrapper = pkgs.stdenv.mkDerivation {
            pname = "omnisharp-wrapper";
            version = "1.0";

            src = pkgs.emptyDirectory;

            dontUnpack = true;

            installPhase = ''
              mkdir -p $out/bin
              ln -s ${pkgs.omnisharp-roslyn}/bin/OmniSharp $out/bin/omnisharp
            '';
          };
        in
          with pkgs;
            [
              # lsp
              lua-language-server
              selene
              lua52Packages.luacheck
              stylua
              shellcheck
              shfmt
              nodePackages.typescript-language-server
              customNodePkg."@vue/language-server"
              customNodePkg."@vtsls/language-server"
              # nodePackages_latest.grammarly-languageserver
              kotlin-language-server
              ktlint
              nil
              nixpkgs-fmt
              haskell-language-server
              haskellPackages.haskell-debug-adapter
              ghc
              cabal-install
              haskellPackages.stack
              csharpier
              omnisharp-wrapper
              # omnisharp-roslyn

              clang-tools
              # ruff-lsp
              ruff
              pyright
              taplo
              dockerfile-language-server-nodejs
              yaml-language-server
              marksman
              markdownlint-cli2
              docker-compose-language-service
              vscode-langservers-extracted
              nodePackages.bash-language-server
              nodePackages.prettier
              neocmakelsp
              cmake-format
              black
              isort
              python312Packages.debugpy
              hadolint
              rust-analyzer
              texlab
              dotnet-sdk
              netcoredbg

              git
              lazygit
              ripgrep
              fd
              fzf
              clang
              unzip
              neo
              pipes
              dwt1-shell-color-scripts # Shell Color Scripts

              nodejs
              python3
              cmake
              gnumake
              #gcc
              yq-go
              # yq
              # jq
              # flutter

              #rustup
              cargo
              rustc
              # nix-shell -p pkg-config sqlite openssl libiconv
              libiconv
              pkg-config
              sqlite
              openssl

              clang-tools
              luajitPackages.luarocks
              nil
              nixd
              go
              gnupg
            ]
            ++ (with pkgs-stable; [
              # haskellPackages.ghcup
              texliveFull
            ]);
      };
    };
  }
