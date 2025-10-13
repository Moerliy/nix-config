#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  apple-silicon,
  home-manager,
  catppuccin,
  home-manager-unstable,
  hyprland,
  hyprland-nativ-plugins,
  hyprhook,
  hypridle,
  hyprlock,
  hyprsunset,
  animated-wallpaper,
  vars,
  minegrub,
  minegrubx86,
  lanzaboote,
  ...
}:
let
  system = "aarch64-linux";
  pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-stable = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  home-manager = home-manager-unstable;
  # home-manager-stable = home-manager;
  lib = nixpkgs-unstable.lib;
in
{
  # Asahi Apple Silicon
  asahi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        vars
        system
        apple-silicon
        hyprland
        hyprland-nativ-plugins
        catppuccin
        hyprhook
        hypridle
        hyprlock
        hyprsunset
        animated-wallpaper
        pkgs-stable
        ;
      host = {
        hostName = "asahi";
        buildInMonitor = "eDP-1";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "DP-2";
        mainMonitorNumber = "0";
      };
    };
    modules = [
      ./asahi/asahi.nix
      ./configuration.nix
      minegrub.nixosModules.default
      catppuccin.nixosModules.catppuccin

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
  nvidia = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        vars
        system
        catppuccin
        hyprland
        hyprland-nativ-plugins
        hyprhook
        hypridle
        home-manager
        hyprlock
        hyprsunset
        animated-wallpaper
        pkgs-stable
        ;
      host = {
        hostName = "nvidia";
        mainMonitor = "DP-3";
        secondMonitor = "DP-2";
        mainMonitorNumber = "1";
      };
    };
    modules = [
      ./nvidia/nvidia.nix
      ./configuration.nix
      # minegrubx86.nixosModules.default
      lanzaboote.nixosModules.lanzaboote
      catppuccin.nixosModules.catppuccin

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
