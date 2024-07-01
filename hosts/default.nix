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
  nixvim,
  apple-silicon,
  home-manager,
  home-manager-unstable,
  hyprland,
  hyprhook,
  hypridle,
  hyprlock,
  vars,
  minegrub,
  ...
}: let
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
in {
  # Asahi Apple Silicon
  asahi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs vars system nixvim apple-silicon hyprland hyprhook hypridle hyprlock pkgs-stable;
      host = {
        hostName = "asahi";
        buildInMonitor = "eDP-1";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "DP-2";
      };
    };
    modules = [
      ./asahi/asahi.nix
      ./configuration.nix
      minegrub.nixosModules.default

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
