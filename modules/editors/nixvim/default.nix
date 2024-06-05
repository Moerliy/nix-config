#
#  Neovim in nix config
#
{
  config,
  lib,
  vars,
  nixvim,
  system,
  pkgs,
  ...
}: let
in
  with lib; {
    options.nixvim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable neovim in nix config.
          '';
      };
    };

    config = mkIf config.nixvim.enable {
      environment = {
        systemPackages = with pkgs; [
          go
          nodejs
          python3
          ripgrep
          zig
        ];
      };
      home-manager.users.${vars.user} = {
        home.packages = [
          (nixvim."${system}".makeNixvimWithModule {
            inherit pkgs;
            module = ./config;
          })
        ];
      };
    };
  }
