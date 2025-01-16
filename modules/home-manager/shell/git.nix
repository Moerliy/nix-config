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
    programs = {
      git = {
        enable = true;
        userName = "Moritz Gleissner";
        userEmail = "moritz@gleissner.de";
        includes = [
          {
            path =
              inputs.delta-catppuccin
              + "/catppuccin.gitconfig";
          }
          {
            path =
              inputs.tokionight-nvim
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
}
