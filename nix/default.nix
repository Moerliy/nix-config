#
#  These are the diffent profiles that can be used when using Nix on other distros.
#  Home-Manager is used to list and customize packages.
#
#  flake.nix
#   └─ ./nix
#       ├─ default.nix *
#       └─ <host>.nix
#
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  home-manager-unstable,
  vars,
  catppuccin,
  nixgl,
  ...
}:
let
  system = "x86_64-linux";
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
  inherit (nixpkgs-unstable) lib;
  vars.user = "ughlu_gleissner";
in
{
  hht = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit
        inputs
        vars
        system
        pkgs-stable
        nixgl
        ;
      host = {
        hostName = "hht";
      };
    };
    modules = [
      ./hht.nix
      catppuccin.homeModules.catppuccin
      {
      }
    ];
  };
}
