#
#  These are the different profiles that can be used when building on NixOS
#
#  flake.nix
#   └─ ./hosts
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
  grim-hyprland,
  hyprsunset,
  animated-wallpaper,
  bacon-ls,
  vars,
  minegrub,
  minegrubx86,
  lanzaboote,
  ...
}:
let
  # Helper to instantiate a pkgs set for a given nixpkgs input and system.
  # nixpkgs-unstable is the default pkgs used by the NixOS module system (via lib.nixosSystem).
  # nixpkgs (stable) is available as pkgs-stable in every host's specialArgs and
  # home-manager.extraSpecialArgs for selectively pinning packages that break on unstable.
  mkPkgs = nixpkgsInput: system: import nixpkgsInput {
    inherit system;
    config.allowUnfree = true;
  };

  # lib comes from nixpkgs-unstable; it is architecture-agnostic so one copy suffices.
  inherit (nixpkgs-unstable) lib;
in
{
  # Asahi Apple Silicon — aarch64-linux
  asahi =
    let
      system = "aarch64-linux";
      pkgs-stable = mkPkgs nixpkgs system;
    in
    lib.nixosSystem {
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
        (_: {
          nixpkgs.overlays = [
            # hyprland.overlays.default
            grim-hyprland.overlays.default
            bacon-ls.overlay.${system}
            (import ../packages)

            # (final: prev: {
            #   hyprgraphics = prev.hyprgraphics.overrideAttrs (old: {
            #     separateDebugInfo = true;
            #     dontStrip = true;
            #     NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -O0 -g";
            #     CMAKE_BUILD_TYPE = "Debug";
            #   });
            #
            #   hyprland = prev.hyprland.override { debug = true; };
            # })
          ];
        })
        ./asahi/asahi.nix
        ./configuration.nix
        minegrub.nixosModules.default
        catppuccin.nixosModules.catppuccin

        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  # NVIDIA desktop — x86_64-linux
  nvidia =
    let
      system = "x86_64-linux";
      pkgs-stable = mkPkgs nixpkgs system;
    in
    lib.nixosSystem {
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
        (_: {
          nixpkgs.overlays = [
            grim-hyprland.overlays.default
            bacon-ls.overlay.${system}
            (import ../packages)
          ];
        })
        ./nvidia/nvidia.nix
        ./configuration.nix
        # minegrubx86.nixosModules.default
        lanzaboote.nixosModules.lanzaboote
        catppuccin.nixosModules.catppuccin

        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
