#
#  Rofi window switcher, application launcher and dmenu replacement
#
{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
let
  configFilesToLink = {
    "rofi/catppuccin-mocha.rasi" = ./catppuccin-mocha.rasi;
    "rofi/launcher.rasi" = ./launcher.rasi;
    "rofi/volume-ctl.rasi" = ./volume-ctl.rasi;
    "rofi/bin" = ./bin;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: { source = dotfilesPath; };
in
with lib;
{
  options.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable rofi a window switcher, application launcher and dmenu replacement.
      '';
    };
  };

  config = mkIf config.rofi.enable {
    home-manager.users.${vars.user} = {
      programs = {
        rofi = {
          enable = true;
          package = pkgs.rofi;
          cycle = true;
          terminal = "${pkgs.${vars.terminal}}/bin/${vars.terminal}";
          font = "JetBrainsMono Nerd Font 11";
          theme = "~/.config/rofi/launcher.rasi";
        };
      };
      xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
    };
  };
}
