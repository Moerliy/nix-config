#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#
{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; # Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nix Packages
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    # User Environment Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable User Environment Manager
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # MacOS Package Management
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Asahi Apple Silicon
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Official Hyprland Flake
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland-nativ-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprhook = {
      url = "github:Hyprhook/Hyprhook";
      # url = "github:Moerliy/Hyprhook";
      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };

    # Hyprlock
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Hypridle
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    animated-wallpaper = {
      url = "github:Moerliy/Godot-SuperWallpaper-Template";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.hyprlock.follows = "hyprlock";
    };

    # GUB minecraft theme
    minegrub = {
      url = "github:Moerliy/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Fixes OpenGL With Other Distros.
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    minegrubx86 = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    bat-catppuccin = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    delta-catppuccin = {
      url = "github:catppuccin/delta";
      flake = false;
    };
    tokionight-nvim = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    home-manager-unstable,
    darwin,
    apple-silicon,
    animated-wallpaper,
    hyprland,
    hyprland-nativ-plugins,
    hyprhook,
    hyprlock,
    hypridle,
    minegrub,
    nixgl,
    minegrubx86,
    lanzaboote,
    bat-catppuccin,
    delta-catppuccin,
    tokionight-nvim,
    ...
  }:
  # Function telling flake which inputs to use
  let
    # Variables Used In Flake
    vars = {
      user = "moritzgleissner";
      location = "$HOME/.setup";
      terminal = "kitty";
      editor = "nvim";
    };
  in {
    # nixosConfigurations = (
    #   import ./hosts {
    #     inherit (nixpkgs) lib;
    #     inherit inputs nixpkgs nixpkgs-unstable nixos-hardware home-manager nur hyprland hyprlock hypridle hyprspace plasma-manager vars; # Inherit inputs
    #   }
    # );

    darwinConfigurations = (
      import ./darwin {
        inherit (nixpkgs) lib;
        inherit
          inputs
          nixpkgs
          nixpkgs-unstable
          home-manager-unstable
          darwin
          vars
          ;
      }
    );

    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit
          inputs
          nixpkgs
          hyprland
          hyprhook
          hypridle
          hyprland-nativ-plugins
          hyprlock
          nixpkgs-unstable
          home-manager
          home-manager-unstable
          apple-silicon
          vars
          animated-wallpaper
          minegrub
          minegrubx86
          lanzaboote
          ;
      }
    );

    homeConfigurations = (
      import ./nix {
        inherit (nixpkgs) lib;
        inherit
          inputs
          nixpkgs
          nixpkgs-unstable
          home-manager
          home-manager-unstable
          nixgl
          vars
          ;
      }
    );
  };
}
