#
#  Git
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib; {
  options.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable the Git package.
        '';
    };
  };

  config = mkIf config.git.enable {
    home-manager.users.${vars.user} = {
      programs = {
        git = {
          enable = true;
          userName = "Moritz Gleissner";
          userEmail = "moritz@gleissner.de";
          includes = [
            {
              path =
                pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "delta";
                  rev = "main";
                  sha256 = "sha256-JvkTvAe1YltgmYSHeewzwg6xU38oGOIYoehXdHwW1zI=";
                }
                + "/catppuccin.gitconfig";
            }
            {
              path =
                pkgs.fetchFromGitHub {
                  owner = "folke";
                  repo = "tokyonight.nvim";
                  rev = "main";
                  sha256 = "sha256-vKXlFHzga9DihzDn+v+j3pMNDfvhYHcCT8GpPs0Uxgg=";
                }
                + "/extras/delta/tokyonight_night.gitconfig";
            }
          ];
          delta = {
            enable = true;
            options = {
              navigate = true;
              light = false;
              side-by-side = false;
              line-numbers = true;
              syntax-theme = "catppuccin-mocha";
              # syntax-theme = "tokyonight_night";
            };
          };
          extraConfig = {
            pull = {
              rebase = true;
            };
            push = {
              default = "upstream";
            };
            color = {
              ui = true;
              branch = true;
              diff = true;
              status = true;
              interactive = true;
            };
            merge = {
              conflictstyle = "diff3";
            };
            rebase = {
              autosquash = true;
            };
            init = {
              defaultbranch = "main";
            };
          };
        };
      };
      home.packages = with pkgs; [
        lucky-commit
      ];
    };
  };
}
