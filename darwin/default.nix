#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#

{ inputs, nixpkgs-unstable, darwin, home-manager-unstable, vars, ... }:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  # MacBook M1
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs vars; };
    modules = [
      ./macbook.nix

      home-manager-unstable.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
