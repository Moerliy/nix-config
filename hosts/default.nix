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
  home-manager-unstable,
  hyprland,
  vars,
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
  home-manager-stable = home-manager;
  lib = nixpkgs-unstable.lib;
  #lib = nixpkgs.lib;
in {
  # Asahi Apple Silicon
  asahi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs vars apple-silicon hyprland;
      host = {
        hostName = "moritzgleissner";
        # mainMonitor = "";
        # secoundMonitor = "";
      };
    };
    modules = [
      ./asahi/asahi.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
