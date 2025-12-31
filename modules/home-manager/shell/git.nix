#
#  Git
#
{
  config,
  lib,
  vars,
  pkgs,
  inputs,
  ...
}:
with lib;
{
  options.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the Git package.
      '';
    };
  };

  config = mkIf config.git.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Moritz Gleissner";
            email = "moritz@gleissner.de";
          };
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
        includes = [
          {
            path = inputs.delta-catppuccin + "/catppuccin.gitconfig";
          }
          {
            path = inputs.tokionight-nvim + "/extras/delta/tokyonight_night.gitconfig";
          }
        ];
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = false;
          line-numbers = true;
          syntax-theme = "catppuccin-mocha";
          # syntax-theme = "tokyonight_night";
        };
      };
    };
    home.packages = with pkgs; [
      lucky-commit
    ];
  };
}
