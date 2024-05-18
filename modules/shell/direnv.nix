#
#  Direnv
#
#  Create shell.nix
#  Create .envrc and add "use nix"
#  Add 'eval "$(direnv hook zsh)"' to .zshrc
#
{
  lib,
  config,
  vars,
  ...
}:
with lib; {
  options.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        mdDoc
        ''
          Enable direnv,that is an extension for your shell.
          It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.
        '';
    };
  };

  config = mkIf config.direnv.enable {
    home-manager.users.${vars.user} = {
      programs = {
        direnv = {
          enable = true;
          loadInNixShell = true;
          nix-direnv.enable = true;
        };
      };
    };
  };
}
