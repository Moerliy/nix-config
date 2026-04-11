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
  vars,
}:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-unstable
    apple-silicon
    catppuccin
    home-manager-unstable
    hyprland
    hyprland-nativ-plugins
    hyprhook
    hypridle
    hyprlock
    grim-hyprland
    hyprsunset
    animated-wallpaper
    bacon-ls
    minegrub
    minegrubx86
    lanzaboote
    delta-catppuccin
    tokionight-nvim
    bat-catppuccin
    ;

  # Helper to instantiate a pkgs set for a given nixpkgs input and system.
  # nixpkgs-unstable is the default pkgs used by the NixOS module system (via lib.nixosSystem).
  # nixpkgs (stable) is available as pkgs-stable in every host's specialArgs and
  # home-manager.extraSpecialArgs for selectively pinning packages that break on unstable.
  mkPkgs =
    nixpkgsInput: system:
    import nixpkgsInput {
      inherit system;
      config.allowUnfree = true;
    };

  # lib comes from nixpkgs-unstable; it is architecture-agnostic so one copy suffices.
  inherit (nixpkgs-unstable) lib;

  shared-flake-inputs = {
    inherit
      catppuccin
      delta-catppuccin
      tokionight-nvim
      bat-catppuccin
      ;
  };

  # Overlay that injects hypr-ecosystem packages not covered by their own
  # flake overlay.  Named without hyphens so they can be accessed as plain
  # pkgs attributes (e.g. pkgs.hyprhook).
  mkHyprOverlay =
    system:
    (final: prev: {
      inherit (hyprland.packages.${system}) hyprland;
      inherit (hyprland.packages.${system}) xdg-desktop-portal-hyprland;
      inherit (hyprhook.packages.${system}) hyprhook;
      inherit (hypridle.packages.${system}) hypridle;
      inherit (hyprlock.packages.${system}) hyprlock;
      inherit (hyprsunset.packages.${system}) hyprsunset;
      inherit (hyprland-nativ-plugins.packages.${system}) hyprwinwrap;
      animatedWallpaper = animated-wallpaper.packages.${system}.default;
      hyprlockWrapped = animated-wallpaper.packages.${system}.hyprlockWrapper;
    });

  # Per-host filtered flake inputs — only the inputs each host actually needs.
  # Passed as `inputs` in specialArgs so host modules use inputs.<name>.
  asahi-flake-inputs = {
    inherit
      apple-silicon
      ;
  };

  nvidia-flake-inputs = {
  };
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
          vars
          system
          pkgs-stable
          ;
        inputs = asahi-flake-inputs // shared-flake-inputs;
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
            hyprland.overlays.default # hyprland provides its own nixpkgs overlay
            grim-hyprland.overlays.default
            (mkHyprOverlay system) # manual overlay for flakes without their own overlay

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
          home-manager = {
            users.${vars.user} = {
              imports = import ../modules/home-manager ++ [
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [ hyprland.homeManagerModules.default ];
          };
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
          vars
          system
          pkgs-stable
          ;
        inputs = nvidia-flake-inputs // shared-flake-inputs;
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
            # hyprland.overlays.default # hyprland provides its own nixpkgs overlay
            (mkHyprOverlay system) # manual overlay for flakes without their own overlay
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
          home-manager = {
            users.${vars.user} = {
              imports = import ../modules/home-manager ++ [
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [ hyprland.homeManagerModules.default ];
          };
        }
      ];
    };
}
