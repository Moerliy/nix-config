{
  pkgs,
  config,
  lib,
  vars,
  ...
}: let
  # if ./config/secrets exists, add it to the configFilesToLink
  configFilesToLink =
    if lib.pathExists ./config/secrets
    then {
      "nvim/init.lua" = ./config/init.lua;
      "nvim/secrets" = ./config/secrets;
      "nviml/lua" = ./config/lua;
      "nvim/stylelua.toml" = ./config/stylua.toml;
    }
    else {
      "nvim/init.lua" = ./config/init.lua;
      "nvim/lua" = ./config/lua;
      "nvim/stylelua.toml" = ./config/stylua.toml;
    };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in
  with lib; {
    options.neovim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable neovim configuration.
          '';
      };
    };

    config = mkIf config.neovim.enable {
      home-manager.users.${vars.user} = {
        programs = {
          neovim = {
            enable = true;
            withNodeJs = true;
            viAlias = true;
            vimAlias = true;
            withPython3 = true;
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
        home.packages = with pkgs; [
          # lsp
          lua-language-server
          selene
          lua52Packages.luacheck
          shellcheck
          shfmt
          nodePackages.typescript-language-server
          nodePackages.vue-language-server
          # nodePackages_latest.grammarly-languageserver
          kotlin-language-server
          ktlint
          nil
          nixpkgs-fmt
          ruff-lsp
          pyright
          taplo
          dockerfile-language-server-nodejs
          yaml-language-server
          marksman
          docker-compose-language-service
          vscode-langservers-extracted
          nodePackages.bash-language-server

          git
          lazygit
          ripgrep
          fd
          fzf
          clang
          unzip

          nodejs
          python3
          cmake
          gnumake
          #gcc
          yq-go
          # yq
          # jq

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
        ];
      };
    };
  }
